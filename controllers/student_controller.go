package controllers

import (
	"database/sql"
	"net/http"
	"strconv"

	"stanford-uni-students-api/models"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
)

type StudentController struct {
	repo   models.StudentRepositoryInterface
	logger *logrus.Logger
}

func NewStudentController(repo models.StudentRepositoryInterface, logger *logrus.Logger) *StudentController {
	return &StudentController{
		repo:   repo,
		logger: logger,
	}
}

func (c *StudentController) CreateStudent(ctx *gin.Context) {
	var student models.Student
	if err := ctx.ShouldBindJSON(&student); err != nil {
		c.logger.WithError(err).Error("Failed to bind JSON")
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	if err := c.repo.Create(&student); err != nil {
		c.logger.WithError(err).Error("Failed to create student")
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to create student"})
		return
	}

	c.logger.WithField("student_id", student.ID).Info("Student created successfully")
	ctx.JSON(http.StatusCreated, student)
}

func (c *StudentController) GetAllStudents(ctx *gin.Context) {
	students, err := c.repo.GetAll()
	if err != nil {
		c.logger.WithError(err).Error("Failed to get all students")
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve students"})
		return
	}

	c.logger.WithField("count", len(students)).Info("Retrieved all students")
	ctx.JSON(http.StatusOK, students)
}

func (c *StudentController) GetStudentByID(ctx *gin.Context) {
	idParam := ctx.Param("id")
	id, err := strconv.Atoi(idParam)
	if err != nil {
		c.logger.WithError(err).Error("Invalid student ID")
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid student ID"})
		return
	}

	student, err := c.repo.GetByID(id)
	if err != nil {
		if err == sql.ErrNoRows {
			c.logger.WithField("id", id).Warn("Student not found")
			ctx.JSON(http.StatusNotFound, gin.H{"error": "Student not found"})
			return
		}
		c.logger.WithError(err).Error("Failed to get student")
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to retrieve student"})
		return
	}

	c.logger.WithField("student_id", id).Info("Retrieved student")
	ctx.JSON(http.StatusOK, student)
}

func (c *StudentController) UpdateStudent(ctx *gin.Context) {
	idParam := ctx.Param("id")
	id, err := strconv.Atoi(idParam)
	if err != nil {
		c.logger.WithError(err).Error("Invalid student ID")
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid student ID"})
		return
	}

	var student models.Student
	if err := ctx.ShouldBindJSON(&student); err != nil {
		c.logger.WithError(err).Error("Failed to bind JSON")
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid request body"})
		return
	}

	student.ID = id
	if err := c.repo.Update(&student); err != nil {
		if err == sql.ErrNoRows {
			c.logger.WithField("id", id).Warn("Student not found for update")
			ctx.JSON(http.StatusNotFound, gin.H{"error": "Student not found"})
			return
		}
		c.logger.WithError(err).Error("Failed to update student")
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to update student"})
		return
	}

	c.logger.WithField("student_id", id).Info("Student updated successfully")
	ctx.JSON(http.StatusOK, student)
}

func (c *StudentController) DeleteStudent(ctx *gin.Context) {
	idParam := ctx.Param("id")
	id, err := strconv.Atoi(idParam)
	if err != nil {
		c.logger.WithError(err).Error("Invalid student ID")
		ctx.JSON(http.StatusBadRequest, gin.H{"error": "Invalid student ID"})
		return
	}

	if err := c.repo.Delete(id); err != nil {
		if err == sql.ErrNoRows {
			c.logger.WithField("id", id).Warn("Student not found for deletion")
			ctx.JSON(http.StatusNotFound, gin.H{"error": "Student not found"})
			return
		}
		c.logger.WithError(err).Error("Failed to delete student")
		ctx.JSON(http.StatusInternalServerError, gin.H{"error": "Failed to delete student"})
		return
	}

	c.logger.WithField("student_id", id).Info("Student deleted successfully")
	ctx.JSON(http.StatusNoContent, nil)
}