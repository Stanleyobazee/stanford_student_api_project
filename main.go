package main

import (
	"log"
	"os"

	"stanford-uni-students-api/config"
	"stanford-uni-students-api/controllers"
	"stanford-uni-students-api/database"
	"stanford-uni-students-api/models"
	"stanford-uni-students-api/routes"

	"github.com/gin-gonic/gin"
	"github.com/joho/godotenv"
	"github.com/sirupsen/logrus"
)

func main() {
	// Load environment variables
	_ = godotenv.Load()

	// Load configuration
	cfg := config.Load()

	// Setup logger
	logger := logrus.New()
	level, err := logrus.ParseLevel(cfg.LogLevel)
	if err != nil {
		level = logrus.InfoLevel
	}
	logger.SetLevel(level)
	logger.SetFormatter(&logrus.JSONFormatter{})
	
	// Setup file logging if LOG_FILE is specified
	if cfg.LogFile != "" {
		file, err := os.OpenFile(cfg.LogFile, os.O_CREATE|os.O_WRONLY|os.O_APPEND, 0666)
		if err != nil {
			log.Fatalf("Failed to open log file: %v", err)
		}
		logger.SetOutput(file)
	}

	// Connect to database
	db, err := database.Connect(cfg.DatabaseURL, logger)
	if err != nil {
		log.Fatalf("Failed to connect to database: %v", err)
	}
	defer db.Close()

	// Run migrations
	if err := database.RunMigrations(db, logger); err != nil {
		log.Fatalf("Failed to run migrations: %v", err)
	}

	// Initialize repositories and controllers
	studentRepo := models.NewStudentRepository(db)
	studentController := controllers.NewStudentController(studentRepo, logger)
	healthController := controllers.NewHealthController(db, logger)

	// Setup Gin router
	r := gin.New()
	r.Use(gin.Logger())
	r.Use(gin.Recovery())

	// Setup routes
	routes.SetupRoutes(r, studentController, healthController)

	logger.WithField("port", cfg.Port).Info("Starting server")
	if err := r.Run(":" + cfg.Port); err != nil {
		log.Fatalf("Failed to start server: %v", err)
	}
}