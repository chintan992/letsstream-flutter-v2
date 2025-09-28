@echo off
echo 🔐 Generating Android Release Keystore
echo =====================================

set JAVA_HOME=C:\Users\chint\.jdks\valhalla-ea-23-valhalla+1-90
set PATH=%JAVA_HOME%\bin;%PATH%

echo Using Java from: %JAVA_HOME%

:: Check if Java is available
java -version >nul 2>&1
if %errorlevel% neq 0 (
    echo ❌ Java not found! Please ensure Java is installed and JAVA_HOME is set correctly.
    echo Current JAVA_HOME: %JAVA_HOME%
    pause
    exit /b 1
)

echo ✅ Java found!
echo.

echo 📝 Please provide the following information for your keystore:
echo.

set /p KEYSTORE_PASSWORD="🔑 Keystore Password (minimum 6 characters): "
set /p KEY_ALIAS="🏷️  Key Alias (e.g., letsstream): "
set /p KEY_PASSWORD="🔐 Key Password (minimum 6 characters): "
set /p FIRST_LAST_NAME="👤 First and Last Name: "
set /p ORGANIZATIONAL_UNIT="🏢 Organizational Unit (e.g., Development Team): "
set /p ORGANIZATION="🏛️  Organization (e.g., Your Company): "
set /p CITY="🏙️  City or Locality: "
set /p STATE="🗺️  State or Province: "
set /p COUNTRY_CODE="🌍 Country Code (2 letters, e.g., US, IN, GB): "

echo.
echo 🔨 Generating keystore with the following details:
echo ================================================
echo Keystore file: release-keystore.jks
echo Key alias: %KEY_ALIAS%
echo First/Last Name: %FIRST_LAST_NAME%
echo Organization Unit: %ORGANIZATIONAL_UNIT%
echo Organization: %ORGANIZATION%
echo City: %CITY%
echo State: %STATE%
echo Country: %COUNTRY_CODE%
echo.

keytool -genkey -v -keystore release-keystore.jks -alias %KEY_ALIAS% -keyalg RSA -keysize 2048 -validity 10000 -storepass "%KEYSTORE_PASSWORD%" -keypass "%KEY_PASSWORD%" -dname "CN=%FIRST_LAST_NAME%, OU=%ORGANIZATIONAL_UNIT%, O=%ORGANIZATION%, L=%CITY%, S=%STATE%, C=%COUNTRY_CODE%"

if %errorlevel% equ 0 (
    echo.
    echo ✅ Keystore generated successfully!
    echo 📁 Location: %CD%\release-keystore.jks
    echo.
    echo 📝 Creating key.properties file...
    
    echo storePassword=%KEYSTORE_PASSWORD% > android\key.properties
    echo keyPassword=%KEY_PASSWORD% >> android\key.properties
    echo keyAlias=%KEY_ALIAS% >> android\key.properties
    echo storeFile=..\release-keystore.jks >> android\key.properties
    
    echo ✅ key.properties created in android\ folder
    echo.
    echo 🔐 Converting keystore to base64 for GitHub Actions...
    
    :: Convert keystore to base64
    powershell -Command "[Convert]::ToBase64String([IO.File]::ReadAllBytes('release-keystore.jks'))" > keystore-base64.txt
    
    echo ✅ Base64 keystore saved to keystore-base64.txt
    echo.
    echo 📋 Next Steps:
    echo =============
    echo 1. Add the following secrets to your GitHub repository:
    echo    - KEYSTORE_BASE64: Copy content from keystore-base64.txt
    echo    - KEYSTORE_PASSWORD: %KEYSTORE_PASSWORD%
    echo    - KEY_PASSWORD: %KEY_PASSWORD%
    echo    - KEY_ALIAS: %KEY_ALIAS%
    echo.
    echo 2. Keep your keystore file (release-keystore.jks) safe and never commit it to git!
    echo 3. The key.properties file is also sensitive - it's already in .gitignore
    echo.
    echo 🚀 You can now build release APKs and use GitHub Actions for automated releases!
    
) else (
    echo.
    echo ❌ Failed to generate keystore!
    echo Please check the error messages above and try again.
)

echo.
pause