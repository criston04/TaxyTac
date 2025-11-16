package server

import (
	"context"
	"encoding/json"
	"net/http"
	"time"

	"github.com/gin-gonic/gin"
	"github.com/google/uuid"
	"github.com/gorilla/websocket"
	"github.com/sirupsen/logrus"
)

var wsUpgrader = websocket.Upgrader{
	CheckOrigin: func(r *http.Request) bool { return true },
	ReadBufferSize:  1024,
	WriteBufferSize: 1024,
}

// LocationPayload representa la ubicación enviada por el driver
type LocationPayload struct {
	DriverID string  `json:"driver_id"`
	Lat      float64 `json:"lat"`
	Lng      float64 `json:"lng"`
	TS       int64   `json:"ts"`
	Speed    float64 `json:"speed,omitempty"`
	Heading  float64 `json:"heading,omitempty"`
}

// HealthCheck verifica el estado del servidor
func (s *Server) HealthCheck(c *gin.Context) {
	c.JSON(http.StatusOK, gin.H{
		"status": "ok",
		"time":   time.Now().Unix(),
	})
}

// Register crea un nuevo usuario (rider o driver)
func (s *Server) Register(c *gin.Context) {
	var body struct {
		Name  string `json:"name" binding:"required"`
		Phone string `json:"phone" binding:"required"`
		Email string `json:"email"`
		Role  string `json:"role" binding:"required"` // rider|driver
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid payload"})
		return
	}

	// Validar role
	if body.Role != "rider" && body.Role != "driver" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Role must be 'rider' or 'driver'"})
		return
	}

	// Crear usuario en DB
	userID := uuid.New().String()
	query := `
		INSERT INTO users (id, name, phone, email, role, created_at)
		VALUES ($1, $2, $3, $4, $5, now())
		RETURNING id
	`

	var returnedID string
	err := s.db.QueryRow(context.Background(), query,
		userID, body.Name, body.Phone, body.Email, body.Role).Scan(&returnedID)

	if err != nil {
		s.log.WithError(err).Error("Failed to create user")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create user"})
		return
	}

	// Si es driver, crear entrada en tabla drivers
	if body.Role == "driver" {
		driverQuery := `
			INSERT INTO drivers (id, user_id, status, rating, created_at)
			VALUES ($1, $2, 'offline', 0, now())
		`
		_, err := s.db.Exec(context.Background(), driverQuery, uuid.New().String(), userID)
		if err != nil {
			s.log.WithError(err).Error("Failed to create driver record")
		}
	}

	c.JSON(http.StatusCreated, gin.H{
		"id":   returnedID,
		"name": body.Name,
		"role": body.Role,
	})
}

// Login autentica un usuario (mock JWT)
func (s *Server) Login(c *gin.Context) {
	var body struct {
		Phone string `json:"phone" binding:"required"`
		OTP   string `json:"otp"`
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid payload"})
		return
	}

	// TODO: Verificar OTP real (Twilio, etc.)
	// Por ahora retornamos un token mock
	token := "mock.jwt.token." + body.Phone

	c.JSON(http.StatusOK, gin.H{
		"token":        token,
		"refresh_token": "mock.refresh.token",
		"expires_in":    900, // 15 minutos
	})
}

// GetDriversNearby busca drivers cercanos usando PostGIS
func (s *Server) GetDriversNearby(c *gin.Context) {
	lat := c.Query("lat")
	lng := c.Query("lng")
	radius := c.DefaultQuery("radius", "1000") // metros

	if lat == "" || lng == "" {
		c.JSON(http.StatusBadRequest, gin.H{"error": "lat and lng are required"})
		return
	}

	// Query PostGIS para drivers cercanos
	query := `
		SELECT 
			d.id,
			d.user_id,
			ST_Distance(
				l.geom, 
				ST_GeogFromText('SRID=4326;POINT(' || $1 || ' ' || $2 || ')')
			) AS distance_m,
			ST_Y(l.geom::geometry) AS lat,
			ST_X(l.geom::geometry) AS lng
		FROM drivers d
		JOIN locations l ON l.driver_id = d.id
		WHERE 
			d.status = 'available'
			AND l.ts > now() - INTERVAL '15 seconds'
			AND ST_DWithin(
				l.geom,
				ST_GeogFromText('SRID=4326;POINT(' || $1 || ' ' || $2 || ')'),
				$3
			)
		ORDER BY distance_m ASC
		LIMIT 20
	`

	rows, err := s.db.Query(context.Background(), query, lng, lat, radius)
	if err != nil {
		s.log.WithError(err).Error("Failed to query nearby drivers")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to query drivers"})
		return
	}
	defer rows.Close()

	type Driver struct {
		ID         string  `json:"driver_id"`
		UserID     string  `json:"user_id"`
		DistanceM  float64 `json:"distance_m"`
		Lat        float64 `json:"lat"`
		Lng        float64 `json:"lng"`
	}

	var drivers []Driver
	for rows.Next() {
		var d Driver
		if err := rows.Scan(&d.ID, &d.UserID, &d.DistanceM, &d.Lat, &d.Lng); err != nil {
			s.log.WithError(err).Warn("Failed to scan driver row")
			continue
		}
		drivers = append(drivers, d)
	}

	c.JSON(http.StatusOK, gin.H{
		"drivers": drivers,
		"count":   len(drivers),
	})
}

// CreateTrip crea una nueva solicitud de viaje
func (s *Server) CreateTrip(c *gin.Context) {
	var body struct {
		RiderID     string  `json:"rider_id" binding:"required"`
		OriginLat   float64 `json:"origin_lat" binding:"required"`
		OriginLng   float64 `json:"origin_lng" binding:"required"`
		DestLat     float64 `json:"dest_lat" binding:"required"`
		DestLng     float64 `json:"dest_lng" binding:"required"`
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid payload"})
		return
	}

	tripID := uuid.New().String()

	query := `
		INSERT INTO trips (id, rider_id, origin, destination, status, created_at)
		VALUES (
			$1, $2,
			ST_SetSRID(ST_MakePoint($3, $4)::geometry, 4326)::geography,
			ST_SetSRID(ST_MakePoint($5, $6)::geometry, 4326)::geography,
			'requested',
			now()
		)
		RETURNING id
	`

	var returnedID string
	err := s.db.QueryRow(context.Background(), query,
		tripID, body.RiderID, body.OriginLng, body.OriginLat, body.DestLng, body.DestLat).Scan(&returnedID)

	if err != nil {
		s.log.WithError(err).Error("Failed to create trip")
		c.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create trip"})
		return
	}

	c.JSON(http.StatusCreated, gin.H{
		"trip_id": returnedID,
		"status":  "requested",
	})
}

// AcceptTrip permite a un driver aceptar un viaje
func (s *Server) AcceptTrip(c *gin.Context) {
	tripID := c.Param("id")
	
	var body struct {
		DriverID string `json:"driver_id" binding:"required"`
	}

	if err := c.ShouldBindJSON(&body); err != nil {
		c.JSON(http.StatusBadRequest, gin.H{"error": "Invalid payload"})
		return
	}

	// Actualizar trip con driver_id y cambiar status a 'accepted'
	query := `
		UPDATE trips 
		SET driver_id = $1, status = 'accepted'
		WHERE id = $2 AND status = 'requested'
		RETURNING id
	`

	var returnedID string
	err := s.db.QueryRow(context.Background(), query, body.DriverID, tripID).Scan(&returnedID)

	if err != nil {
		s.log.WithError(err).Error("Failed to accept trip")
		c.JSON(http.StatusNotFound, gin.H{"error": "Trip not found or already accepted"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"trip_id": returnedID,
		"status":  "accepted",
	})
}

// StartTrip marca el inicio del viaje
func (s *Server) StartTrip(c *gin.Context) {
	tripID := c.Param("id")

	query := `
		UPDATE trips 
		SET status = 'started', started_at = now()
		WHERE id = $1 AND status = 'accepted'
		RETURNING id
	`

	var returnedID string
	err := s.db.QueryRow(context.Background(), query, tripID).Scan(&returnedID)

	if err != nil {
		s.log.WithError(err).Error("Failed to start trip")
		c.JSON(http.StatusNotFound, gin.H{"error": "Trip not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"trip_id": returnedID,
		"status":  "started",
	})
}

// EndTrip finaliza el viaje
func (s *Server) EndTrip(c *gin.Context) {
	tripID := c.Param("id")

	query := `
		UPDATE trips 
		SET status = 'completed', ended_at = now()
		WHERE id = $1 AND status = 'started'
		RETURNING id
	`

	var returnedID string
	err := s.db.QueryRow(context.Background(), query, tripID).Scan(&returnedID)

	if err != nil {
		s.log.WithError(err).Error("Failed to end trip")
		c.JSON(http.StatusNotFound, gin.H{"error": "Trip not found"})
		return
	}

	c.JSON(http.StatusOK, gin.H{
		"trip_id": returnedID,
		"status":  "completed",
	})
}

// HandleWebsocket maneja conexiones WebSocket para location updates
func (s *Server) HandleWebsocket(c *gin.Context) {
	conn, err := wsUpgrader.Upgrade(c.Writer, c.Request, nil)
	if err != nil {
		s.log.WithError(err).Warn("WS upgrade failed")
		return
	}
	defer conn.Close()

	s.log.Info("New WebSocket connection established")

	for {
		_, data, err := conn.ReadMessage()
		if err != nil {
			if websocket.IsUnexpectedCloseError(err, websocket.CloseGoingAway, websocket.CloseAbnormalClosure) {
				s.log.WithError(err).Warn("WS unexpected close")
			}
			return
		}

		var loc LocationPayload
		if err := json.Unmarshal(data, &loc); err != nil {
			s.log.WithError(err).Warn("Invalid WS payload")
			continue
		}

		// Publicar a Redis pub/sub (para otros servicios)
		ctx, cancel := context.WithTimeout(context.Background(), 500*time.Millisecond)
		err = s.redis.Publish(ctx, "locations", string(data)).Err()
		cancel()

		if err != nil {
			s.log.WithError(err).Warn("Failed to publish to Redis")
		}

		// Persistir snapshot asíncrono a PostgreSQL
		go s.persistLocation(loc)

		s.log.WithFields(logrus.Fields{
			"driver": loc.DriverID,
			"lat":    loc.Lat,
			"lng":    loc.Lng,
		}).Info("Location received")

		// Enviar ACK al cliente
		ack := map[string]interface{}{
			"status": "ok",
			"ts":     time.Now().Unix(),
		}
		if err := conn.WriteJSON(ack); err != nil {
			s.log.WithError(err).Warn("Failed to send ACK")
			return
		}
	}
}

func (s *Server) persistLocation(loc LocationPayload) {
	ctx, cancel := context.WithTimeout(context.Background(), 2*time.Second)
	defer cancel()

	query := `
		INSERT INTO locations (driver_id, geom, speed, heading, ts)
		VALUES (
			$1,
			ST_SetSRID(ST_MakePoint($2, $3)::geometry, 4326)::geography,
			$4,
			$5,
			to_timestamp($6 / 1000.0)
		)
	`

	_, err := s.db.Exec(ctx, query,
		loc.DriverID, loc.Lng, loc.Lat, loc.Speed, loc.Heading, loc.TS)

	if err != nil {
		s.log.WithError(err).Error("Failed to persist location")
	}
}
