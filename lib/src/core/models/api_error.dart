import 'package:freezed_annotation/freezed_annotation.dart';

part 'api_error.freezed.dart';

@freezed
class ApiError with _$ApiError {
  const factory ApiError.network({
    required String message,
    required int? statusCode,
    String? details,
  }) = NetworkError;

  const factory ApiError.timeout({required String message, String? details}) =
      TimeoutError;

  const factory ApiError.rateLimit({
    required String message,
    required int? retryAfter,
    String? details,
  }) = RateLimitError;

  const factory ApiError.unauthorized({
    required String message,
    String? details,
  }) = UnauthorizedError;

  const factory ApiError.notFound({required String message, String? details}) =
      NotFoundError;

  const factory ApiError.server({
    required String message,
    required int? statusCode,
    String? details,
  }) = ServerError;

  const factory ApiError.parsing({required String message, String? details}) =
      ParsingError;

  const factory ApiError.unknown({required String message, String? details}) =
      UnknownError;

  const factory ApiError.offline({required String message, String? details}) =
      OfflineError;
}

extension ApiErrorExtension on ApiError {
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
