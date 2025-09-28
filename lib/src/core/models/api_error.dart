import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';

/// A sealed class representing different types of API errors.
///
/// This class uses the Freezed package to generate immutable error classes
/// for various API failure scenarios including network issues, timeouts,
/// authentication problems, and server errors.
///
/// Each error type includes relevant information like error messages,
/// status codes, and additional details for debugging and user feedback.
@freezed
class ApiError with _$ApiError {
  /// Creates a network error for connection-related issues.
  ///
  /// [message] A description of the network error.
  /// [statusCode] The HTTP status code if available.
  /// [details] Additional error details for debugging.
  const factory ApiError.network({
    required String message,
    required int? statusCode,
    String? details,
  }) = NetworkError;

  /// Creates a timeout error for request timeout issues.
  ///
  /// [message] A description of the timeout error.
  /// [details] Additional error details for debugging.
  const factory ApiError.timeout({required String message, String? details}) =
      TimeoutError;

  /// Creates a rate limit error for API quota exceeded issues.
  ///
  /// [message] A description of the rate limit error.
  /// [retryAfter] Number of seconds to wait before retrying.
  /// [details] Additional error details for debugging.
  const factory ApiError.rateLimit({
    required String message,
    required int? retryAfter,
    String? details,
  }) = RateLimitError;

  /// Creates an unauthorized error for authentication failures.
  ///
  /// [message] A description of the authorization error.
  /// [details] Additional error details for debugging.
  const factory ApiError.unauthorized({
    required String message,
    String? details,
  }) = UnauthorizedError;

  /// Creates a not found error for 404 responses.
  ///
  /// [message] A description of the not found error.
  /// [details] Additional error details for debugging.
  const factory ApiError.notFound({required String message, String? details}) =
      NotFoundError;

  /// Creates a server error for 5xx HTTP status codes.
  ///
  /// [message] A description of the server error.
  /// [statusCode] The HTTP status code.
  /// [details] Additional error details for debugging.
  const factory ApiError.server({
    required String message,
    required int? statusCode,
    String? details,
  }) = ServerError;

  /// Creates a parsing error for JSON/data parsing failures.
  ///
  /// [message] A description of the parsing error.
  /// [details] Additional error details for debugging.
  const factory ApiError.parsing({required String message, String? details}) =
      ParsingError;

  /// Creates an unknown error for unexpected failures.
  ///
  /// [message] A description of the unknown error.
  /// [details] Additional error details for debugging.
  const factory ApiError.unknown({required String message, String? details}) =
      UnknownError;

  /// Creates an offline error for network connectivity issues.
  ///
  /// [message] A description of the offline error.
  /// [details] Additional error details for debugging.
  const factory ApiError.offline({required String message, String? details}) =
      OfflineError;
}

/// Extension providing utility methods for [ApiError] instances.
extension ApiErrorExtension on ApiError {
  /// Determines if this error type is retryable.
  ///
  /// Returns true for network errors, timeouts, rate limits, server errors (5xx),
  /// unknown errors, and offline errors. Returns false for authorization,
  /// not found, and parsing errors.
  bool get isRetryable => when(
    network: (message, statusCode, details) => true,
    timeout: (message, details) => true,
    rateLimit: (message, retryAfter, details) => true,
    unauthorized: (message, details) => false,
    notFound: (message, details) => false,
    server: (message, statusCode, details) =>
        statusCode != null && statusCode >= 500,
    parsing: (message, details) => false,
    unknown: (message, details) => true,
    offline: (message, details) => true,
  );

  /// Gets a user-friendly error message for display.
  ///
  /// Returns localized, user-friendly messages appropriate for showing
  /// to end users instead of technical error details.
  String get userFriendlyMessage => when(
    network: (message, statusCode, details) =>
        'Connection error. Please check your internet connection.',
    timeout: (message, details) => 'Request timed out. Please try again.',
    rateLimit: (message, retryAfter, details) =>
        'Too many requests. Please wait a moment.',
    unauthorized: (message, details) =>
        'Authentication failed. Please check your credentials.',
    notFound: (message, details) => 'Content not found.',
    server: (message, statusCode, details) =>
        'Server error. Please try again later.',
    parsing: (message, details) => 'Data processing error. Please try again.',
    unknown: (message, details) =>
        'An unexpected error occurred. Please try again.',
    offline: (message, details) =>
        'You are offline. Please check your connection.',
  );

  /// Gets the recommended retry delay in milliseconds for this error type.
  ///
  /// Returns appropriate delay times for different error types:
  /// - Network errors: 1000ms
  /// - Timeouts: 2000ms
  /// - Rate limits: Uses retryAfter value or 60 seconds
  /// - Server errors: 5000ms
  /// - Unknown errors: 3000ms
  /// - Offline errors: 2000ms
  /// - Non-retryable errors: 0ms
  int get retryDelayMs => when(
    network: (message, statusCode, details) => 1000,
    timeout: (message, details) => 2000,
    rateLimit: (message, retryAfter, details) => (retryAfter ?? 60) * 1000,
    unauthorized: (message, details) => 0,
    notFound: (message, details) => 0,
    server: (message, statusCode, details) => 5000,
    parsing: (message, details) => 0,
    unknown: (message, details) => 3000,
    offline: (message, details) => 2000,
  );
}
