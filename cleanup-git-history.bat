@echo off
echo ===============================================
echo   Git History Cleanup - Remove Sensitive Files
echo ===============================================
echo.
echo This script will remove sensitive files from ALL git history:
echo - .env files
echo - Keystore files (*.jks, *.keystore)
echo - Base64 keystore files
echo - Debug keystores
echo.
echo WARNING: This will rewrite git history and cannot be undone!
echo Make sure you have a backup of your repository.
echo.
set /p confirm="Do you want to continue? (y/N): "
if /i "%confirm%" neq "y" (
    echo Operation cancelled.
    exit /b 1
)

echo.
echo === Step 1: Creating backup ===
git branch backup-before-cleanup
echo Created backup branch: backup-before-cleanup

echo.
echo === Step 2: Removing sensitive files from history ===

REM Remove .env files
echo Removing .env files from history...
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch .env" --prune-empty --tag-name-filter cat -- --all

REM Remove keystore files
echo Removing keystore files from history...
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch *.jks *.keystore *keystore* keystore-base64.txt debug.keystore release-keystore.jks" --prune-empty --tag-name-filter cat -- --all

echo.
echo === Step 3: Cleaning up references ===
git for-each-ref --format="delete %%(refname)" refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now --aggressive

echo.
echo === Step 4: Updating .gitignore ===
echo # Sensitive files >> .gitignore
echo .env >> .gitignore
echo .env.* >> .gitignore
echo *.keystore >> .gitignore
echo *.jks >> .gitignore
echo keystore-base64.txt >> .gitignore
echo debug.keystore >> .gitignore
echo release-keystore.jks >> .gitignore

echo.
echo === Step 5: Verification ===
echo Checking if sensitive files still exist in history...
git log --all --full-history -- .env *.jks *.keystore *keystore* keystore-base64.txt

echo.
echo ===============================================
echo   CLEANUP COMPLETE
echo ===============================================
echo.
echo Next steps:
echo 1. Review the changes: git log --oneline
echo 2. Force push to remote: git push --force-with-lease origin --all
echo 3. Force push tags: git push --force-with-lease origin --tags
echo 4. Notify collaborators to re-clone the repository
echo.
echo IMPORTANT: 
echo - All contributors must re-clone the repository
echo - Old clones will have outdated history
echo - GitHub/remote will show different commit hashes
echo.
pause