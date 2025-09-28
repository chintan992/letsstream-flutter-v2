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
      }
    } catch (e) {
      _logger.e('Failed to initialize Native PIP service: $e');
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
      print('🚀 Calling platform method: enterPipMode');
      
      // Use method channel to call native Android PIP
      final result = await platform.invokeMethod('enterPipMode', {
        'aspectRatio': aspectRatio ?? (16.0 / 9.0),
      });

      print('📱 Platform method result: $result');
      _isInPipMode = result == true;
      
      if (_isInPipMode) {
        _logger.i('Successfully entered native PIP mode');
        print('✅ Native PIP activated successfully');
      } else {
        _logger.e('Failed to enter native PIP mode');
        print('❌ Native PIP activation failed');
      }

      return _isInPipMode;
    } catch (e, stackTrace) {
      _logger.e('Error entering PIP mode: $e');
      print('💥 Exception in enterPipMode: $e');
      print('📍 Stack trace: $stackTrace');
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
}
