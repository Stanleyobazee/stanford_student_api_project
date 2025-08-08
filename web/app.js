const API_BASE = '/api/v1';
let editingStudent = null;

// Load students when page loads
document.addEventListener('DOMContentLoaded', function() {
    loadStudents();
    document.getElementById('student-form').addEventListener('submit', handleSubmit);
});

// Load all students
async function loadStudents() {
    try {
        const response = await fetch(`${API_BASE}/students`);
        const students = await response.json();
        displayStudents(students);
    } catch (error) {
        showMessage('Error loading students: ' + error.message, 'error');
    }
}

// Display students in table
function displayStudents(students) {
    const tbody = document.getElementById('students-tbody');
    tbody.innerHTML = '';
    
    students.forEach(student => {
        const row = document.createElement('tr');
        row.innerHTML = `
            <td>${student.id}</td>
            <td>${student.first_name} ${student.last_name}</td>
            <td>${student.email}</td>
            <td>${student.student_id}</td>
            <td>${student.major}</td>
            <td>${student.year}</td>
            <td class="actions">
                <button class="edit-btn" onclick="editStudent(${student.id})">Edit</button>
                <button class="delete-btn" onclick="deleteStudent(${student.id})">Delete</button>
            </td>
        `;
        tbody.appendChild(row);
    });
}

// Handle form submission
async function handleSubmit(e) {
    e.preventDefault();
    
    const studentData = {
        first_name: document.getElementById('first-name').value,
        last_name: document.getElementById('last-name').value,
        email: document.getElementById('email').value,
        student_id: document.getElementById('student-id-field').value,
        major: document.getElementById('major').value,
        year: parseInt(document.getElementById('year').value)
    };

    try {
        let response;
        if (editingStudent) {
            // Update existing student
            response = await fetch(`${API_BASE}/students/${editingStudent}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(studentData)
            });
        } else {
            // Create new student
            response = await fetch(`${API_BASE}/students`, {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify(studentData)
            });
        }

        if (response.ok) {
            showMessage(editingStudent ? 'Student updated successfully!' : 'Student added successfully!', 'success');
            resetForm();
            loadStudents();
        } else {
            const error = await response.json();
            showMessage('Error: ' + error.error, 'error');
        }
    } catch (error) {
        showMessage('Error: ' + error.message, 'error');
    }
}

// Edit student
async function editStudent(id) {
    console.log('Edit student clicked, ID:', id);
    try {
        const response = await fetch(`${API_BASE}/students/${id}`);
        console.log('Fetch response status:', response.status);
        
        if (response.ok) {
            const student = await response.json();
            console.log('Student data:', student);
            
            document.getElementById('student-id').value = student.id;
            document.getElementById('first-name').value = student.first_name;
            document.getElementById('last-name').value = student.last_name;
            document.getElementById('email').value = student.email;
            document.getElementById('student-id-field').value = student.student_id;
            document.getElementById('major').value = student.major;
            document.getElementById('year').value = student.year;
            
            editingStudent = id;
            document.getElementById('form-title').textContent = 'Edit Student';
            document.getElementById('submit-btn').textContent = 'Update Student';
            document.getElementById('cancel-btn').style.display = 'inline-block';
            
            // Scroll to form
            document.getElementById('student-form').scrollIntoView({ behavior: 'smooth' });
        } else {
            const errorData = await response.text();
            console.log('Error response:', errorData);
            showMessage('Error loading student details', 'error');
        }
    } catch (error) {
        console.log('Edit error:', error);
        showMessage('Error: ' + error.message, 'error');
    }
}

// Delete student
async function deleteStudent(id) {
    if (confirm('Are you sure you want to delete this student?')) {
        try {
            const response = await fetch(`${API_BASE}/students/${id}`, {
                method: 'DELETE'
            });
            
            if (response.ok) {
                showMessage('Student deleted successfully!', 'success');
                loadStudents();
            } else {
                showMessage('Error deleting student', 'error');
            }
        } catch (error) {
            showMessage('Error: ' + error.message, 'error');
        }
    }
}

// Reset form
function resetForm() {
    document.getElementById('student-form').reset();
    document.getElementById('student-id').value = '';
    editingStudent = null;
    document.getElementById('form-title').textContent = 'Add New Student';
    document.getElementById('submit-btn').textContent = 'Add Student';
    document.getElementById('cancel-btn').style.display = 'none';
}

// Show message
function showMessage(message, type) {
    const messageDiv = document.getElementById('message');
    messageDiv.innerHTML = `<div class="message ${type}">${message}</div>`;
    setTimeout(() => {
        messageDiv.innerHTML = '';
    }, 5000);
}