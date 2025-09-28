// Simkl OAuth Provider
// Handles OAuth 2.0 authentication flow

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/models/simkl/simkl_auth_models.dart';
import '../../../core/services/simkl/simkl_api_client.dart';

/// OAuth Authentication State
enum SimklOAuthState { idle, authorizing, tokenExchanging, success, error }

/// OAuth Provider
class SimklOAuthProvider extends StateNotifier<SimklOAuthState> {
  final SimklApiClient _apiClient;
  final String _redirectUri;

  SimklOAuthProvider({
    required SimklApiClient apiClient,
    required String redirectUri,
  }) : _apiClient = apiClient,
       _redirectUri = redirectUri,
       super(SimklOAuthState.idle);

  /// Start OAuth authorization flow
  Future<void> startAuthorization({String? oauthState}) async {
    try {
      super.state = SimklOAuthState.authorizing;

      final authUrl = _apiClient.getAuthorizationUrl(
        redirectUri: _redirectUri,
        state: oauthState,
      );

      // Launch the authorization URL in browser
      if (await canLaunchUrl(authUrl)) {
        await launchUrl(authUrl, mode: LaunchMode.externalApplication);
      } else {
        throw Exception('Could not launch authorization URL');
      }

      super.state = SimklOAuthState.idle;
    } catch (e) {
      super.state = SimklOAuthState.error;
      debugPrint('OAuth authorization error: $e');
      rethrow;
    }
  }

  /// Exchange authorization code for access token
  Future<SimklAuthResponse> exchangeCodeForToken({
    required String code,
    required String currentAccessToken,
  }) async {
    try {
      super.state = SimklOAuthState.tokenExchanging;

      final response = await _apiClient.exchangeCodeForToken(
        code: code,
        redirectUri: _redirectUri,
        accessToken: currentAccessToken,
      );

      super.state = SimklOAuthState.success;
      return response;
    } catch (e) {
      super.state = SimklOAuthState.error;
      debugPrint('Token exchange error: $e');
      rethrow;
    }
  }

  /// Reset state
  void reset() {
    super.state = SimklOAuthState.idle;
  }

  /// Handle OAuth callback URL
  Future<bool> handleCallbackUrl(String url) async {
    try {
      super.state = SimklOAuthState.tokenExchanging;

      // Parse the callback URL to extract authorization code
      final uri = Uri.parse(url);
      final code = uri.queryParameters['code'];
      final error = uri.queryParameters['error'];
      final errorDescription = uri.queryParameters['error_description'];

      if (error != null) {
        super.state = SimklOAuthState.error;
        debugPrint(
          'OAuth callback error: $error, description: $errorDescription',
        );
        return false;
      }

      if (code == null || code.isEmpty) {
        super.state = SimklOAuthState.error;
        debugPrint('No authorization code found in callback URL');
        return false;
      }

      // Exchange code for token
      await _apiClient.exchangeCodeForToken(
        code: code,
        redirectUri: _redirectUri,
        accessToken: '', // Will be handled by the API client
      );

      super.state = SimklOAuthState.success;
      return true;
    } catch (e) {
      super.state = SimklOAuthState.error;
      debugPrint('Callback handling error: $e');
      rethrow;
    }
  }

  /// Check if URL is a valid OAuth callback
  bool isCallbackUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.scheme == 'letsstream' &&
          uri.host == 'oauth' &&
          uri.path == '/callback';
    } catch (e) {
      return false;
    }
  }
}

/// OAuth Provider Provider
final simklOAuthProvider =
    StateNotifierProvider.family<
      SimklOAuthProvider,
      SimklOAuthState,
      ({SimklApiClient apiClient, String redirectUri})
    >((ref, params) {
      return SimklOAuthProvider(
        apiClient: params.apiClient,
        redirectUri: params.redirectUri,
      );
    });
