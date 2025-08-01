package tests

import (
	"bytes"
	"database/sql"
	"encoding/json"
	"net/http"
	"net/http/httptest"
	"testing"

	"stanford-uni-students-api/controllers"
	"stanford-uni-students-api/models"

	"github.com/gin-gonic/gin"
	"github.com/sirupsen/logrus"
	"github.com/stretchr/testify/assert"
	"github.com/stretchr/testify/mock"
)

type MockStudentRepository struct {
	mock.Mock
}

func (m *MockStudentRepository) Create(student *models.Student) error {
	args := m.Called(student)
	if args.Get(0) != nil {
		*student = *args.Get(0).(*models.Student)
	}
	return args.Error(1)
}

func (m *MockStudentRepository) GetAll() ([]models.Student, error) {
	args := m.Called()
	return args.Get(0).([]models.Student), args.Error(1)
}

func (m *MockStudentRepository) GetByID(id int) (*models.Student, error) {
	args := m.Called(id)
	if args.Get(0) == nil {
		return nil, args.Error(1)
	}
	return args.Get(0).(*models.Student), args.Error(1)
}

func (m *MockStudentRepository) Update(student *models.Student) error {
	args := m.Called(student)
	return args.Error(0)
}

func (m *MockStudentRepository) Delete(id int) error {
	args := m.Called(id)
	return args.Error(0)
}

func setupTestController() (*controllers.StudentController, *MockStudentRepository) {
	mockRepo := new(MockStudentRepository)
	logger := logrus.New()
	logger.SetLevel(logrus.FatalLevel) // Suppress logs during tests
	
	controller := &controllers.StudentController{}
	// Note: In a real implementation, you'd need to modify the controller to accept an interface
	return controller, mockRepo
}

func TestCreateStudent(t *testing.T) {
	gin.SetMode(gin.TestMode)
	
	mockRepo := new(MockStudentRepository)
	logger := logrus.New()
	logger.SetLevel(logrus.FatalLevel)
	
	student := &models.Student{
		ID:        1,
		FirstName: "John",
		LastName:  "Doe",
		Email:     "john.doe@stanford.edu",
		StudentID: "CS001",
		Major:     "Computer Science",
		Year:      3,
	}
	
	mockRepo.On("Create", mock.AnythingOfType("*models.Student")).Return(student, nil)
	
	controller := controllers.NewStudentController(mockRepo, logger)
	
	router := gin.New()
	router.POST("/students", controller.CreateStudent)
	
	studentJSON, _ := json.Marshal(map[string]interface{}{
		"first_name": "John",
		"last_name":  "Doe",
		"email":      "john.doe@stanford.edu",
		"student_id": "CS001",
		"major":      "Computer Science",
		"year":       3,
	})
	
	req, _ := http.NewRequest("POST", "/students", bytes.NewBuffer(studentJSON))
	req.Header.Set("Content-Type", "application/json")
	
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)
	
	assert.Equal(t, http.StatusCreated, w.Code)
	mockRepo.AssertExpectations(t)
}

func TestGetAllStudents(t *testing.T) {
	gin.SetMode(gin.TestMode)
	
	mockRepo := new(MockStudentRepository)
	logger := logrus.New()
	logger.SetLevel(logrus.FatalLevel)
	
	students := []models.Student{
		{ID: 1, FirstName: "John", LastName: "Doe", Email: "john@stanford.edu"},
		{ID: 2, FirstName: "Jane", LastName: "Smith", Email: "jane@stanford.edu"},
	}
	
	mockRepo.On("GetAll").Return(students, nil)
	
	controller := controllers.NewStudentController(mockRepo, logger)
	
	router := gin.New()
	router.GET("/students", controller.GetAllStudents)
	
	req, _ := http.NewRequest("GET", "/students", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)
	
	assert.Equal(t, http.StatusOK, w.Code)
	mockRepo.AssertExpectations(t)
}

func TestGetStudentByID(t *testing.T) {
	gin.SetMode(gin.TestMode)
	
	mockRepo := new(MockStudentRepository)
	logger := logrus.New()
	logger.SetLevel(logrus.FatalLevel)
	
	student := &models.Student{
		ID:        1,
		FirstName: "John",
		LastName:  "Doe",
		Email:     "john@stanford.edu",
	}
	
	mockRepo.On("GetByID", 1).Return(student, nil)
	
	controller := controllers.NewStudentController(mockRepo, logger)
	
	router := gin.New()
	router.GET("/students/:id", controller.GetStudentByID)
	
	req, _ := http.NewRequest("GET", "/students/1", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)
	
	assert.Equal(t, http.StatusOK, w.Code)
	mockRepo.AssertExpectations(t)
}

func TestGetStudentByID_NotFound(t *testing.T) {
	gin.SetMode(gin.TestMode)
	
	mockRepo := new(MockStudentRepository)
	logger := logrus.New()
	logger.SetLevel(logrus.FatalLevel)
	
	mockRepo.On("GetByID", 999).Return(nil, sql.ErrNoRows)
	
	controller := controllers.NewStudentController(mockRepo, logger)
	
	router := gin.New()
	router.GET("/students/:id", controller.GetStudentByID)
	
	req, _ := http.NewRequest("GET", "/students/999", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)
	
	assert.Equal(t, http.StatusNotFound, w.Code)
	mockRepo.AssertExpectations(t)
}

func TestDeleteStudent(t *testing.T) {
	gin.SetMode(gin.TestMode)
	
	mockRepo := new(MockStudentRepository)
	logger := logrus.New()
	logger.SetLevel(logrus.FatalLevel)
	
	mockRepo.On("Delete", 1).Return(nil)
	
	controller := controllers.NewStudentController(mockRepo, logger)
	
	router := gin.New()
	router.DELETE("/students/:id", controller.DeleteStudent)
	
	req, _ := http.NewRequest("DELETE", "/students/1", nil)
	w := httptest.NewRecorder()
	router.ServeHTTP(w, req)
	
	assert.Equal(t, http.StatusNoContent, w.Code)
	mockRepo.AssertExpectations(t)
}