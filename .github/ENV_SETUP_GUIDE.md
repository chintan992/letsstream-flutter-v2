# 🔐 Environment Variables Setup Guide

This guide will help you set up the required environment variables for GitHub Actions to build your app successfully.

## ❌ The Error You're Seeing

```
Error detected in pubspec.yaml:
No file or variants found for asset: .env.
```

This happens because the GitHub Actions build environment doesn't have access to your local `.env` file containing API credentials.

## ✅ Solution: GitHub Secrets

Instead of including the `.env` file in your repository (which would expose your API keys), we use GitHub Secrets to securely store these values.

## 📋 Step-by-Step Setup

### Step 1: Get Your TMDB API Credentials

1. **Visit TMDB**: Go to [https://www.themoviedb.org/](https://www.themoviedb.org/)
2. **Create Account**: Sign up or log in
3. **Get API Key**: 
   - Go to Settings → API
   - Click "Create" or "Request an API Key"
   - Choose "Developer" option
   - Fill out the application form
4. **Copy Credentials**: You'll get an API Key and Read Access Token

### Step 2: Add Secrets to GitHub Repository

1. **Open Repository**: Go to your GitHub repository
2. **Navigate to Settings**: Click "Settings" tab (at the top)
3. **Go to Secrets**: Click "Secrets and variables" → "Actions" (in the left sidebar)
4. **Add New Secret**: Click "New repository secret" for each of these:

#### Required Secrets:
```
Name: TMDB_API_KEY
Value: [Your TMDB API Key from step 1]

Name: TMDB_ACCESS_TOKEN  
Value: [Your TMDB Read Access Token from step 1]

Name: TMDB_BASE_URL
Value: https://api.themoviedb.org/3

Name: TMDB_IMAGE_BASE_URL
Value: https://image.tmdb.org/t/p
```

### Step 3: Verify Setup

1. **Check Secrets**: Go back to Settings → Secrets and variables → Actions
2. **Confirm All 4 Secrets**: You should see:
   - ✅ TMDB_API_KEY
   - ✅ TMDB_ACCESS_TOKEN  
   - ✅ TMDB_BASE_URL
   - ✅ TMDB_IMAGE_BASE_URL

### Step 4: Test the Build

1. **Make a Commit**: Add "Release" to your commit message
2. **Push Changes**: `git push`
3. **Check Actions**: Go to Actions tab to see the build progress
4. **Success**: Your build should now complete without the `.env` error!

## 🔒 Security Benefits

- ✅ **API keys are encrypted** in GitHub Secrets
- ✅ **Not visible in repository code** or commit history  
- ✅ **Only accessible during builds** by GitHub Actions
- ✅ **Can be updated anytime** without changing code

## 🛠️ How It Works

The GitHub Actions workflow now:
1. **Creates `.env` file** during build using your secrets
2. **Builds your app** with proper environment variables
3. **Cleans up `.env` file** after build for security

## 💡 Local Development

Your local `.env` file continues to work as before:
- Keep your `.env` file for local development
- Never commit it to git (it's in `.gitignore`)
- GitHub Actions creates its own during builds

## 🆘 Still Having Issues?

### Common Problems:

**Secret name typos**: Make sure secret names match exactly:
- `TMDB_API_KEY` (not `TMDB-API-KEY` or `tmdb_api_key`)

**Invalid TMDB credentials**: Test your API key at:
```bash
curl "https://api.themoviedb.org/3/movie/popular?api_key=YOUR_API_KEY"
```

**Missing secrets**: All 4 secrets must be added, even the URL ones.

### Need Help?
1. Check the [GitHub Actions Setup Guide](GITHUB_ACTIONS_SETUP.md)
2. Look at the Actions logs for detailed error messages
3. Verify your TMDB account has API access enabled

---

## 🎉 That's It!

Once you've added these 4 secrets, your GitHub Actions builds will work perfectly! 

The error `No file or variants found for asset: .env` will disappear, and you'll get successful APK builds. 🚀