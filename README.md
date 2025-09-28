# 🎬 Let's Stream

![Release](https://github.com/chintan992/letsstream-flutter-v2/workflows/🚀%20Release%20Build%20&%20Deploy/badge.svg)
![Version](https://img.shields.io/github/v/release/chintan992/letsstream-flutter-v2)
![License](https://img.shields.io/github/license/chintan992/letsstream-flutter-v2)

**Let's Stream** is a modern, feature-rich media discovery application built with Flutter. It allows users to explore, search, and stream movies, TV shows, and anime, featuring native Android Picture-in-Picture support and enterprise-grade automated release workflows.

## ✨ Key Features

### 🎥 **Streaming & Video**
- **Native Picture-in-Picture (PIP)**: True Android system PIP support with smart overlay controls
- **PIP UI Management**: Overlay controls automatically hidden in PIP mode, restored in fullscreen
- **Multi-Source Streaming**: Switch between 20+ video sources for reliable playback
- **In-App Video Player**: Secure, iframe-based video player with comprehensive controls
- **Seamless PIP Experience**: YouTube-like PIP with automatic UI adjustments

### 🎯 **Discovery & Navigation**
- **Media Discovery**: Browse extensive catalogs of movies, TV shows, and anime
- **Dynamic Home Screen**: Interactive carousels for trending, now playing, and airing content
- **Advanced Search**: Debounced, paginated search with filters and smart suggestions
- **Detailed Views**: Rich detail screens with trailers, cast, similar titles, and episode guides

### 🚀 **Performance & UX**
- **Modern UI/UX**: Material Design 3 with smooth animations and shimmer loading
- **Offline Support**: Intelligent caching with Hive for offline browsing
- **Accessibility**: Screen reader support, dynamic text scaling, and touch target optimization
- **Performance Optimized**: Image optimization with WebP/AVIF, lazy loading, and prefetching

### ⚙️ **Development & Deployment**
- **Automated Releases**: GitHub Actions workflows for signed APK builds
- **Multi-Architecture**: ARM64, ARMv7, and x86_64 APK variants
- **Professional CI/CD**: Automated versioning, tagging, and release notes generation

## 🎯 Current Status

The project has evolved significantly with advanced features and enterprise-grade automation:

- **✅ Phase 1 (Completed)**: Core features including API integration, navigation, all major screens (Home, Movies, TV, Anime, Search, Detail), and complete UI/UX foundation
- **✅ Phase 2 (Completed)**: Native Android PIP support, GitHub Actions automation, performance optimizations, accessibility features, and offline capabilities
- **🔄 Phase 3 (In Progress)**: Firebase integration for user authentication, watchlist synchronization, and advanced user preferences
- **🚀 Phase 4 (Future)**: Advanced search filters, recommendation engine, and cross-platform iOS support

## 🛠️ Technology Stack

### **Frontend & Framework**
- **Framework**: Flutter 3.24.3
- **Language**: Dart
- **State Management**: Riverpod (StateNotifier pattern)
- **Navigation**: GoRouter with deep linking
- **Design**: Material Design 3 with custom theming
- **Video Player**: InAppWebView with native PIP support

### **Backend & APIs**
- **Media Database**: The Movie Database (TMDB) API
- **Video Sources**: Custom multi-source streaming API
- **HTTP Client**: Dio with interceptors and retry logic
- **Authentication**: Firebase (planned integration)

### **Performance & Storage**
- **Local Storage**: Hive for offline caching
- **Image Optimization**: WebP/AVIF support with progressive loading
- **State Persistence**: Riverpod with auto-dispose
- **Connectivity**: Network-aware image loading and caching

### **Development & Deployment**
- **CI/CD**: GitHub Actions workflows
- **Code Generation**: build_runner for model generation
- **Testing**: Flutter test framework
- **Signing**: Android keystore with secure GitHub secrets
- **Distribution**: Multi-architecture APK builds (ARM64, ARMv7, x86_64)

## 📱 Download & Installation

### **Latest Release**
Download the latest version from the [Releases](../../releases) page:

- **ARM64** (`arm64-v8a.apk`): For most modern Android devices (recommended)
- **ARMv7** (`armeabi-v7a.apk`): For older Android devices
- **x86_64** (`x86_64.apk`): For Android emulators and x86 devices

### **System Requirements**
- **Android**: 5.0 (API 21) or higher
- **Target SDK**: Android 14 (API 34)
- **RAM**: 2GB+ recommended
- **Storage**: 50MB for app + cache space

### **Installation**
1. Download the appropriate APK for your device
2. Enable "Install from unknown sources" in Android settings
3. Install the APK file
4. Grant necessary permissions when prompted

## 🚀 Getting Started (Developers)

### **Prerequisites**
- Flutter 3.24.3 or higher
- Dart SDK 3.5.0 or higher
- Android Studio with Android SDK
- Git for version control

### **Setup**
```bash
# Clone the repository
git clone https://github.com/chintan992/letsstream-flutter-v2.git
cd letsstream-flutter-v2

# Install dependencies
flutter pub get

# Run code generation
dart run build_runner build --delete-conflicting-outputs

# Run the app
flutter run
```

### **Build Release APK**
```bash
# Build signed release APK (requires keystore setup)
flutter build apk --release --split-per-abi

# Build debug APK
flutter build apk --debug
```

## 🔧 Configuration

### **API Keys**
The app uses TMDB API for movie/TV data. You may need to configure API keys in the appropriate service files.

### **Video Sources**
Video streaming sources are configured through the custom API. The app supports 20+ different streaming providers for reliable playback.

## 🤝 Contributing

Contributions are welcome! Please read our contributing guidelines and submit pull requests for any improvements.

### **Development Workflow**
1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

### **Release Process**
The project uses automated GitHub Actions workflows:
```bash
# Trigger automated release
git commit -m "Release: Add new features and improvements"
git push
```

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🌟 Acknowledgments

- **TMDB** for providing comprehensive movie and TV show metadata
- **Flutter Team** for the amazing cross-platform framework
- **Riverpod** for elegant state management
- **Community** for feedback and contributions

---

<div align="center">
  <p>Built with ❤️ using Flutter</p>
  <p>
    <a href="../../releases">📱 Download</a> •
    <a href="../../issues">🐛 Report Bug</a> •
    <a href="../../issues">💡 Request Feature</a>
  </p>
</div>