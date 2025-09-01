import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

enum ConnectivityStatus { online, offline, unknown }

class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final Logger _logger = Logger();
  final StreamController<ConnectivityStatus> _statusController =
      StreamController<ConnectivityStatus>.broadcast();

  Stream<ConnectivityStatus> get statusStream => _statusController.stream;
  ConnectivityStatus _currentStatus = ConnectivityStatus.unknown;

  ConnectivityStatus get currentStatus => _currentStatus;

  static ConnectivityService? _instance;
  static ConnectivityService get instance =>
      _instance ??= ConnectivityService._();

  ConnectivityService._() {
    _initialize();
  }

  void _initialize() {
    // Listen to connectivity changes
    _connectivity.onConnectivityChanged.listen(_onConnectivityChanged);

    // Check initial connectivity
    checkConnectivity();
  }

  void _onConnectivityChanged(List<ConnectivityResult> results) {
    // Use the first result or determine the best connectivity
    final result = results.isNotEmpty ? results.first : ConnectivityResult.none;
    final newStatus = _mapConnectivityResult(result);

    if (newStatus != _currentStatus) {
      _currentStatus = newStatus;
      _statusController.add(_currentStatus);
      _logger.i('Connectivity changed to: $_currentStatus');
    }
  }

  ConnectivityStatus _mapConnectivityResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
      case ConnectivityResult.vpn:
        return ConnectivityStatus.online;
      case ConnectivityResult.none:
        return ConnectivityStatus.offline;
      default:
        return ConnectivityStatus.unknown;
    }
  }

  Future<ConnectivityStatus> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      final result = results.isNotEmpty
          ? results.first
          : ConnectivityResult.none;
      final status = _mapConnectivityResult(result);

      if (status != _currentStatus) {
        _currentStatus = status;
        _statusController.add(_currentStatus);
      }

      return _currentStatus;
    } catch (e) {
      _logger.e('Error checking connectivity: $e');
      return ConnectivityStatus.unknown;
    }
  }

  Future<bool> hasInternetAccess() async {
    if (_currentStatus == ConnectivityStatus.offline) {
      return false;
    }

    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  void dispose() {
    _statusController.close();
  }
}

// Riverpod provider
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService.instance;
});

final connectivityStatusProvider = StreamProvider<ConnectivityStatus>((ref) {
  final service = ref.watch(connectivityServiceProvider);
  return service.statusStream;
});

final isOnlineProvider = Provider<bool>((ref) {
  final status = ref.watch(connectivityStatusProvider).value;
  return status == ConnectivityStatus.online;
});
