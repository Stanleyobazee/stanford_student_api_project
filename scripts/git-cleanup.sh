#!/bin/bash

echo "=== Git Repository Cleanup ==="
echo "Removing large files and directories from Git history"
echo

# Remove large directories from Git cache
echo "Removing cached large directories..."
git rm -r --cached screenshots/ 2>/dev/null || true
git rm -r --cached local_archive/ 2>/dev/null || true
git rm -r --cached .vagrant/ 2>/dev/null || true
git rm -r --cached postgres_data/ 2>/dev/null || true
git rm -r --cached logs/ 2>/dev/null || true
git rm -r --cached node_modules/ 2>/dev/null || true

# Clean Git history
echo "Cleaning Git history..."
git gc --aggressive --prune=now

echo "=== Git Cleanup Complete ==="
echo "Commit and push changes to apply .gitignore updates"