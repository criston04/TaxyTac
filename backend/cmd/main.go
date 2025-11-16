package main

import (
	"context"
	"fmt"
	"os"
	"os/signal"
	"syscall"
	"time"

	"github.com/criston04/TaxyTac/backend/internal/server"
	"github.com/sirupsen/logrus"
)

func main() {
	log := logrus.New()
	log.SetFormatter(&logrus.JSONFormatter{})
	log.SetLevel(logrus.InfoLevel)

	ctx, cancel := context.WithCancel(context.Background())
	defer cancel()

	// Configuración del servidor
	port := getEnv("PORT", "8080")
	dbURL := getEnv("DATABASE_URL", "postgres://postgres:postgres@db:5432/taxytac?sslmode=disable")
	redisURL := getEnv("REDIS_URL", "redis:6379")
	jwtSecret := getEnv("JWT_SECRET", "devsecret")

	cfg := server.Config{
		Port:      port,
		Database:  dbURL,
		Redis:     redisURL,
		JWTSecret: jwtSecret,
	}

	log.WithFields(logrus.Fields{
		"port":  cfg.Port,
		"db":    cfg.Database,
		"redis": cfg.Redis,
	}).Info("Starting TaxyTac backend...")

	// Crear servidor
	srv, err := server.New(ctx, cfg, log)
	if err != nil {
		log.Fatalf("Failed to create server: %v", err)
	}

	// Canal para señales del sistema
	sigChan := make(chan os.Signal, 1)
	signal.Notify(sigChan, syscall.SIGINT, syscall.SIGTERM)

	// Ejecutar servidor en goroutine
	go func() {
		addr := fmt.Sprintf(":%s", port)
		log.Infof("Server listening on %s", addr)
		if err := srv.Run(addr); err != nil {
			log.Fatalf("Server error: %v", err)
		}
	}()

	// Esperar señal de terminación
	sig := <-sigChan
	log.Infof("Received signal: %v. Shutting down gracefully...", sig)

	// Graceful shutdown
	cancel()
	time.Sleep(2 * time.Second)
	log.Info("Server stopped")
}

func getEnv(key, defaultValue string) string {
	if value := os.Getenv(key); value != "" {
		return value
	}
	return defaultValue
}
