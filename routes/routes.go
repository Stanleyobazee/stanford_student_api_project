package routes

import (
	"stanford-uni-students-api/controllers"

	"github.com/gin-gonic/gin"
)

func SetupRoutes(r *gin.Engine, studentController *controllers.StudentController, healthController *controllers.HealthController) {
	// Health check endpoint
	r.GET("/healthcheck", healthController.HealthCheck)

	// API v1 routes
	v1 := r.Group("/api/v1")
	{
		students := v1.Group("/students")
		{
			students.POST("", studentController.CreateStudent)
			students.GET("", studentController.GetAllStudents)
			students.GET("/:id", studentController.GetStudentByID)
			students.PUT("/:id", studentController.UpdateStudent)
			students.DELETE("/:id", studentController.DeleteStudent)
		}
	}
}