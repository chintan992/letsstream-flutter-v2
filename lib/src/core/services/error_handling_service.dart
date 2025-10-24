import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:lets_stream/src/core/models/api_error.dart';

/// Enhanced error handling service with retry mechanisms and user-friendly messages
class ErrorHandlingService {
  static final ErrorHandlingService _instance =
      ErrorHandlingService._internal();
  factory ErrorHandlingService() => _instance;
  ErrorHandlingService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<List<ConnectivityResult>>? _connectivitySubscription;

  /// Initialize the service
  void initialize() {
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen((
      result,
    ) {
      // Handle connectivity changes if needed
    });
  }

  /// Dispose of resources
  void dispose() {
    _connectivitySubscription?.cancel();
  }

  /// Enhanced retry mechanism with exponential backoff
  Future<T> retryWithBackoff<T>(
    Future<T> Function() operation, {
    int maxRetries = 3,
    Duration initialDelay = const Duration(seconds: 1),
    double backoffMultiplier = 2.0,
    bool Function(Object error)? shouldRetry,
  }) async {
    int attempt = 0;
    Duration delay = initialDelay;

    while (attempt < maxRetries) {
      try {
        return await operation();
      } catch (error) {
        attempt++;

        // Check if we should retry this error
        if (shouldRetry != null && !shouldRetry(error)) {
          rethrow;
        }

        // Don't retry on the last attempt
        if (attempt >= maxRetries) {
          rethrow;
        }

        // Check for network connectivity before retrying
        final connectivityResults = await _connectivity.checkConnectivity();
        if (connectivityResults.contains(ConnectivityResult.none)) {
          // No network connection, don't retry
          rethrow;
        }

        // Wait before retrying
        await Future.delayed(delay);
        delay = Duration(
          milliseconds: (delay.inMilliseconds * backoffMultiplier).round(),
        );
      }
    }

    throw Exception('Max retries exceeded');
  }

  /// Categorize errors and provide user-friendly messages
  ErrorInfo categorizeError(Object error) {
    if (error is ApiError) {
      return _categorizeApiError(error);
    } else if (error is SocketException) {
      return const ErrorInfo(
        type: ErrorType.network,
        title: 'Connection Error',
        message:
            'Unable to connect to the server. Please check your internet connection.',
        canRetry: true,
        icon: Icons.wifi_off,
      );
    } else if (error is TimeoutException) {
      return const ErrorInfo(
        type: ErrorType.timeout,
        title: 'Request Timeout',
        message: 'The request took too long to complete. Please try again.',
        canRetry: true,
        icon: Icons.timer_off,
      );
    } else if (error is FormatException) {
      return const ErrorInfo(
        type: ErrorType.parsing,
        title: 'Data Error',
        message: 'There was a problem processing the received data.',
        canRetry: true,
        icon: Icons.bug_report,
      );
    } else {
      return const ErrorInfo(
        type: ErrorType.unknown,
        title: 'Unexpected Error',
        message: 'Something went wrong. Please try again.',
        canRetry: true,
        icon: Icons.error,
      );
    }
  }

  ErrorInfo _categorizeApiError(ApiError error) {
    return error.maybeWhen(
      network: (message, statusCode, details) => const ErrorInfo(
        type: ErrorType.network,
        title: 'Network Error',
        message:
            'Unable to connect to the server. Please check your connection.',
        canRetry: true,
        icon: Icons.wifi_off,
      ),
      timeout: (message, details) => const ErrorInfo(
        type: ErrorType.timeout,
        title: 'Request Timeout',
        message: 'The request took too long to complete.',
        canRetry: true,
        icon: Icons.timer_off,
      ),
      rateLimit: (message, retryAfter, details) => ErrorInfo(
        type: ErrorType.rateLimit,
        title: 'Too Many Requests',
        message: 'Please wait a moment before trying again.',
        canRetry: true,
        retryAfter: retryAfter != null ? Duration(seconds: retryAfter) : null,
        icon: Icons.speed,
      ),
      unauthorized: (message, details) => const ErrorInfo(
        type: ErrorType.auth,
        title: 'Authentication Error',
        message: 'Please sign in to continue.',
        canRetry: false,
        icon: Icons.lock,
      ),
      notFound: (message, details) => const ErrorInfo(
        type: ErrorType.notFound,
        title: 'Not Found',
        message: 'The requested content could not be found.',
        canRetry: false,
        icon: Icons.search_off,
      ),
      server: (message, statusCode, details) => const ErrorInfo(
        type: ErrorType.server,
        title: 'Server Error',
        message: 'The server encountered an error. Please try again later.',
        canRetry: true,
        icon: Icons.cloud_off,
      ),
      parsing: (message, details) => const ErrorInfo(
        type: ErrorType.parsing,
        title: 'Data Error',
        message: 'There was a problem processing the received data.',
        canRetry: true,
        icon: Icons.bug_report,
      ),
      offline: (message, details) => const ErrorInfo(
        type: ErrorType.offline,
        title: 'Offline Mode',
        message: 'You appear to be offline. Please check your connection.',
        canRetry: true,
        icon: Icons.signal_wifi_off,
      ),
      orElse: () => const ErrorInfo(
        type: ErrorType.unknown,
        title: 'Unknown Error',
        message: 'An unexpected error occurred.',
        canRetry: true,
        icon: Icons.error,
      ),
    );
  }

  /// Check if the device is online
  Future<bool> isOnline() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return !results.contains(ConnectivityResult.none);
    } catch (e) {
      return false;
    }
  }

  /// Get user-friendly error widget
  Widget buildErrorWidget(
    BuildContext context, {
    required Object error,
    required VoidCallback onRetry,
    bool showRetryButton = true,
  }) {
    final errorInfo = categorizeError(error);
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer,
                shape: BoxShape.circle,
              ),
              child: Icon(
                errorInfo.icon,
                size: 40,
                color: theme.colorScheme.onErrorContainer,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              errorInfo.title,
              style: theme.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              errorInfo.message,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (showRetryButton && errorInfo.canRetry) ...[
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
            if (errorInfo.retryAfter != null) ...[
              const SizedBox(height: 16),
              Text(
                'Retry available in ${errorInfo.retryAfter!.inSeconds} seconds',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error type enumeration
enum ErrorType {
  network,
  timeout,
  rateLimit,
  auth,
  notFound,
  server,
  parsing,
  offline,
  unknown,
}

/// Structured error information
class ErrorInfo {
  final ErrorType type;
  final String title;
  final String message;
  final bool canRetry;
  final IconData icon;
  final Duration? retryAfter;

  const ErrorInfo({
    required this.type,
    required this.title,
    required this.message,
    required this.canRetry,
    required this.icon,
    this.retryAfter,
  });
}
