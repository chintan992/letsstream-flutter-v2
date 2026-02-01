import 'dart:async';
import 'dart:io';
import 'package:floating_window_plus/floating_window_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';

/// Represents the availability of Picture-in-Picture functionality on the current platform.
enum PipAvailability { available, unavailable, unknown }

/// Represents the current state of the Picture-in-Picture service.
enum PipState { inactive, activating, active, error }

/// Simple PIP widget that doesn't use WebView to prevent resource conflicts
class SimplePipWidget extends StatelessWidget {
  final String? videoUrl;
  final String? selectedSourceName;

  const SimplePipWidget({
    super.key,
    required this.videoUrl,
    this.selectedSourceName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.black,
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.play_circle_outline,
              color: Colors.white70,
              size: 48,
            ),
            const SizedBox(height: 12),
            const Text(
              'PIP Video Player',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            if (selectedSourceName != null)
              Text(
                selectedSourceName!,
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            const SizedBox(height: 8),
            const Text(
              'Tap to return to fullscreen',
              style: TextStyle(
                color: Colors.white38,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Widget to display video content in PIP window using InAppWebView.
class VideoPIPWidget extends StatelessWidget {
  final String? videoUrl;
  final String? selectedSourceName;

  const VideoPIPWidget({
    super.key,
    required this.videoUrl,
    this.selectedSourceName,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 180,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4)),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Container(
          color: Colors.black,
          child: videoUrl != null && videoUrl!.isNotEmpty
              ? _buildWebView()
              : const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.video_call, color: Colors.white54, size: 48),
                      SizedBox(height: 8),
                      Text('No Video', style: TextStyle(color: Colors.white54)),
                    ],
                  ),
                ),
        ),
      ),
    );
  }

  Widget _buildWebView() {
    try {
      return InAppWebView(
        key: ValueKey('pip_webview_${videoUrl.hashCode}'), // Unique key for PIP WebView
        initialUrlRequest: URLRequest(url: WebUri(videoUrl!)),
        initialSettings: InAppWebViewSettings(
          allowsPictureInPictureMediaPlayback: false, // Disable nested PIP
          useShouldOverrideUrlLoading: true,
          domStorageEnabled: true,
          javaScriptEnabled: true,
          useWideViewPort: true,
          loadWithOverviewMode: true,
          supportZoom: false,
          disableContextMenu: true,
          disableVerticalScroll: true,
          disableHorizontalScroll: true,
          // Additional settings to prevent conflicts
          mediaPlaybackRequiresUserGesture: false,
          allowsInlineMediaPlayback: true,
        ),
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          // Only allow the video URL and related requests
          final url = navigationAction.request.url.toString();
          if (url.contains(videoUrl!) ||
              url.contains('googlevideo.com') ||
              url.contains('youtube.com') ||
              url.contains('vidstreaming') ||
              url.contains('embedsu')) {
            return NavigationActionPolicy.ALLOW;
          }
          return NavigationActionPolicy.CANCEL;
        },
        onLoadStart: (controller, url) {
          // Handle loading start if needed
        },
        onLoadStop: (controller, url) {
          // Handle loading stop if needed
        },
        onReceivedError: (controller, request, error) {
          // Handle load error - using onReceivedError instead of deprecated onLoadError
          debugPrint('PIP WebView error: ${error.description}');
        },
      );
    } catch (e) {
      debugPrint('Error creating PIP WebView: $e');
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, color: Colors.red, size: 48),
            SizedBox(height: 8),
            Text('PIP Error', style: TextStyle(color: Colors.white54)),
          ],
        ),
      );
    }
  }
}

/// Service for managing Picture-in-Picture functionality using floating_window_plus.
/// This service provides PIP controller management and state tracking.
class PipService {
  final Logger _logger = Logger();
  final StreamController<PipState> _stateController =
      StreamController<PipState>.broadcast();
  
  late PipController _pipController;
  Widget? _currentPipContent;
  
  Stream<PipState> get stateStream => _stateController.stream;
  PipState _currentState = PipState.inactive;

  PipState get currentState => _currentState;
  PipAvailability _availability = PipAvailability.unknown;

  PipAvailability get availability => _availability;

  static PipService? _instance;
  static PipService get instance => _instance ??= PipService._();

  PipService._() {
    _initialize();
  }

  void _initialize() async {
    try {
      _availability = await _checkPipAvailability();
      
      // Initialize PipController with appropriate settings
      _pipController = PipController(
        settings: const PipSettings(
          collapsedWidth: 150,
          collapsedHeight: 90,
          expandedWidth: 300,
          expandedHeight: 180,
          allowExpand: true,
        ),
        bottomSafePadding: 100,
        isSnaping: true,
        margin: 16,
      );
      
      // Listen to controller state changes
      _pipController.addListener(_onPipControllerChanged);
      
      _logger.i('PIP service initialized - availability: $_availability');
    } catch (e, stackTrace) {
      _logger.e('Failed to initialize PIP service: $e');
      _logger.e('Stack trace: $stackTrace');
      _availability = PipAvailability.unknown;
      _updateState(PipState.error);
    }
  }

  void _onPipControllerChanged() {
    try {
      final wasActive = _currentState == PipState.active;
      final isActive = _pipController.isVisible;
      
      if (wasActive != isActive) {
        if (isActive) {
          _updateState(PipState.active);
          _logger.i('PIP activated via controller');
        } else {
          _updateState(PipState.inactive);
          _logger.i('PIP deactivated via controller');
        }
      }
    } catch (e, stackTrace) {
      _logger.e('Error in PIP controller state change: $e');
      _logger.e('Stack trace: $stackTrace');
      _updateState(PipState.error);
    }
  }

  Future<PipAvailability> _checkPipAvailability() async {
    if (!Platform.isAndroid) {
      _logger.w('PIP is only available on Android');
      return PipAvailability.unavailable;
    }

    try {
      // floating_window_plus works on Android
      _logger.i('PIP is available on this Android device');
      return PipAvailability.available;
    } catch (e) {
      _logger.e('Error checking PIP availability: $e');
      return PipAvailability.unknown;
    }
  }

  /// Enable PIP mode with the given content
  Future<bool> enablePip({
    required Widget pipWidget,
    required Rect? rational,
    dynamic aspectRatio,
    String? videoUrl,
  }) async {
    if (_availability != PipAvailability.available) {
      _logger.w('PIP mode is not available on this platform');
      _updateState(PipState.error);
      return false;
    }

    try {
      _updateState(PipState.activating);
      _logger.i('Attempting to enable PIP mode...');

      // Create the content widget
      Widget content = pipWidget;
      if (videoUrl != null && videoUrl.isNotEmpty) {
        content = SimplePipWidget(
          videoUrl: videoUrl,
          selectedSourceName: 'PIP Video',
        );
      }

      _currentPipContent = content;
      _pipController.show();
      
      // Give it a moment to activate
      await Future.delayed(const Duration(milliseconds: 300));

      if (_pipController.isVisible) {
        _updateState(PipState.active);
        _logger.i('PIP mode enabled successfully');
        return true;
      } else {
        _logger.w('PIP controller did not become visible');
        _updateState(PipState.error);
        return false;
      }
    } catch (e) {
      _logger.e('Error enabling PIP mode: $e');
      _updateState(PipState.error);
      return false;
    }
  }

  /// Disable PIP mode
  Future<bool> disablePip() async {
    if (_currentState != PipState.active) {
      _logger.w('PIP mode is not currently active');
      return true;
    }

    try {
      _logger.i('Disabling PIP mode...');
      _pipController.hide();
      _currentPipContent = null;
      _updateState(PipState.inactive);
      _logger.i('PIP mode disabled successfully');
      return true;
    } catch (e) {
      _logger.e('Error disabling PIP mode: $e');
      _updateState(PipState.error);
      return false;
    }
  }

  /// Toggle PIP mode
  Future<bool> togglePip({
    required Widget pipWidget,
    required Rect? rational,
    dynamic aspectRatio,
    String? videoUrl,
  }) async {
    switch (_currentState) {
      case PipState.active:
        return await disablePip();
      case PipState.inactive:
        return await enablePip(
          pipWidget: pipWidget,
          rational: rational,
          aspectRatio: aspectRatio,
          videoUrl: videoUrl,
        );
      case PipState.activating:
      case PipState.error:
        _logger.w('Cannot toggle PIP in current state: $_currentState');
        return false;
    }
  }

  /// Get the PIP controller for direct access
  PipController get pipController => _pipController;

  /// Get current PIP content widget
  Widget? get currentPipContent => _currentPipContent;

  void _updateState(PipState newState) {
    if (newState != _currentState) {
      _currentState = newState;
      _stateController.add(_currentState);
      _logger.d('PIP state changed to: $_currentState');
    }
  }

  bool get isPipActive => _currentState == PipState.active;
  bool get isPipAvailable => _availability == PipAvailability.available;

  void dispose() {
    _pipController.removeListener(_onPipControllerChanged);
    _pipController.dispose();
    _stateController.close();
  }
}

// Riverpod providers
final pipServiceProvider = Provider<PipService>((ref) {
  return PipService.instance;
});

final pipStateProvider = StreamProvider<PipState>((ref) {
  final service = ref.watch(pipServiceProvider);
  return service.stateStream;
});

final pipAvailabilityProvider = Provider<PipAvailability>((ref) {
  final service = ref.watch(pipServiceProvider);
  return service.availability;
});

final isPipActiveProvider = Provider<bool>((ref) {
  final service = ref.watch(pipServiceProvider);
  return service.isPipActive;
});

final isPipAvailableProvider = Provider<bool>((ref) {
  final service = ref.watch(pipServiceProvider);
  return service.isPipAvailable;
});
