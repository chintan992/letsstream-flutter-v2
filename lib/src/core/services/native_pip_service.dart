import 'dart:async';
import 'dart:io';
//import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';

/// Native Android PIP service using system capabilities
class NativePipService {
  static final NativePipService _instance = NativePipService._internal();
  factory NativePipService() => _instance;
  NativePipService._internal();

  final Logger _logger = Logger();
  static const platform = MethodChannel('com.letsstream.pip/pip_channel');

  bool _isInPipMode = false;
  bool _isPipSupported = false;
  
  // Stream controller for PIP mode changes
  final StreamController<bool> _pipModeController = StreamController<bool>.broadcast();
  
  /// Stream to listen for PIP mode changes
  Stream<bool> get pipModeStream => _pipModeController.stream;

  /// Whether the app is currently in PIP mode
  bool get isInPipMode => _isInPipMode;

  /// Whether PIP is supported on this device
  bool get isPipSupported => _isPipSupported;

  /// Initialize the native PIP service
  Future<void> initialize() async {
    try {
      if (Platform.isAndroid) {
        // Check Android version (PIP requires API 26+)
        _isPipSupported = true; // Assume supported for now
        _logger.i('Native PIP service initialized');
        
        // Set up method channel for receiving PIP state changes from native side
        platform.setMethodCallHandler(_handleMethodCall);
      }
    } catch (e) {
      _logger.e('Failed to initialize Native PIP service: $e');
    }
  }

  /// Handle method calls from native Android side
  Future<dynamic> _handleMethodCall(MethodCall call) async {
    switch (call.method) {
      case 'onPipModeChanged':
        final isInPip = call.arguments as bool;
        _updatePipMode(isInPip);
        break;
    }
  }

  /// Update PIP mode state and notify listeners
  void _updatePipMode(bool isInPip) {
    if (_isInPipMode != isInPip) {
      _isInPipMode = isInPip;
      _pipModeController.add(isInPip);
      _logger.d('PIP mode changed: $isInPip');
    }
  }

  /// Enter native Android PIP mode using system method
  Future<bool> enterPipMode({double? aspectRatio}) async {
    try {
      if (!_isPipSupported || !Platform.isAndroid) {
        _logger.w('PIP not supported on this device');
        return false;
      }

      _logger.i('Attempting to enter native PIP mode...');
      _logger.d('Calling platform method: enterPipMode');
      
      // Use method channel to call native Android PIP
      final result = await platform.invokeMethod('enterPipMode', {
        'aspectRatio': aspectRatio ?? (16.0 / 9.0),
      });

      _logger.d('Platform method result: $result');
      _isInPipMode = result == true;
      
      if (_isInPipMode) {
        _logger.i('Successfully entered native PIP mode');
      } else {
        _logger.e('Failed to enter native PIP mode');
      }

      return _isInPipMode;
    } catch (e, stackTrace) {
      _logger.e('Error entering PIP mode: $e');
      _logger.d('Stack trace: $stackTrace');
      return false;
    }
  }

  /// Exit native PIP mode
  Future<bool> exitPipMode() async {
    try {
      _isInPipMode = false;
      _logger.i('Exited PIP mode');
      return true;
    } catch (e) {
      _logger.e('Error exiting PIP mode: $e');
      return false;
    }
  }

  /// Toggle PIP mode
  Future<bool> togglePipMode({double? aspectRatio}) async {
    if (_isInPipMode) {
      return await exitPipMode();
    } else {
      return await enterPipMode(aspectRatio: aspectRatio);
    }
  }

  /// Dispose resources
  void dispose() {
    _pipModeController.close();
  }
}
