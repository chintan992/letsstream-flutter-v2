// Simkl PIN Provider
// Handles PIN authentication flow for limited devices

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/simkl/simkl_auth_models.dart';
import '../../../core/services/simkl/simkl_api_client.dart';

/// PIN Authentication State
enum SimklPinState {
  idle,
  requestingCode,
  waitingForUser,
  polling,
  success,
  error,
  expired,
}

/// PIN Provider
class SimklPinProvider extends StateNotifier<SimklPinState> {
  final SimklApiClient _apiClient;
  final String? _redirect;

  Timer? _pollingTimer;
  String? _deviceCode;
  String? _userCode;
  String? _verificationUrl;
  int _expiresIn = 0;
  int _interval = 5;

  SimklPinProvider({required SimklApiClient apiClient, String? redirect})
    : _apiClient = apiClient,
      _redirect = redirect,
      super(SimklPinState.idle);

  /// Request PIN code from Simkl
  Future<SimklPinResponse> requestPinCode() async {
    try {
      super.state = SimklPinState.requestingCode;

      final response = await _apiClient.requestPinCode(redirect: _redirect);

      _deviceCode = response.deviceCode;
      _userCode = response.userCode;
      _verificationUrl = response.verificationUrl;
      _expiresIn = response.expiresIn;
      _interval = response.interval;

      super.state = SimklPinState.waitingForUser;
      return response;
    } catch (e) {
      super.state = SimklPinState.error;
      debugPrint('PIN request error: $e');
      rethrow;
    }
  }

  /// Start polling for authorization status
  void startPolling() {
    if (_deviceCode == null || _userCode == null) {
      throw Exception('PIN code not requested yet');
    }

    super.state = SimklPinState.polling;
    _pollingTimer = Timer.periodic(Duration(seconds: _interval), (timer) async {
      await _checkStatus();
    });
  }

  /// Stop polling
  void stopPolling() {
    _pollingTimer?.cancel();
    _pollingTimer = null;
  }

  /// Check authorization status
  Future<void> _checkStatus() async {
    if (_userCode == null) return;

    try {
      final response = await _apiClient.checkPinStatus(_userCode!);

      if (response.result == 'OK' && response.accessToken != null) {
        // Success!
        stopPolling();
        super.state = SimklPinState.success;
      } else if (response.result == 'KO' &&
          response.message == 'Authorization pending') {
        // Still waiting
        super.state = SimklPinState.polling;
      } else if (response.result == 'KO' && response.message == 'Slow down') {
        // Rate limited, increase interval
        _interval = (_interval * 1.5).round();
        super.state = SimklPinState.polling;
      } else {
        // Error or expired
        stopPolling();
        super.state = response.result == 'KO'
            ? SimklPinState.error
            : SimklPinState.expired;
      }
    } catch (e) {
      debugPrint('PIN status check error: $e');
      stopPolling();
      super.state = SimklPinState.error;
    }
  }

  /// Get current PIN information
  Map<String, String?> get pinInfo => {
    'deviceCode': _deviceCode,
    'userCode': _userCode,
    'verificationUrl': _verificationUrl,
  };

  /// Get polling interval
  int get pollingInterval => _interval;

  /// Check if PIN is expired
  bool get isExpired {
    if (_expiresIn == 0) return false;
    final expiryTime = DateTime.now().add(Duration(seconds: _expiresIn));
    return DateTime.now().isAfter(expiryTime);
  }

  /// Reset provider state
  void reset() {
    stopPolling();
    _deviceCode = null;
    _userCode = null;
    _verificationUrl = null;
    _expiresIn = 0;
    _interval = 5;
    super.state = SimklPinState.idle;
  }

  @override
  void dispose() {
    stopPolling();
    super.dispose();
  }
}

/// PIN Provider Provider
final simklPinProvider =
    StateNotifierProvider.family<
      SimklPinProvider,
      SimklPinState,
      ({SimklApiClient apiClient, String? redirect})
    >((ref, params) {
      return SimklPinProvider(
        apiClient: params.apiClient,
        redirect: params.redirect,
      );
    });
