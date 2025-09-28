import 'dart:async';
import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/simkl/simkl_api_client.dart';
import '../../../core/models/simkl/simkl_auth_models.dart';
import '../providers/simkl_oauth_provider.dart';
import '../providers/simkl_pin_provider.dart';

// Simkl Authentication Service
// Coordinates OAuth and PIN authentication flows

/// SharedPreferences provider
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences provider not implemented');
});

/// Simkl Authentication Service
class SimklAuthService {
  final SimklApiClient _apiClient;
  final WidgetRef _ref;

  // Storage keys
  static const String _accessTokenKey = 'simkl_access_token';
  static const String _tokenTypeKey = 'simkl_token_type';
  static const String _scopeKey = 'simkl_scope';
  static const String _userSettingsKey = 'simkl_user_settings';

  SimklAuthService(this._apiClient, this._ref);

  /// Initialize authentication service
  Future<void> initialize() async {
    // Check if we have stored credentials
    final prefs = await _getSharedPreferences();
    final storedToken = prefs.getString(_accessTokenKey);

    if (storedToken != null && storedToken.isNotEmpty) {
      // Validate stored token
      try {
        await _validateStoredToken(storedToken);
      } catch (e) {
        // Token is invalid, clear stored credentials
        await _clearStoredCredentials();
      }
    }
  }

  /// OAuth Authentication Flow
  Future<void> signInWithOAuth({
    required String redirectUri,
    String? state,
  }) async {
    try {
      // Update OAuth provider state
      final oauthProvider = _ref.read(
        simklOAuthProvider((
          apiClient: _apiClient,
          redirectUri: redirectUri,
        )).notifier,
      );

      await oauthProvider.startAuthorization(oauthState: state);
    } catch (e) {
      final oauthProvider = _ref.read(
        simklOAuthProvider((
          apiClient: _apiClient,
          redirectUri: redirectUri,
        )).notifier,
      );

      // Set error state
      oauthProvider.reset(); // Reset to idle first
      // Note: OAuth provider doesn't have setError method, so we just reset
    }
  }

  /// Handle OAuth callback
  Future<bool> handleOAuthCallback({
    required String code,
    required String redirectUri,
  }) async {
    try {
      final oauthProvider = _ref.read(
        simklOAuthProvider((
          apiClient: _apiClient,
          redirectUri: redirectUri,
        )).notifier,
      );

      // Exchange code for token
      final response = await oauthProvider.exchangeCodeForToken(
        code: code,
        currentAccessToken: '', // Will be handled by the API client
      );

      // Store credentials
      await _storeCredentials(response);

      // Get user settings
      final userSettings = await _apiClient.getUserSettings(
        response.accessToken,
      );
      await _storeUserSettings(userSettings);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Handle OAuth callback from URL
  Future<bool> handleOAuthCallbackFromUrl(String url) async {
    try {
      // Parse the callback URL
      final uri = Uri.parse(url);

      // Validate it's our callback URL
      if (uri.scheme != 'letsstream' ||
          uri.host != 'oauth' ||
          uri.path != '/callback') {
        log('Invalid callback URL format: $url');
        return false;
      }

      // Extract parameters
      final code = uri.queryParameters['code'];
      final error = uri.queryParameters['error'];
      final errorDescription = uri.queryParameters['error_description'];

      if (error != null) {
        log('OAuth callback error: $error, description: $errorDescription');
        return false;
      }

      if (code == null || code.isEmpty) {
        log('No authorization code found in callback URL');
        return false;
      }

      // Use the existing callback handler
      return await handleOAuthCallback(
        code: code,
        redirectUri: 'letsstream://oauth/callback',
      );
    } catch (e) {
      log('Error handling OAuth callback from URL: $e');
      return false;
    }
  }

  /// Check if URL is a valid OAuth callback
  bool isValidCallbackUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'letsstream' &&
          uri.host == 'oauth' &&
          uri.path == '/callback';
    } catch (e) {
      return false;
    }
  }

  /// PIN Authentication Flow
  Future<void> signInWithPin({String? redirect}) async {
    try {
      final pinProvider = _ref.read(
        simklPinProvider((apiClient: _apiClient, redirect: redirect)).notifier,
      );

      await pinProvider.requestPinCode();
    } catch (e) {
      final pinProvider = _ref.read(
        simklPinProvider((apiClient: _apiClient, redirect: redirect)).notifier,
      );

      // Set error state
      pinProvider.reset(); // Reset to idle first
    }
  }

  /// Check PIN status
  Future<bool> checkPinStatus() async {
    try {
      final pinProvider = _ref.read(
        simklPinProvider((apiClient: _apiClient, redirect: null)).notifier,
      );

      final pinState = _ref.read(
        simklPinProvider((apiClient: _apiClient, redirect: null)),
      );

      if (pinState == SimklPinState.idle) {
        throw Exception('No PIN code requested yet');
      }

      // Check status manually since provider doesn't expose userCode directly
      final pinInfo = pinProvider.pinInfo;
      final userCode = pinInfo['userCode'] ?? '';
      final response = await _apiClient.checkPinStatus(userCode);

      if (response.isAuthorized && response.accessToken != null) {
        // Store credentials
        final authResponse = SimklAuthResponse(
          accessToken: response.accessToken!,
          tokenType: response.tokenType ?? 'Bearer',
          scope: response.scope ?? 'public',
        );
        await _storeCredentials(authResponse);

        // Get user settings
        final userSettings = await _apiClient.getUserSettings(
          response.accessToken!,
        );
        await _storeUserSettings(userSettings);

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      // Clear stored credentials
      await _clearStoredCredentials();

      // Update provider states
      final oauthProvider = _ref.read(
        simklOAuthProvider((apiClient: _apiClient, redirectUri: '')).notifier,
      );
      final pinProvider = _ref.read(
        simklPinProvider((apiClient: _apiClient, redirect: null)).notifier,
      );

      oauthProvider.reset();
      pinProvider.reset();
    } catch (e) {
      // Even if clearing fails, update provider states
      final oauthProvider = _ref.read(
        simklOAuthProvider((apiClient: _apiClient, redirectUri: '')).notifier,
      );
      final pinProvider = _ref.read(
        simklPinProvider((apiClient: _apiClient, redirect: null)).notifier,
      );

      oauthProvider.reset();
      pinProvider.reset();
    }
  }

  /// Get stored access token
  Future<String?> getAccessToken() async {
    final prefs = await _getSharedPreferences();
    return prefs.getString(_accessTokenKey);
  }

  /// Get stored user settings
  Future<SimklUserSettings?> getUserSettings() async {
    final prefs = await _getSharedPreferences();
    final settingsJson = prefs.getString(_userSettingsKey);

    if (settingsJson != null && settingsJson.isNotEmpty) {
      try {
        final settingsMap = Map<String, dynamic>.from(settingsJson as Map);
        return SimklUserSettings.fromJson(settingsMap);
      } catch (e) {
        // Invalid stored settings, return null
        return null;
      }
    }

    return null;
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await getAccessToken();
    return token != null && token.isNotEmpty;
  }

  /// Validate stored token
  Future<void> _validateStoredToken(String token) async {
    try {
      // Try to get user settings to validate token
      await _apiClient.getUserSettings(token);
    } catch (e) {
      throw Exception('Invalid stored token');
    }
  }

  /// Store credentials
  Future<void> _storeCredentials(SimklAuthResponse response) async {
    final prefs = await _getSharedPreferences();

    await prefs.setString(_accessTokenKey, response.accessToken);
    await prefs.setString(_tokenTypeKey, response.tokenType);
    await prefs.setString(_scopeKey, response.scope);
  }

  /// Store user settings
  Future<void> _storeUserSettings(SimklUserSettings settings) async {
    final prefs = await _getSharedPreferences();
    await prefs.setString(_userSettingsKey, settings.toJson().toString());
  }

  /// Clear stored credentials
  Future<void> _clearStoredCredentials() async {
    final prefs = await _getSharedPreferences();

    await prefs.remove(_accessTokenKey);
    await prefs.remove(_tokenTypeKey);
    await prefs.remove(_scopeKey);
    await prefs.remove(_userSettingsKey);
  }

  /// Get SharedPreferences instance
  Future<SharedPreferences> _getSharedPreferences() async {
    // In a real implementation, you would get this from a provider
    // For now, we'll get it directly
    return SharedPreferences.getInstance();
  }

  /// Clean up resources
  void dispose() {
    // Clean up any resources if needed
  }

  /// Simplified OAuth authentication method for UI
  Future<void> authenticateWithOAuth() async {
    try {
      // Use default redirect URI for mobile apps
      const redirectUri = 'letsstream://oauth/callback';

      await signInWithOAuth(redirectUri: redirectUri);
    } catch (e) {
      throw Exception('Failed to start OAuth authentication: $e');
    }
  }

  /// Simplified PIN authentication method for UI
  Future<void> authenticateWithPin() async {
    try {
      await signInWithPin();
    } catch (e) {
      throw Exception('Failed to start PIN authentication: $e');
    }
  }

  /// Enhanced error handling for OAuth callbacks
  Future<String?> getOAuthErrorMessage(String url) async {
    try {
      final uri = Uri.parse(url);

      if (uri.scheme != 'letsstream' ||
          uri.host != 'oauth' ||
          uri.path != '/callback') {
        return 'Invalid callback URL format';
      }

      final error = uri.queryParameters['error'];
      final errorDescription = uri.queryParameters['error_description'];

      if (error != null) {
        // Provide user-friendly error messages
        switch (error) {
          case 'access_denied':
            return 'Access was denied by the user';
          case 'invalid_request':
            return 'Invalid authentication request';
          case 'unauthorized_client':
            return 'Unauthorized client application';
          case 'unsupported_response_type':
            return 'Unsupported response type';
          case 'invalid_scope':
            return 'Invalid permission scope requested';
          case 'server_error':
            return 'Server error occurred during authentication';
          case 'temporarily_unavailable':
            return 'Authentication service temporarily unavailable';
          default:
            return errorDescription ?? 'Authentication failed: $error';
        }
      }

      return null; // No error
    } catch (e) {
      return 'Error parsing callback URL';
    }
  }
}
