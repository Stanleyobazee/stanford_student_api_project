package controllers

import (
	"database/sql"
	"net/http"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type HealthController struct {
	db     *sql.DB
	logger *logrus.Logger
}

func NewHealthController(db *sql.DB, logger *logrus.Logger) *HealthController {
	return &HealthController{
		db:     db,
		logger: logger,
	}
}

func (h *HealthController) HealthCheck(ctx *gin.Context) {
	status := "healthy"
	dbStatus := "connected"

	if err := h.db.Ping(); err != nil {
		h.logger.WithError(err).Error("Database connection failed")
		status = "unhealthy"
		dbStatus = "disconnected"
		ctx.JSON(http.StatusServiceUnavailable, gin.H{
			"status":    status,
			"database":  dbStatus,
			"service":   "stanford-uni-students-api",
		})
		return
	}

	h.logger.Info("Health check passed")
	ctx.JSON(http.StatusOK, gin.H{
		"status":   status,
		"database": dbStatus,
		"service":  "stanford-uni-students-api",
	})
}