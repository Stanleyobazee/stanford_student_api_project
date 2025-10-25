@echo off
echo Restoring deleted files from git history to local archive...

REM Navigate to project root
cd ..

REM Restore comprehensive documentation
git show HEAD~1:COMPREHENSIVE_README.md > local_archive\COMPREHENSIVE_README.md
git show HEAD~1:PROJECT_SUMMARY.md > local_archive\PROJECT_SUMMARY.md
git show HEAD~1:GIT_COMMIT_GUIDE.md > local_archive\GIT_COMMIT_GUIDE.md

REM Restore additional documentation
git show HEAD~1:CI-SETUP.md > local_archive\CI-SETUP.md
git show HEAD~1:DEPLOYMENT.md > local_archive\DEPLOYMENT.md
git show HEAD~1:SECURITY-FIXES.md > local_archive\SECURITY-FIXES.md
git show HEAD~1:TROUBLESHOOTING.md > local_archive\TROUBLESHOOTING.md
git show HEAD~1:UBUNTU-FIX.md > local_archive\UBUNTU-FIX.md

REM Restore utility scripts
git show HEAD~1:debug-fix.bat > local_archive\debug-fix.bat
git show HEAD~1:debug-fix.sh > local_archive\debug-fix.sh
git show HEAD~1:docker-build.sh > local_archive\docker-build.sh
git show HEAD~1:install-tools.sh > local_archive\install-tools.sh
git show HEAD~1:quick-start.sh > local_archive\quick-start.sh
git show HEAD~1:setup-runner.sh > local_archive\setup-runner.sh
git show HEAD~1:setup.sh > local_archive\setup.sh

echo.
echo Files restored to local_archive folder!
echo These files are now available locally for reference and educational purposes.
pause