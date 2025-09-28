# 🚨 IMMEDIATE Git History Cleanup Steps

## ⚠️ CRITICAL: Run These Commands Now

You have sensitive files (`.env` and keystores) in your git history that need immediate removal. Follow these exact steps:

### 🛡️ Step 1: Set Environment Variable (Windows)
```cmd
set FILTER_BRANCH_SQUELCH_WARNING=1
cd "C:\Users\chint\StudioProjects\letsstream-flutter-v2"
```

### 🗑️ Step 2: Remove .env Files from History
```cmd
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch .env" --prune-empty --tag-name-filter cat -- --all
```

### 🔑 Step 3: Remove Keystore Files from History
```cmd
git filter-branch --force --index-filter "git rm --cached --ignore-unmatch *.jks *.keystore *keystore* keystore-base64.txt debug.keystore release-keystore.jks" --prune-empty --tag-name-filter cat -- --all
```

### 🧹 Step 4: Clean References
```cmd
git for-each-ref --format="delete %%(refname)" refs/original | git update-ref --stdin
git reflog expire --expire=now --all
git gc --prune=now --aggressive
```

### 📝 Step 5: Update .gitignore
```cmd
echo. >> .gitignore
echo # Sensitive files >> .gitignore
echo .env >> .gitignore
echo .env.* >> .gitignore
echo *.keystore >> .gitignore
echo *.jks >> .gitignore
echo keystore-base64.txt >> .gitignore
echo debug.keystore >> .gitignore
echo release-keystore.jks >> .gitignore
```

### ✅ Step 6: Verify Cleanup
```cmd
git log --all --full-history -- .env *.jks *.keystore *keystore* keystore-base64.txt
```
**This should return NO results if successful**

### 🚀 Step 7: Force Push to GitHub
```cmd
git add .gitignore
git commit -m "Update .gitignore to prevent sensitive files"
git push --force-with-lease origin --all
git push --force-with-lease origin --tags
```

## 🔄 Alternative: Use the Automated Script

If the manual commands are too complex, run:
```cmd
cleanup-git-history.bat
```

## ⚡ Quick One-Liner (Advanced Users Only)
```cmd
set FILTER_BRANCH_SQUELCH_WARNING=1 && git filter-branch --force --index-filter "git rm --cached --ignore-unmatch .env *.jks *.keystore *keystore* keystore-base64.txt debug.keystore release-keystore.jks" --prune-empty --tag-name-filter cat -- --all && git for-each-ref --format="delete %%(refname)" refs/original | git update-ref --stdin && git reflog expire --expire=now --all && git gc --prune=now --aggressive
```

## 🔒 After Cleanup - Security Steps

### 1. Regenerate Compromised Secrets
- 🔄 **Create new keystore**: Run `scripts\generate-keystore.bat`
- 🔄 **Rotate API keys**: Generate new API keys for your .env file
- 🔄 **Update GitHub secrets**: Upload new keystore as Base64

### 2. Update GitHub Repository Secrets
1. Go to your GitHub repo → Settings → Secrets and variables → Actions
2. Update `KEYSTORE_BASE64` with the new keystore
3. Update `KEYSTORE_PASSWORD` and `KEY_PASSWORD` if changed

### 3. Notify Team Members
Send this message:
> **🚨 Repository History Rewritten**
> 
> I've cleaned sensitive files from git history. Please:
> 1. Delete your local repository
> 2. Re-clone: `git clone https://github.com/YOUR_USERNAME/letsstream-flutter-v2.git`
> 3. Don't push from old clones - they have outdated history

## ❌ What NOT to Do

- ❌ **Don't skip the force push** - the cleanup only affects local history
- ❌ **Don't try to merge old branches** - they contain the sensitive files
- ❌ **Don't ignore this issue** - your secrets are currently public in git history
- ❌ **Don't push from old clones** after the cleanup

## ✅ Verification Checklist

After running all steps:
- [ ] No sensitive files found: `git log --all --full-history -- .env *.jks`
- [ ] .gitignore updated with sensitive file patterns
- [ ] Force pushed to GitHub successfully
- [ ] New keystore generated and GitHub secrets updated
- [ ] Repository builds successfully with new keystore

## 🆘 If Something Goes Wrong

If you encounter issues:
```cmd
# Restore from backup
git checkout backup-before-cleanup
git branch -D main
git checkout -b main backup-before-cleanup
```

---

**⚠️ This is urgent! Your API keys and signing keystore are currently visible in your GitHub repository history. Complete these steps immediately.**