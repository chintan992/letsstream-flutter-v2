# 🚀 GitHub Actions Release Setup

This repository includes automated release workflows that build and deploy APKs to GitHub Releases.

## 📋 Workflows Overview

### 1. 🚀 Release Build & Deploy (`release.yml`)
**Triggers:**
- ✅ Any commit with "Release" in the commit message
- ✅ Manual dispatch with version increment options

**What it does:**
- 🔍 Checks commit message for "Release" trigger
- 🔨 Builds signed release APKs (ARM64, ARMv7, x86_64)
- 🏷️ Creates and pushes git tags automatically
- 📦 Uploads APKs to GitHub Releases
- 📝 Generates comprehensive release notes

### 2. 📈 Version Bump (`version-bump.yml`)
**Triggers:**
- ✅ Manual dispatch only

**What it does:**
- 📊 Increments version in `pubspec.yaml` (patch/minor/major)
- 📝 Updates `CHANGELOG.md` with new version
- 💾 Commits and pushes changes
- 🔄 Can trigger release workflow if commit contains "Release"

## 🔧 Setup Instructions

### Step 1: Configure Repository Secrets

Go to your repository **Settings** → **Secrets and variables** → **Actions** and add:

#### Required for Signed Releases (Recommended):
```
KEYSTORE_BASE64     = [Base64 encoded keystore file]
KEYSTORE_PASSWORD   = [Your keystore password]
KEY_ALIAS          = [Your key alias]
KEY_PASSWORD       = [Your key password]
```

#### How to Generate Keystore:
```bash
# Create a new keystore (if you don't have one)
keytool -genkey -v -keystore release-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias release

# Convert keystore to base64 for GitHub secrets
base64 -i release-keystore.jks | pbcopy  # macOS
base64 -w 0 release-keystore.jks         # Linux
certutil -encode release-keystore.jks release-keystore.txt && type release-keystore.txt  # Windows
```

### Step 2: Repository Permissions

Ensure the `GITHUB_TOKEN` has necessary permissions:
- Go to **Settings** → **Actions** → **General**
- Under "Workflow permissions", select **Read and write permissions**
- Check **Allow GitHub Actions to create and approve pull requests**

## 🎯 How to Use

### Method 1: Commit with "Release" (Automatic)
```bash
git commit -m "Release: Add new video player features"
git push
```
This will automatically:
- ✅ Build release APKs
- ✅ Create tag (based on current version in pubspec.yaml)
- ✅ Create GitHub release

### Method 2: Manual Version Bump + Release
1. **Go to Actions tab** → **Version Bump** → **Run workflow**
2. **Select version type** (patch/minor/major)
3. **Add custom commit message** (must include "Release")
4. **Click "Run workflow"**

This will:
- ✅ Increment version in pubspec.yaml
- ✅ Update CHANGELOG.md
- ✅ Commit changes with "Release" message
- ✅ Trigger release workflow automatically

### Method 3: Manual Release (No Version Change)
1. **Go to Actions tab** → **Release Build & Deploy** → **Run workflow**
2. **Select version type** (patch/minor/major)
3. **Click "Run workflow"**

## 📱 Generated APK Files

The workflow creates multiple APK variants:
- `lets-stream-v1.0.0-arm64-v8a.apk` (Most Android devices)
- `lets-stream-v1.0.0-armeabi-v7a.apk` (Older Android devices)
- `lets-stream-v1.0.0-x86_64.apk` (Emulators/x86 devices)

## 📝 Release Notes Format

Auto-generated release notes include:
- 📱 Version and build information
- 📋 Commit messages since last release
- 🔧 Technical details (Flutter version, SDK versions)
- 📥 Installation instructions
- 🔗 Full changelog link

## 🛠️ Troubleshooting

### Issue: Build Fails with Signing Error
**Solution:** 
- Verify all keystore secrets are correctly set
- Check keystore base64 encoding is correct
- Ensure keystore passwords match

### Issue: Permission Denied on Tag Creation
**Solution:**
- Check repository workflow permissions
- Ensure `GITHUB_TOKEN` has write access

### Issue: APK Not Uploaded to Release
**Solution:**
- Check if APK files were built successfully
- Verify file paths in workflow match actual build output
- Ensure release creation step completed

## 📊 Workflow Status

| Workflow | Status | Last Run |
|----------|--------|----------|
| Release Build & Deploy | ![Release](https://github.com/USERNAME/REPO/workflows/Release%20Build%20&%20Deploy/badge.svg) | - |
| Version Bump | ![Version Bump](https://github.com/USERNAME/REPO/workflows/Version%20Bump/badge.svg) | - |

## 🔒 Security Best Practices

- ✅ Keystore files are base64 encoded and stored as secrets
- ✅ Sensitive files are cleaned up after build
- ✅ Debug signing used when no keystore available
- ✅ Secrets are never logged or exposed in workflow output

---

**Need help?** Check the [Actions tab](../../actions) for detailed logs and troubleshooting information.