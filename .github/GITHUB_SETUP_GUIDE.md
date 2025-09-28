# 🚀 GitHub Actions Setup Guide - Step by Step

Great! You've generated your keystore. Now let's set up the GitHub Actions workflow.

## 📋 Step-by-Step Setup

### Step 1: Prepare Your Keystore for GitHub 🔐

1. **Locate your keystore file** (probably named `release-keystore.jks`)
2. **Convert it to Base64** for GitHub secrets:

#### Windows (Command Prompt):
```cmd
certutil -encode release-keystore.jks keystore-base64.txt
```
Then open `keystore-base64.txt`, remove the header/footer lines, and copy the base64 content.

#### Windows (PowerShell):
```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("release-keystore.jks")) | Out-File -Encoding ASCII keystore-base64.txt
```

#### Alternative - Online Tool:
Upload your keystore to a base64 encoder like https://base64.guru/converter/encode/file

### Step 2: Add GitHub Repository Secrets 🔒

1. **Go to your GitHub repository**
2. **Click Settings** (top right of repo page)
3. **Click "Secrets and variables"** in left sidebar
4. **Click "Actions"**
5. **Click "New repository secret"** button

Add these 4 secrets one by one:

| Secret Name | Value | Description |
|-------------|-------|-------------|
| `KEYSTORE_BASE64` | [Your base64 string from Step 1] | The encoded keystore file |
| `KEYSTORE_PASSWORD` | [Your keystore password] | Password you used when creating keystore |
| `KEY_ALIAS` | [Your key alias] | Key alias (default: "release") |
| `KEY_PASSWORD` | [Your key password] | Key password you set |

**Example:**
- Secret name: `KEYSTORE_BASE64`
- Secret value: `MIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAo...` (very long string)

### Step 3: Enable Workflow Permissions ⚙️

1. **In your GitHub repo**, go to **Settings**
2. **Scroll down** to "Actions" in the left sidebar
3. **Click "General"**
4. **Under "Workflow permissions"**, select:
   - ✅ **"Read and write permissions"**
   - ✅ **"Allow GitHub Actions to create and approve pull requests"**
5. **Click "Save"**

### Step 4: Push Your Workflow Files 📤

Your workflow files are already created locally. Now push them to GitHub:

```bash
cd "C:\Users\chint\StudioProjects\letsstream-flutter-v2"
git add .github/
git add scripts/
git add CHANGELOG.md
git add README_RELEASE_AUTOMATION.md
git commit -m "Add GitHub Actions release workflows"
git push
```

### Step 5: Test Your Setup 🧪

Now test that everything works:

#### Method A: Commit with "Release" (Automatic)
```bash
git commit -m "Release: Test automated build system"
git push
```

#### Method B: Manual Trigger
1. **Go to your GitHub repo**
2. **Click "Actions" tab**
3. **Click "Release Build & Deploy"** in the left sidebar
4. **Click "Run workflow"** button (top right)
5. **Select branch** (usually main)
6. **Choose release type** (patch/minor/major)
7. **Click "Run workflow"**

### Step 6: Monitor the Build 👀

1. **Go to "Actions" tab** in your GitHub repo
2. **Click on the running workflow**
3. **Watch the progress** - it should take 5-10 minutes
4. **Check for any errors** in the logs

### Step 7: Verify Success ✅

If successful, you should see:
- ✅ **New tag created** (e.g., v1.0.1)
- ✅ **New release** in the "Releases" section
- ✅ **APK files uploaded** to the release
- ✅ **Release notes generated**

## 🛠️ Troubleshooting Common Issues

### Issue 1: "Keystore not found" Error
**Solution:** Check that `KEYSTORE_BASE64` secret is correctly set and contains the full base64 string.

### Issue 2: "Permission denied" Error
**Solution:** Make sure you enabled "Read and write permissions" in Step 3.

### Issue 3: Build Fails with Gradle Error
**Solution:** The workflow uses Flutter 3.24.3 and Java 17. If you need different versions, let me know.

### Issue 4: Workflow Doesn't Trigger
**Solution:** Make sure your commit message contains the word "Release" (case-sensitive).

## 📱 Expected Output

After successful setup, each release will generate:
- `lets-stream-v1.0.1-arm64-v8a.apk` (64-bit Android devices)
- `lets-stream-v1.0.1-armeabi-v7a.apk` (32-bit Android devices)  
- `lets-stream-v1.0.1-x86_64.apk` (x86 devices/emulators)

## 🎉 You're Done!

Once setup is complete, you can create releases by simply:
```bash
git commit -m "Release: Add new features"
git push
```

The system will automatically:
- ✅ Build signed APKs
- ✅ Create version tags
- ✅ Generate release notes
- ✅ Upload to GitHub Releases

## 📞 Need Help?

If you encounter any issues during setup:
1. Check the Actions tab for detailed error logs
2. Verify all 4 secrets are correctly set
3. Ensure workflow permissions are enabled
4. Make sure the keystore file is accessible and passwords are correct