#!/bin/bash

echo "=== Removing Large Files from EC2 ==="

# Remove large directories
rm -rf stanford_student_api_project/screenshots/
rm -rf stanford_student_api_project/local_archive/
rm -rf stanford_student_api_project/.vagrant/
rm -rf stanford_student_api_project/postgres_data/
rm -rf stanford_student_api_project/logs/

echo "=== Large Files Removed ==="