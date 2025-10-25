#!/bin/bash

echo "=== EC2 Existing Files Cleanup ==="
echo "Removing large directories already pulled to EC2"
echo

cd stanford_student_api_project

# Remove large directories
echo "Removing large directories..."
rm -rf screenshots/
rm -rf local_archive/
rm -rf .vagrant/
rm -rf postgres_data/
rm -rf logs/
rm -rf node_modules/
rm -rf .cache/
rm -rf __pycache__/

# Remove build artifacts
echo "Removing build artifacts..."
find . -name "*.tar" -delete
find . -name "*.zip" -delete
find . -name "*.gz" -delete
find . -name "*.log" -delete
find . -name "*.pyc" -delete

echo "=== EC2 Files Cleanup Complete ==="