# 🔒 Security Cleanup Guide - Remove Sensitive Files from Git History

## ⚠️ CRITICAL SECURITY ISSUE

Your repository contains sensitive files in git history:
- **`.env` file** (contains API keys and secrets)
- **`release-keystore.jks`** (Android signing keystore)
- **`keystore-base64.txt`** (Base64 encoded keystore)
- **`debug.keystore`** (Debug signing keystore)

These files must be removed from **ALL git history** immediately.

## 🚨 BEFORE YOU START

### **⚠️ Important Warnings:**
- **This will rewrite git history** - commit hashes will change
- **All collaborators must re-clone** the repository
- **Create a backup** before proceeding
- **This action cannot be undone**

### **📋 Prerequisites:**
- Java installed (for BFG Repo-Cleaner)
- Git command line access
- Repository backup

## 🛠️ Method 1: Using BFG Repo-Cleaner (Recommended)

### **Step 1: Download BFG Repo-Cleaner**
```bash
# Download BFG (or get from https://rtyley.github.io/bfg-repo-cleaner/)
curl -O https://repo1.maven.org/maven2/com/madgag/bfg/1.14.0/bfg-1.14.0.jar
```

### **Step 2: Create Fresh Clone**
```bash
# Clone a fresh copy (bare repository)
git clone --mirror https://github.com/USERNAME/letsstream-flutter-v2.git letsstream-flutter-v2-cleanup.git
cd letsstream-flutter-v2-cleanup.git
```

### **Step 3: Run BFG Cleanup**
```bash
# Remove sensitive files from history
java -jar bfg-1.14.0.jar --delete-files ".env" .
java -jar bfg-1.14.0.jar --delete-files "*.jks" .
java -jar bfg-1.14.0.jar --delete-files "*.keystore" .
java -jar bfg-1.14.0.jar --delete-files "*keystore*" .
java -jar bfg-1.14.0.jar --delete-files "keystore-base64.txt" .

# Clean up the repository
git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

### **Step 4: Push Clean History**
```bash
# Force push the cleaned repository
git push --force-with-lease
```

## 🛠️ Method 2: Using Git Filter-Branch (Alternative)

### **Step 1: Create Backup**
```bash
cd "C:\Users\chint\StudioProjects\letsstream-flutter-v2"
git branch backup-before-cleanup
```

### **Step 2: Run Filter-Branch**
```bash
# Remove .env files
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env" \
  --prune-empty --tag-name-filter cat -- --all

# Remove keystore files
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch *.jks *.keystore *keystore* keystore-base64.txt debug.keystore release-keystore.jks" \
  --prune-empty --tag-name-filter cat -- --all
```

### **Step 3: Clean References**
```bash
git for-each-ref --format="delete %(refname)" refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

## 🛠️ Method 3: Automated Scripts (Windows/Linux)

### **Windows:**
```cmd
# Run the automated cleanup script
cleanup-git-history.bat
```

### **Linux/Mac:**
```bash
# Make script executable and run
chmod +x cleanup-git-history.sh
./cleanup-git-history.sh
```

## 📝 Update .gitignore

Add these entries to your `.gitignore` file:

```gitignore
# Environment variables
.env
.env.*
.env.local
.env.production

# Keystores and certificates
*.keystore
*.jks
*.p12
*.pem
key.properties
keystore-base64.txt
debug.keystore
release-keystore.jks

# Sensitive build files
android/app/google-services.json
android/app/src/google-services.json
ios/Runner/GoogleService-Info.plist
```

## 🚀 Final Steps

### **1. Force Push to Remote**
```bash
# Push all branches
git push --force-with-lease origin --all

# Push all tags
git push --force-with-lease origin --tags
```

### **2. Verify Cleanup**
```bash
# Check if sensitive files are gone from history
git log --all --full-history -- .env *.jks *.keystore *keystore* keystore-base64.txt

# Should return no results if successful
```

### **3. Regenerate Secrets**
- 🔄 **Generate new keystore** using the provided scripts
- 🔄 **Rotate API keys** in your .env file
- 🔄 **Update GitHub secrets** with new keystore
- 🔄 **Create new .env file** (locally only, don't commit)

### **4. Notify Collaborators**
Send this message to all collaborators:

> **🚨 Repository History Rewritten**
> 
> The git history has been cleaned to remove sensitive files. Please:
> 1. Delete your local repository
> 2. Re-clone from GitHub: `git clone https://github.com/USERNAME/letsstream-flutter-v2.git`
> 3. Don't try to push from old clones - they have outdated history

## ✅ Verification Checklist

After cleanup, verify:

- [ ] **No sensitive files in history**: `git log --all --full-history -- .env *.jks *.keystore`
- [ ] **Updated .gitignore**: Contains all sensitive file patterns
- [ ] **Repository builds successfully**: Test the build process
- [ ] **GitHub secrets updated**: New keystore uploaded as Base64
- [ ] **New keystore generated**: Replace the old compromised keystore
- [ ] **API keys rotated**: Generate new API keys if they were in .env
- [ ] **Force push completed**: All branches and tags updated on remote

## 🔐 Security Best Practices

### **Going Forward:**
- ✅ **Never commit sensitive files** - always use .gitignore
- ✅ **Use environment variables** for configuration
- ✅ **Store secrets in GitHub Secrets** not in code
- ✅ **Regular security audits** of your repository
- ✅ **Use git hooks** to prevent accidental commits

### **For Android Keystores:**
- ✅ **Store as GitHub secrets** (Base64 encoded)
- ✅ **Never commit to repository** - add to .gitignore
- ✅ **Backup securely** in password manager
- ✅ **Use different keystores** for debug/release

## 🆘 Need Help?

If you encounter issues:

1. **Check the backup branch**: `git checkout backup-before-cleanup`
2. **Review the logs**: Look for error messages during cleanup
3. **Try BFG method**: If filter-branch fails, use BFG Repo-Cleaner
4. **Contact support**: GitHub support can help with repository issues

## 📞 Emergency Recovery

If something goes wrong:

```bash
# Restore from backup
git checkout backup-before-cleanup
git branch -D main
git checkout -b main
git push --force-with-lease origin main
```

---

**⚠️ Remember: This is a critical security issue. Complete the cleanup immediately and notify all collaborators about the history rewrite.**