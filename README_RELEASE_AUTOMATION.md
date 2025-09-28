# 🚀 Release Automation for Let's Stream

This repository now includes comprehensive GitHub Actions workflows for automated releases, version management, and APK distribution.

## 📋 Quick Start

### 🎯 Create a Release (3 Methods)

#### Method 1: Commit with "Release" (Recommended)
```bash
git add .
git commit -m "Release: Add native PIP support and UI improvements"
git push
```
**Result:** ✅ Automatic APK build, tag creation, and GitHub release

#### Method 2: Manual Version Bump + Release
1. Go to **Actions** → **Version Bump** → **Run workflow**
2. Select version type (patch/minor/major)
3. Use commit message: "Release: Version bump to X.X.X"
4. Release workflow triggers automatically

#### Method 3: Manual Release (No Version Change)
1. Go to **Actions** → **Release Build & Deploy** → **Run workflow**
2. Select version increment type
3. APKs built and released immediately

## 🔧 Setup Required (One-Time)

### 1. Generate Android Keystore (For Signed APKs)
```bash
# Linux/macOS
./scripts/generate-keystore.sh

# Windows
scripts\generate-keystore.bat
```

### 2. Add GitHub Secrets
Go to **Settings** → **Secrets and variables** → **Actions**:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `KEYSTORE_BASE64` | Base64 encoded keystore file | `MIIEvgIBADANBgkqh...` |
| `KEYSTORE_PASSWORD` | Keystore password | `mySecurePassword123` |
| `KEY_ALIAS` | Key alias name | `release` |
| `KEY_PASSWORD` | Key password | `myKeyPassword123` |

### 3. Enable Workflow Permissions
**Settings** → **Actions** → **General** → **Workflow permissions**:
- ✅ Select "Read and write permissions"
- ✅ Check "Allow GitHub Actions to create and approve pull requests"

## 📱 Generated APK Files

Each release creates multiple APK variants:

| APK File | Target Devices | Recommended For |
|----------|----------------|-----------------|
| `lets-stream-vX.X.X-arm64-v8a.apk` | Modern Android devices (64-bit) | **Most users** |
| `lets-stream-vX.X.X-armeabi-v7a.apk` | Older Android devices (32-bit) | Legacy devices |
| `lets-stream-vX.X.X-x86_64.apk` | x86 Android devices/emulators | Testing/emulators |

## 🏷️ Version Management

### Semantic Versioning
- **Major** (1.0.0 → 2.0.0): Breaking changes
- **Minor** (1.0.0 → 1.1.0): New features
- **Patch** (1.0.0 → 1.0.1): Bug fixes

### Automatic Tag Creation
- Tags: `v1.0.0`, `v1.1.0`, `v2.0.0`
- Build numbers increment automatically
- Full changelog generated

## 📝 Release Notes Features

Auto-generated release notes include:
- 📱 Version and build information
- 📋 Commit messages since last release
- 🔧 Technical details (Flutter/SDK versions)
- 📱 APK compatibility information
- 📥 Installation instructions
- 🔗 Full changelog links

## 🔄 Workflow Status

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| **🚀 Release Build & Deploy** | Commit with "Release" or Manual | Build APKs, create tags, publish release |
| **📈 Version Bump** | Manual only | Increment version, update changelog |

## 📊 Example Release Process

```bash
# 1. Make your changes
git add .
git commit -m "Add new video streaming features"

# 2. Test your changes
flutter test
flutter build apk --debug

# 3. Create release
git commit -m "Release: Version 1.2.0 with streaming improvements"
git push

# 4. GitHub Actions will:
#    ✅ Build signed APKs (ARM64, ARMv7, x86_64)
#    ✅ Create tag v1.2.0
#    ✅ Generate release notes
#    ✅ Upload APKs to GitHub Releases
#    ✅ Notify on completion
```

## 🛠️ Troubleshooting

### Common Issues

| Issue | Solution |
|-------|----------|
| **Build fails with signing error** | Check keystore secrets are correctly set |
| **Permission denied on tag creation** | Enable write permissions in workflow settings |
| **APK not uploaded** | Check if build completed successfully |
| **Workflow doesn't trigger** | Ensure commit message contains "Release" |

### Debug Information

- **Workflow logs**: Actions tab → Select workflow run
- **APK paths**: `build/app/outputs/flutter-apk/`
- **Build details**: Check workflow summary for file sizes and paths

## 📈 Monitoring

### Workflow Badges
Add to your main README.md:
```markdown
![Release](https://github.com/USERNAME/REPO/workflows/Release%20Build%20&%20Deploy/badge.svg)
![Version Bump](https://github.com/USERNAME/REPO/workflows/Version%20Bump/badge.svg)
```

### Release Statistics
- **Build time**: ~5-10 minutes
- **APK sizes**: 15-25MB per architecture
- **Supported Android**: API 21+ (Android 5.0+)
- **Target SDK**: API 34 (Android 14)

## 🔒 Security Features

- ✅ Keystore files base64 encoded and stored as secrets
- ✅ Sensitive files cleaned up after build
- ✅ Debug signing fallback when no keystore
- ✅ Secrets never exposed in logs
- ✅ Proper permission management

## 📚 Documentation

- **Detailed setup**: [.github/GITHUB_ACTIONS_SETUP.md](.github/GITHUB_ACTIONS_SETUP.md)
- **Changelog**: [CHANGELOG.md](CHANGELOG.md)
- **Workflow files**: [.github/workflows/](.github/workflows/)

---

## 🎉 You're All Set!

Your repository now has **enterprise-grade release automation**:

- 🚀 **One-click releases** with commit messages
- 📱 **Multi-architecture APKs** automatically built
- 🏷️ **Semantic versioning** and tagging
- 📝 **Professional release notes**
- 🔐 **Secure keystore management**
- 📊 **Build monitoring** and notifications

**Just commit with "Release" in the message and watch the magic happen!** ✨