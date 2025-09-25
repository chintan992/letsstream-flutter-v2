// Simkl Configuration
// Secure credential management for Simkl API

/// Simkl API Configuration
class SimklConfig {
  /// Your Simkl Client ID
  static const String clientId =
      '1d43388bc8a5aa24aa76a37983a65c552627b2c68fbc6e0ae120ddd6efd21625';

  /// Your Simkl Client Secret
  static const String clientSecret =
      'e552870656e3df592b642a2a3700917b24f94c466e51b26124226d826bd81e95';

  /// Base URL for Simkl API
  static const String baseUrl = 'https://api.simkl.com';

  /// OAuth Authorization URL
  static const String authUrl = 'https://simkl.com/oauth/authorize';

  /// PIN Authorization URL
  static const String pinUrl = 'https://simkl.com/pin';

  /// Default redirect URI for OAuth
  static const String defaultRedirectUri = 'letsstream://oauth/callback';

  /// Alternative redirect URIs (add your domain here)
  static const List<String> redirectUris = [
    'letsstream://oauth/callback',
    'com.chintan992.letsstream://oauth/callback',
    'http://localhost:3000/oauth/callback', // For development
    'https://yourdomain.com/oauth/callback', // Replace with your actual domain
  ];

  /// Request timeout in seconds
  static const int requestTimeout = 30;

  /// Maximum retry attempts
  static const int maxRetries = 3;

  /// Rate limiting delay in milliseconds
  static const int rateLimitDelay = 1000;

  /// Validate configuration
  static bool get isValid =>
      clientId.isNotEmpty && clientSecret.isNotEmpty && baseUrl.isNotEmpty;

  /// Get configuration info (without sensitive data)
  static Map<String, dynamic> get configInfo => {
    'baseUrl': baseUrl,
    'authUrl': authUrl,
    'pinUrl': pinUrl,
    'defaultRedirectUri': defaultRedirectUri,
    'redirectUrisCount': redirectUris.length,
    'isValid': isValid,
  };
}
