package models

import (
	"database/sql"
	"time"
)

type Student struct {
	ID        int       `json:"id" db:"id"`
	FirstName string    `json:"first_name" db:"first_name"`
	LastName  string    `json:"last_name" db:"last_name"`
	Email     string    `json:"email" db:"email"`
	StudentID string    `json:"student_id" db:"student_id"`
	Major     string    `json:"major" db:"major"`
	Year      int       `json:"year" db:"year"`
	CreatedAt time.Time `json:"created_at" db:"created_at"`
	UpdatedAt time.Time `json:"updated_at" db:"updated_at"`
}

type StudentRepository struct {
	db *sql.DB
}

func NewStudentRepository(db *sql.DB) *StudentRepository {
	return &StudentRepository{db: db}
}

func (r *StudentRepository) Create(student *Student) error {
	query := `
		INSERT INTO students (first_name, last_name, email, student_id, major, year, created_at, updated_at)
		VALUES ($1, $2, $3, $4, $5, $6, NOW(), NOW())
		RETURNING id, created_at, updated_at`
	
	return r.db.QueryRow(query, student.FirstName, student.LastName, student.Email, 
		student.StudentID, student.Major, student.Year).Scan(&student.ID, &student.CreatedAt, &student.UpdatedAt)
}

func (r *StudentRepository) GetAll() ([]Student, error) {
	query := `SELECT id, first_name, last_name, email, student_id, major, year, created_at, updated_at FROM students ORDER BY id`
	rows, err := r.db.Query(query)
	if err != nil {
		return nil, err
	}
	defer rows.Close()

	var students []Student
	for rows.Next() {
		var student Student
		err := rows.Scan(&student.ID, &student.FirstName, &student.LastName, &student.Email,
			&student.StudentID, &student.Major, &student.Year, &student.CreatedAt, &student.UpdatedAt)
		if err != nil {
			return nil, err
		}
		students = append(students, student)
	}
	return students, nil
}

func (r *StudentRepository) GetByID(id int) (*Student, error) {
	query := `SELECT id, first_name, last_name, email, student_id, major, year, created_at, updated_at FROM students WHERE id = $1`
	var student Student
	err := r.db.QueryRow(query, id).Scan(&student.ID, &student.FirstName, &student.LastName, &student.Email,
		&student.StudentID, &student.Major, &student.Year, &student.CreatedAt, &student.UpdatedAt)
	if err != nil {
		return nil, err
	}
	return &student, nil
}

func (r *StudentRepository) Update(student *Student) error {
	query := `
		UPDATE students 
		SET first_name = $2, last_name = $3, email = $4, student_id = $5, major = $6, year = $7, updated_at = NOW()
		WHERE id = $1
		RETURNING updated_at`
	
	return r.db.QueryRow(query, student.ID, student.FirstName, student.LastName, student.Email,
		student.StudentID, student.Major, student.Year).Scan(&student.UpdatedAt)
}

func (r *StudentRepository) Delete(id int) error {
	query := `DELETE FROM students WHERE id = $1`
	result, err := r.db.Exec(query, id)
	if err != nil {
		return err
	}
	
	rowsAffected, err := result.RowsAffected()
	if err != nil {
		return err
	}
	
	if rowsAffected == 0 {
		return sql.ErrNoRows
	}
	
	return nil
}