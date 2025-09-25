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
