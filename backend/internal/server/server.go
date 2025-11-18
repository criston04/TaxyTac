package server

import (
	"context"
	"net/http"

	"github.com/criston04/TaxyTac/backend/internal/middleware"
	"github.com/gin-gonic/gin"
	"github.com/go-redis/redis/v8"
	"github.com/jackc/pgx/v5/pgxpool"
	"github.com/sirupsen/logrus"
)

type Config struct {
	Port      string
	Database  string
	Redis     string
	JWTSecret string
}

type Server struct {
	ctx    context.Context
	cfg    Config
	log    *logrus.Logger
	engine *gin.Engine
	db     *pgxpool.Pool
	redis  *redis.Client
}

func New(ctx context.Context, cfg Config, log *logrus.Logger) (*Server, error) {
	// Configurar Gin
	gin.SetMode(gin.ReleaseMode)
	engine := gin.New()
	engine.Use(gin.Recovery())
	engine.Use(corsMiddleware())

	// Rate limiting: 100 requests por minuto por IP
	rateLimiter := middleware.NewRateLimiter(100)
	engine.Use(rateLimiter.Middleware())

	engine.Use(loggerMiddleware(log))

	// Conectar a PostgreSQL
	dbpool, err := pgxpool.New(ctx, cfg.Database)
	if err != nil {
		return nil, err
	}

	// Verificar conexión a DB
	if err := dbpool.Ping(ctx); err != nil {
		return nil, err
	}
	log.Info("Connected to PostgreSQL")

	// Conectar a Redis
	opt, err := redis.ParseURL("redis://" + cfg.Redis)
	if err != nil {
		opt = &redis.Options{
			Addr: cfg.Redis,
		}
	}
	rdb := redis.NewClient(opt)

	// Verificar conexión a Redis
	if err := rdb.Ping(ctx).Err(); err != nil {
		return nil, err
	}
	log.Info("Connected to Redis")

	s := &Server{
		ctx:    ctx,
		cfg:    cfg,
		log:    log,
		engine: engine,
		db:     dbpool,
		redis:  rdb,
	}

	s.registerRoutes()

	return s, nil
}

func (s *Server) Run(addr string) error {
	return http.ListenAndServe(addr, s.engine)
}

func (s *Server) registerRoutes() {
	// Health check
	s.engine.GET("/health", s.HealthCheck)

	// API v1
	api := s.engine.Group("/api")
	{
		// Auth
		auth := api.Group("/auth")
		{
			auth.POST("/register", s.Register)
			auth.POST("/login", s.Login)
		}

		// Drivers
		drivers := api.Group("/drivers")
		{
			drivers.GET("/nearby", s.GetDriversNearby)
		}

		// Trips
		trips := api.Group("/trips")
		{
			trips.POST("", s.CreateTrip)
			trips.PATCH("/:id/accept", s.AcceptTrip)
			trips.PATCH("/:id/start", s.StartTrip)
			trips.PATCH("/:id/end", s.EndTrip)
		}
	}

	// WebSocket endpoint for location updates
	s.engine.GET("/ws", s.HandleWebsocket)
}

func corsMiddleware() gin.HandlerFunc {
	return func(c *gin.Context) {
		c.Writer.Header().Set("Access-Control-Allow-Origin", "*")
		c.Writer.Header().Set("Access-Control-Allow-Credentials", "true")
		c.Writer.Header().Set("Access-Control-Allow-Headers", "Content-Type, Content-Length, Accept-Encoding, X-CSRF-Token, Authorization, accept, origin, Cache-Control, X-Requested-With")
		c.Writer.Header().Set("Access-Control-Allow-Methods", "POST, OPTIONS, GET, PUT, PATCH, DELETE")

		if c.Request.Method == "OPTIONS" {
			c.AbortWithStatus(204)
			return
		}

		c.Next()
	}
}

func loggerMiddleware(log *logrus.Logger) gin.HandlerFunc {
	return func(c *gin.Context) {
		start := c.Request.Context().Value("start")
		c.Next()

		log.WithFields(logrus.Fields{
			"method": c.Request.Method,
			"path":   c.Request.URL.Path,
			"status": c.Writer.Status(),
			"ip":     c.ClientIP(),
		}).Info("Request handled")

		_ = start
	}
}
