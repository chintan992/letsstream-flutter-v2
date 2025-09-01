// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'api_error.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$ApiError {
  String get message => throw _privateConstructorUsedError;
  String? get details => throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode, String? details)
        network,
    required TResult Function(String message, String? details) timeout,
    required TResult Function(String message, int? retryAfter, String? details)
        rateLimit,
    required TResult Function(String message, String? details) unauthorized,
    required TResult Function(String message, String? details) notFound,
    required TResult Function(String message, int? statusCode, String? details)
        server,
    required TResult Function(String message, String? details) parsing,
    required TResult Function(String message, String? details) unknown,
    required TResult Function(String message, String? details) offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? details)?
        network,
    TResult? Function(String message, String? details)? timeout,
    TResult? Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult? Function(String message, String? details)? unauthorized,
    TResult? Function(String message, String? details)? notFound,
    TResult? Function(String message, int? statusCode, String? details)? server,
    TResult? Function(String message, String? details)? parsing,
    TResult? Function(String message, String? details)? unknown,
    TResult? Function(String message, String? details)? offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? details)? network,
    TResult Function(String message, String? details)? timeout,
    TResult Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult Function(String message, String? details)? unauthorized,
    TResult Function(String message, String? details)? notFound,
    TResult Function(String message, int? statusCode, String? details)? server,
    TResult Function(String message, String? details)? parsing,
    TResult Function(String message, String? details)? unknown,
    TResult Function(String message, String? details)? offline,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(RateLimitError value) rateLimit,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(NotFoundError value) notFound,
    required TResult Function(ServerError value) server,
    required TResult Function(ParsingError value) parsing,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(OfflineError value) offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(RateLimitError value)? rateLimit,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(NotFoundError value)? notFound,
    TResult? Function(ServerError value)? server,
    TResult? Function(ParsingError value)? parsing,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(OfflineError value)? offline,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(RateLimitError value)? rateLimit,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(NotFoundError value)? notFound,
    TResult Function(ServerError value)? server,
    TResult Function(ParsingError value)? parsing,
    TResult Function(UnknownError value)? unknown,
    TResult Function(OfflineError value)? offline,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $ApiErrorCopyWith<ApiError> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ApiErrorCopyWith<$Res> {
  factory $ApiErrorCopyWith(ApiError value, $Res Function(ApiError) then) =
      _$ApiErrorCopyWithImpl<$Res, ApiError>;
  @useResult
  $Res call({String message, String? details});
}

/// @nodoc
class _$ApiErrorCopyWithImpl<$Res, $Val extends ApiError>
    implements $ApiErrorCopyWith<$Res> {
  _$ApiErrorCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? details = freezed,
  }) {
    return _then(_value.copyWith(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$NetworkErrorImplCopyWith<$Res>
    implements $ApiErrorCopyWith<$Res> {
  factory _$$NetworkErrorImplCopyWith(
          _$NetworkErrorImpl value, $Res Function(_$NetworkErrorImpl) then) =
      __$$NetworkErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? statusCode, String? details});
}

/// @nodoc
class __$$NetworkErrorImplCopyWithImpl<$Res>
    extends _$ApiErrorCopyWithImpl<$Res, _$NetworkErrorImpl>
    implements _$$NetworkErrorImplCopyWith<$Res> {
  __$$NetworkErrorImplCopyWithImpl(
      _$NetworkErrorImpl _value, $Res Function(_$NetworkErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? statusCode = freezed,
    Object? details = freezed,
  }) {
    return _then(_$NetworkErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NetworkErrorImpl implements NetworkError {
  const _$NetworkErrorImpl(
      {required this.message, required this.statusCode, this.details});

  @override
  final String message;
  @override
  final int? statusCode;
  @override
  final String? details;

  @override
  String toString() {
    return 'ApiError.network(message: $message, statusCode: $statusCode, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NetworkErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NetworkErrorImplCopyWith<_$NetworkErrorImpl> get copyWith =>
      __$$NetworkErrorImplCopyWithImpl<_$NetworkErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode, String? details)
        network,
    required TResult Function(String message, String? details) timeout,
    required TResult Function(String message, int? retryAfter, String? details)
        rateLimit,
    required TResult Function(String message, String? details) unauthorized,
    required TResult Function(String message, String? details) notFound,
    required TResult Function(String message, int? statusCode, String? details)
        server,
    required TResult Function(String message, String? details) parsing,
    required TResult Function(String message, String? details) unknown,
    required TResult Function(String message, String? details) offline,
  }) {
    return network(message, statusCode, details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? details)?
        network,
    TResult? Function(String message, String? details)? timeout,
    TResult? Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult? Function(String message, String? details)? unauthorized,
    TResult? Function(String message, String? details)? notFound,
    TResult? Function(String message, int? statusCode, String? details)? server,
    TResult? Function(String message, String? details)? parsing,
    TResult? Function(String message, String? details)? unknown,
    TResult? Function(String message, String? details)? offline,
  }) {
    return network?.call(message, statusCode, details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? details)? network,
    TResult Function(String message, String? details)? timeout,
    TResult Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult Function(String message, String? details)? unauthorized,
    TResult Function(String message, String? details)? notFound,
    TResult Function(String message, int? statusCode, String? details)? server,
    TResult Function(String message, String? details)? parsing,
    TResult Function(String message, String? details)? unknown,
    TResult Function(String message, String? details)? offline,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(message, statusCode, details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(RateLimitError value) rateLimit,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(NotFoundError value) notFound,
    required TResult Function(ServerError value) server,
    required TResult Function(ParsingError value) parsing,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(OfflineError value) offline,
  }) {
    return network(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(RateLimitError value)? rateLimit,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(NotFoundError value)? notFound,
    TResult? Function(ServerError value)? server,
    TResult? Function(ParsingError value)? parsing,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(OfflineError value)? offline,
  }) {
    return network?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(RateLimitError value)? rateLimit,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(NotFoundError value)? notFound,
    TResult Function(ServerError value)? server,
    TResult Function(ParsingError value)? parsing,
    TResult Function(UnknownError value)? unknown,
    TResult Function(OfflineError value)? offline,
    required TResult orElse(),
  }) {
    if (network != null) {
      return network(this);
    }
    return orElse();
  }
}

abstract class NetworkError implements ApiError {
  const factory NetworkError(
      {required final String message,
      required final int? statusCode,
      final String? details}) = _$NetworkErrorImpl;

  @override
  String get message;
  int? get statusCode;
  @override
  String? get details;
  @override
  @JsonKey(ignore: true)
  _$$NetworkErrorImplCopyWith<_$NetworkErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$TimeoutErrorImplCopyWith<$Res>
    implements $ApiErrorCopyWith<$Res> {
  factory _$$TimeoutErrorImplCopyWith(
          _$TimeoutErrorImpl value, $Res Function(_$TimeoutErrorImpl) then) =
      __$$TimeoutErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? details});
}

/// @nodoc
class __$$TimeoutErrorImplCopyWithImpl<$Res>
    extends _$ApiErrorCopyWithImpl<$Res, _$TimeoutErrorImpl>
    implements _$$TimeoutErrorImplCopyWith<$Res> {
  __$$TimeoutErrorImplCopyWithImpl(
      _$TimeoutErrorImpl _value, $Res Function(_$TimeoutErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? details = freezed,
  }) {
    return _then(_$TimeoutErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$TimeoutErrorImpl implements TimeoutError {
  const _$TimeoutErrorImpl({required this.message, this.details});

  @override
  final String message;
  @override
  final String? details;

  @override
  String toString() {
    return 'ApiError.timeout(message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TimeoutErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TimeoutErrorImplCopyWith<_$TimeoutErrorImpl> get copyWith =>
      __$$TimeoutErrorImplCopyWithImpl<_$TimeoutErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode, String? details)
        network,
    required TResult Function(String message, String? details) timeout,
    required TResult Function(String message, int? retryAfter, String? details)
        rateLimit,
    required TResult Function(String message, String? details) unauthorized,
    required TResult Function(String message, String? details) notFound,
    required TResult Function(String message, int? statusCode, String? details)
        server,
    required TResult Function(String message, String? details) parsing,
    required TResult Function(String message, String? details) unknown,
    required TResult Function(String message, String? details) offline,
  }) {
    return timeout(message, details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? details)?
        network,
    TResult? Function(String message, String? details)? timeout,
    TResult? Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult? Function(String message, String? details)? unauthorized,
    TResult? Function(String message, String? details)? notFound,
    TResult? Function(String message, int? statusCode, String? details)? server,
    TResult? Function(String message, String? details)? parsing,
    TResult? Function(String message, String? details)? unknown,
    TResult? Function(String message, String? details)? offline,
  }) {
    return timeout?.call(message, details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? details)? network,
    TResult Function(String message, String? details)? timeout,
    TResult Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult Function(String message, String? details)? unauthorized,
    TResult Function(String message, String? details)? notFound,
    TResult Function(String message, int? statusCode, String? details)? server,
    TResult Function(String message, String? details)? parsing,
    TResult Function(String message, String? details)? unknown,
    TResult Function(String message, String? details)? offline,
    required TResult orElse(),
  }) {
    if (timeout != null) {
      return timeout(message, details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(RateLimitError value) rateLimit,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(NotFoundError value) notFound,
    required TResult Function(ServerError value) server,
    required TResult Function(ParsingError value) parsing,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(OfflineError value) offline,
  }) {
    return timeout(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(RateLimitError value)? rateLimit,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(NotFoundError value)? notFound,
    TResult? Function(ServerError value)? server,
    TResult? Function(ParsingError value)? parsing,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(OfflineError value)? offline,
  }) {
    return timeout?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(RateLimitError value)? rateLimit,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(NotFoundError value)? notFound,
    TResult Function(ServerError value)? server,
    TResult Function(ParsingError value)? parsing,
    TResult Function(UnknownError value)? unknown,
    TResult Function(OfflineError value)? offline,
    required TResult orElse(),
  }) {
    if (timeout != null) {
      return timeout(this);
    }
    return orElse();
  }
}

abstract class TimeoutError implements ApiError {
  const factory TimeoutError(
      {required final String message,
      final String? details}) = _$TimeoutErrorImpl;

  @override
  String get message;
  @override
  String? get details;
  @override
  @JsonKey(ignore: true)
  _$$TimeoutErrorImplCopyWith<_$TimeoutErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$RateLimitErrorImplCopyWith<$Res>
    implements $ApiErrorCopyWith<$Res> {
  factory _$$RateLimitErrorImplCopyWith(_$RateLimitErrorImpl value,
          $Res Function(_$RateLimitErrorImpl) then) =
      __$$RateLimitErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? retryAfter, String? details});
}

/// @nodoc
class __$$RateLimitErrorImplCopyWithImpl<$Res>
    extends _$ApiErrorCopyWithImpl<$Res, _$RateLimitErrorImpl>
    implements _$$RateLimitErrorImplCopyWith<$Res> {
  __$$RateLimitErrorImplCopyWithImpl(
      _$RateLimitErrorImpl _value, $Res Function(_$RateLimitErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? retryAfter = freezed,
    Object? details = freezed,
  }) {
    return _then(_$RateLimitErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      retryAfter: freezed == retryAfter
          ? _value.retryAfter
          : retryAfter // ignore: cast_nullable_to_non_nullable
              as int?,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$RateLimitErrorImpl implements RateLimitError {
  const _$RateLimitErrorImpl(
      {required this.message, required this.retryAfter, this.details});

  @override
  final String message;
  @override
  final int? retryAfter;
  @override
  final String? details;

  @override
  String toString() {
    return 'ApiError.rateLimit(message: $message, retryAfter: $retryAfter, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$RateLimitErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.retryAfter, retryAfter) ||
                other.retryAfter == retryAfter) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, retryAfter, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$RateLimitErrorImplCopyWith<_$RateLimitErrorImpl> get copyWith =>
      __$$RateLimitErrorImplCopyWithImpl<_$RateLimitErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode, String? details)
        network,
    required TResult Function(String message, String? details) timeout,
    required TResult Function(String message, int? retryAfter, String? details)
        rateLimit,
    required TResult Function(String message, String? details) unauthorized,
    required TResult Function(String message, String? details) notFound,
    required TResult Function(String message, int? statusCode, String? details)
        server,
    required TResult Function(String message, String? details) parsing,
    required TResult Function(String message, String? details) unknown,
    required TResult Function(String message, String? details) offline,
  }) {
    return rateLimit(message, retryAfter, details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? details)?
        network,
    TResult? Function(String message, String? details)? timeout,
    TResult? Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult? Function(String message, String? details)? unauthorized,
    TResult? Function(String message, String? details)? notFound,
    TResult? Function(String message, int? statusCode, String? details)? server,
    TResult? Function(String message, String? details)? parsing,
    TResult? Function(String message, String? details)? unknown,
    TResult? Function(String message, String? details)? offline,
  }) {
    return rateLimit?.call(message, retryAfter, details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? details)? network,
    TResult Function(String message, String? details)? timeout,
    TResult Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult Function(String message, String? details)? unauthorized,
    TResult Function(String message, String? details)? notFound,
    TResult Function(String message, int? statusCode, String? details)? server,
    TResult Function(String message, String? details)? parsing,
    TResult Function(String message, String? details)? unknown,
    TResult Function(String message, String? details)? offline,
    required TResult orElse(),
  }) {
    if (rateLimit != null) {
      return rateLimit(message, retryAfter, details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(RateLimitError value) rateLimit,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(NotFoundError value) notFound,
    required TResult Function(ServerError value) server,
    required TResult Function(ParsingError value) parsing,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(OfflineError value) offline,
  }) {
    return rateLimit(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(RateLimitError value)? rateLimit,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(NotFoundError value)? notFound,
    TResult? Function(ServerError value)? server,
    TResult? Function(ParsingError value)? parsing,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(OfflineError value)? offline,
  }) {
    return rateLimit?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(RateLimitError value)? rateLimit,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(NotFoundError value)? notFound,
    TResult Function(ServerError value)? server,
    TResult Function(ParsingError value)? parsing,
    TResult Function(UnknownError value)? unknown,
    TResult Function(OfflineError value)? offline,
    required TResult orElse(),
  }) {
    if (rateLimit != null) {
      return rateLimit(this);
    }
    return orElse();
  }
}

abstract class RateLimitError implements ApiError {
  const factory RateLimitError(
      {required final String message,
      required final int? retryAfter,
      final String? details}) = _$RateLimitErrorImpl;

  @override
  String get message;
  int? get retryAfter;
  @override
  String? get details;
  @override
  @JsonKey(ignore: true)
  _$$RateLimitErrorImplCopyWith<_$RateLimitErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnauthorizedErrorImplCopyWith<$Res>
    implements $ApiErrorCopyWith<$Res> {
  factory _$$UnauthorizedErrorImplCopyWith(_$UnauthorizedErrorImpl value,
          $Res Function(_$UnauthorizedErrorImpl) then) =
      __$$UnauthorizedErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? details});
}

/// @nodoc
class __$$UnauthorizedErrorImplCopyWithImpl<$Res>
    extends _$ApiErrorCopyWithImpl<$Res, _$UnauthorizedErrorImpl>
    implements _$$UnauthorizedErrorImplCopyWith<$Res> {
  __$$UnauthorizedErrorImplCopyWithImpl(_$UnauthorizedErrorImpl _value,
      $Res Function(_$UnauthorizedErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? details = freezed,
  }) {
    return _then(_$UnauthorizedErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UnauthorizedErrorImpl implements UnauthorizedError {
  const _$UnauthorizedErrorImpl({required this.message, this.details});

  @override
  final String message;
  @override
  final String? details;

  @override
  String toString() {
    return 'ApiError.unauthorized(message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnauthorizedErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnauthorizedErrorImplCopyWith<_$UnauthorizedErrorImpl> get copyWith =>
      __$$UnauthorizedErrorImplCopyWithImpl<_$UnauthorizedErrorImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode, String? details)
        network,
    required TResult Function(String message, String? details) timeout,
    required TResult Function(String message, int? retryAfter, String? details)
        rateLimit,
    required TResult Function(String message, String? details) unauthorized,
    required TResult Function(String message, String? details) notFound,
    required TResult Function(String message, int? statusCode, String? details)
        server,
    required TResult Function(String message, String? details) parsing,
    required TResult Function(String message, String? details) unknown,
    required TResult Function(String message, String? details) offline,
  }) {
    return unauthorized(message, details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? details)?
        network,
    TResult? Function(String message, String? details)? timeout,
    TResult? Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult? Function(String message, String? details)? unauthorized,
    TResult? Function(String message, String? details)? notFound,
    TResult? Function(String message, int? statusCode, String? details)? server,
    TResult? Function(String message, String? details)? parsing,
    TResult? Function(String message, String? details)? unknown,
    TResult? Function(String message, String? details)? offline,
  }) {
    return unauthorized?.call(message, details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? details)? network,
    TResult Function(String message, String? details)? timeout,
    TResult Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult Function(String message, String? details)? unauthorized,
    TResult Function(String message, String? details)? notFound,
    TResult Function(String message, int? statusCode, String? details)? server,
    TResult Function(String message, String? details)? parsing,
    TResult Function(String message, String? details)? unknown,
    TResult Function(String message, String? details)? offline,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(message, details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(RateLimitError value) rateLimit,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(NotFoundError value) notFound,
    required TResult Function(ServerError value) server,
    required TResult Function(ParsingError value) parsing,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(OfflineError value) offline,
  }) {
    return unauthorized(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(RateLimitError value)? rateLimit,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(NotFoundError value)? notFound,
    TResult? Function(ServerError value)? server,
    TResult? Function(ParsingError value)? parsing,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(OfflineError value)? offline,
  }) {
    return unauthorized?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(RateLimitError value)? rateLimit,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(NotFoundError value)? notFound,
    TResult Function(ServerError value)? server,
    TResult Function(ParsingError value)? parsing,
    TResult Function(UnknownError value)? unknown,
    TResult Function(OfflineError value)? offline,
    required TResult orElse(),
  }) {
    if (unauthorized != null) {
      return unauthorized(this);
    }
    return orElse();
  }
}

abstract class UnauthorizedError implements ApiError {
  const factory UnauthorizedError(
      {required final String message,
      final String? details}) = _$UnauthorizedErrorImpl;

  @override
  String get message;
  @override
  String? get details;
  @override
  @JsonKey(ignore: true)
  _$$UnauthorizedErrorImplCopyWith<_$UnauthorizedErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$NotFoundErrorImplCopyWith<$Res>
    implements $ApiErrorCopyWith<$Res> {
  factory _$$NotFoundErrorImplCopyWith(
          _$NotFoundErrorImpl value, $Res Function(_$NotFoundErrorImpl) then) =
      __$$NotFoundErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? details});
}

/// @nodoc
class __$$NotFoundErrorImplCopyWithImpl<$Res>
    extends _$ApiErrorCopyWithImpl<$Res, _$NotFoundErrorImpl>
    implements _$$NotFoundErrorImplCopyWith<$Res> {
  __$$NotFoundErrorImplCopyWithImpl(
      _$NotFoundErrorImpl _value, $Res Function(_$NotFoundErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? details = freezed,
  }) {
    return _then(_$NotFoundErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$NotFoundErrorImpl implements NotFoundError {
  const _$NotFoundErrorImpl({required this.message, this.details});

  @override
  final String message;
  @override
  final String? details;

  @override
  String toString() {
    return 'ApiError.notFound(message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotFoundErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$NotFoundErrorImplCopyWith<_$NotFoundErrorImpl> get copyWith =>
      __$$NotFoundErrorImplCopyWithImpl<_$NotFoundErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode, String? details)
        network,
    required TResult Function(String message, String? details) timeout,
    required TResult Function(String message, int? retryAfter, String? details)
        rateLimit,
    required TResult Function(String message, String? details) unauthorized,
    required TResult Function(String message, String? details) notFound,
    required TResult Function(String message, int? statusCode, String? details)
        server,
    required TResult Function(String message, String? details) parsing,
    required TResult Function(String message, String? details) unknown,
    required TResult Function(String message, String? details) offline,
  }) {
    return notFound(message, details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? details)?
        network,
    TResult? Function(String message, String? details)? timeout,
    TResult? Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult? Function(String message, String? details)? unauthorized,
    TResult? Function(String message, String? details)? notFound,
    TResult? Function(String message, int? statusCode, String? details)? server,
    TResult? Function(String message, String? details)? parsing,
    TResult? Function(String message, String? details)? unknown,
    TResult? Function(String message, String? details)? offline,
  }) {
    return notFound?.call(message, details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? details)? network,
    TResult Function(String message, String? details)? timeout,
    TResult Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult Function(String message, String? details)? unauthorized,
    TResult Function(String message, String? details)? notFound,
    TResult Function(String message, int? statusCode, String? details)? server,
    TResult Function(String message, String? details)? parsing,
    TResult Function(String message, String? details)? unknown,
    TResult Function(String message, String? details)? offline,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(message, details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(RateLimitError value) rateLimit,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(NotFoundError value) notFound,
    required TResult Function(ServerError value) server,
    required TResult Function(ParsingError value) parsing,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(OfflineError value) offline,
  }) {
    return notFound(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(RateLimitError value)? rateLimit,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(NotFoundError value)? notFound,
    TResult? Function(ServerError value)? server,
    TResult? Function(ParsingError value)? parsing,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(OfflineError value)? offline,
  }) {
    return notFound?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(RateLimitError value)? rateLimit,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(NotFoundError value)? notFound,
    TResult Function(ServerError value)? server,
    TResult Function(ParsingError value)? parsing,
    TResult Function(UnknownError value)? unknown,
    TResult Function(OfflineError value)? offline,
    required TResult orElse(),
  }) {
    if (notFound != null) {
      return notFound(this);
    }
    return orElse();
  }
}

abstract class NotFoundError implements ApiError {
  const factory NotFoundError(
      {required final String message,
      final String? details}) = _$NotFoundErrorImpl;

  @override
  String get message;
  @override
  String? get details;
  @override
  @JsonKey(ignore: true)
  _$$NotFoundErrorImplCopyWith<_$NotFoundErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ServerErrorImplCopyWith<$Res>
    implements $ApiErrorCopyWith<$Res> {
  factory _$$ServerErrorImplCopyWith(
          _$ServerErrorImpl value, $Res Function(_$ServerErrorImpl) then) =
      __$$ServerErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, int? statusCode, String? details});
}

/// @nodoc
class __$$ServerErrorImplCopyWithImpl<$Res>
    extends _$ApiErrorCopyWithImpl<$Res, _$ServerErrorImpl>
    implements _$$ServerErrorImplCopyWith<$Res> {
  __$$ServerErrorImplCopyWithImpl(
      _$ServerErrorImpl _value, $Res Function(_$ServerErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? statusCode = freezed,
    Object? details = freezed,
  }) {
    return _then(_$ServerErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      statusCode: freezed == statusCode
          ? _value.statusCode
          : statusCode // ignore: cast_nullable_to_non_nullable
              as int?,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ServerErrorImpl implements ServerError {
  const _$ServerErrorImpl(
      {required this.message, required this.statusCode, this.details});

  @override
  final String message;
  @override
  final int? statusCode;
  @override
  final String? details;

  @override
  String toString() {
    return 'ApiError.server(message: $message, statusCode: $statusCode, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ServerErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.statusCode, statusCode) ||
                other.statusCode == statusCode) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, statusCode, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ServerErrorImplCopyWith<_$ServerErrorImpl> get copyWith =>
      __$$ServerErrorImplCopyWithImpl<_$ServerErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode, String? details)
        network,
    required TResult Function(String message, String? details) timeout,
    required TResult Function(String message, int? retryAfter, String? details)
        rateLimit,
    required TResult Function(String message, String? details) unauthorized,
    required TResult Function(String message, String? details) notFound,
    required TResult Function(String message, int? statusCode, String? details)
        server,
    required TResult Function(String message, String? details) parsing,
    required TResult Function(String message, String? details) unknown,
    required TResult Function(String message, String? details) offline,
  }) {
    return server(message, statusCode, details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? details)?
        network,
    TResult? Function(String message, String? details)? timeout,
    TResult? Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult? Function(String message, String? details)? unauthorized,
    TResult? Function(String message, String? details)? notFound,
    TResult? Function(String message, int? statusCode, String? details)? server,
    TResult? Function(String message, String? details)? parsing,
    TResult? Function(String message, String? details)? unknown,
    TResult? Function(String message, String? details)? offline,
  }) {
    return server?.call(message, statusCode, details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? details)? network,
    TResult Function(String message, String? details)? timeout,
    TResult Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult Function(String message, String? details)? unauthorized,
    TResult Function(String message, String? details)? notFound,
    TResult Function(String message, int? statusCode, String? details)? server,
    TResult Function(String message, String? details)? parsing,
    TResult Function(String message, String? details)? unknown,
    TResult Function(String message, String? details)? offline,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(message, statusCode, details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(RateLimitError value) rateLimit,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(NotFoundError value) notFound,
    required TResult Function(ServerError value) server,
    required TResult Function(ParsingError value) parsing,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(OfflineError value) offline,
  }) {
    return server(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(RateLimitError value)? rateLimit,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(NotFoundError value)? notFound,
    TResult? Function(ServerError value)? server,
    TResult? Function(ParsingError value)? parsing,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(OfflineError value)? offline,
  }) {
    return server?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(RateLimitError value)? rateLimit,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(NotFoundError value)? notFound,
    TResult Function(ServerError value)? server,
    TResult Function(ParsingError value)? parsing,
    TResult Function(UnknownError value)? unknown,
    TResult Function(OfflineError value)? offline,
    required TResult orElse(),
  }) {
    if (server != null) {
      return server(this);
    }
    return orElse();
  }
}

abstract class ServerError implements ApiError {
  const factory ServerError(
      {required final String message,
      required final int? statusCode,
      final String? details}) = _$ServerErrorImpl;

  @override
  String get message;
  int? get statusCode;
  @override
  String? get details;
  @override
  @JsonKey(ignore: true)
  _$$ServerErrorImplCopyWith<_$ServerErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$ParsingErrorImplCopyWith<$Res>
    implements $ApiErrorCopyWith<$Res> {
  factory _$$ParsingErrorImplCopyWith(
          _$ParsingErrorImpl value, $Res Function(_$ParsingErrorImpl) then) =
      __$$ParsingErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? details});
}

/// @nodoc
class __$$ParsingErrorImplCopyWithImpl<$Res>
    extends _$ApiErrorCopyWithImpl<$Res, _$ParsingErrorImpl>
    implements _$$ParsingErrorImplCopyWith<$Res> {
  __$$ParsingErrorImplCopyWithImpl(
      _$ParsingErrorImpl _value, $Res Function(_$ParsingErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? details = freezed,
  }) {
    return _then(_$ParsingErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$ParsingErrorImpl implements ParsingError {
  const _$ParsingErrorImpl({required this.message, this.details});

  @override
  final String message;
  @override
  final String? details;

  @override
  String toString() {
    return 'ApiError.parsing(message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ParsingErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ParsingErrorImplCopyWith<_$ParsingErrorImpl> get copyWith =>
      __$$ParsingErrorImplCopyWithImpl<_$ParsingErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode, String? details)
        network,
    required TResult Function(String message, String? details) timeout,
    required TResult Function(String message, int? retryAfter, String? details)
        rateLimit,
    required TResult Function(String message, String? details) unauthorized,
    required TResult Function(String message, String? details) notFound,
    required TResult Function(String message, int? statusCode, String? details)
        server,
    required TResult Function(String message, String? details) parsing,
    required TResult Function(String message, String? details) unknown,
    required TResult Function(String message, String? details) offline,
  }) {
    return parsing(message, details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? details)?
        network,
    TResult? Function(String message, String? details)? timeout,
    TResult? Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult? Function(String message, String? details)? unauthorized,
    TResult? Function(String message, String? details)? notFound,
    TResult? Function(String message, int? statusCode, String? details)? server,
    TResult? Function(String message, String? details)? parsing,
    TResult? Function(String message, String? details)? unknown,
    TResult? Function(String message, String? details)? offline,
  }) {
    return parsing?.call(message, details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? details)? network,
    TResult Function(String message, String? details)? timeout,
    TResult Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult Function(String message, String? details)? unauthorized,
    TResult Function(String message, String? details)? notFound,
    TResult Function(String message, int? statusCode, String? details)? server,
    TResult Function(String message, String? details)? parsing,
    TResult Function(String message, String? details)? unknown,
    TResult Function(String message, String? details)? offline,
    required TResult orElse(),
  }) {
    if (parsing != null) {
      return parsing(message, details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(RateLimitError value) rateLimit,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(NotFoundError value) notFound,
    required TResult Function(ServerError value) server,
    required TResult Function(ParsingError value) parsing,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(OfflineError value) offline,
  }) {
    return parsing(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(RateLimitError value)? rateLimit,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(NotFoundError value)? notFound,
    TResult? Function(ServerError value)? server,
    TResult? Function(ParsingError value)? parsing,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(OfflineError value)? offline,
  }) {
    return parsing?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(RateLimitError value)? rateLimit,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(NotFoundError value)? notFound,
    TResult Function(ServerError value)? server,
    TResult Function(ParsingError value)? parsing,
    TResult Function(UnknownError value)? unknown,
    TResult Function(OfflineError value)? offline,
    required TResult orElse(),
  }) {
    if (parsing != null) {
      return parsing(this);
    }
    return orElse();
  }
}

abstract class ParsingError implements ApiError {
  const factory ParsingError(
      {required final String message,
      final String? details}) = _$ParsingErrorImpl;

  @override
  String get message;
  @override
  String? get details;
  @override
  @JsonKey(ignore: true)
  _$$ParsingErrorImplCopyWith<_$ParsingErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$UnknownErrorImplCopyWith<$Res>
    implements $ApiErrorCopyWith<$Res> {
  factory _$$UnknownErrorImplCopyWith(
          _$UnknownErrorImpl value, $Res Function(_$UnknownErrorImpl) then) =
      __$$UnknownErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? details});
}

/// @nodoc
class __$$UnknownErrorImplCopyWithImpl<$Res>
    extends _$ApiErrorCopyWithImpl<$Res, _$UnknownErrorImpl>
    implements _$$UnknownErrorImplCopyWith<$Res> {
  __$$UnknownErrorImplCopyWithImpl(
      _$UnknownErrorImpl _value, $Res Function(_$UnknownErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? details = freezed,
  }) {
    return _then(_$UnknownErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$UnknownErrorImpl implements UnknownError {
  const _$UnknownErrorImpl({required this.message, this.details});

  @override
  final String message;
  @override
  final String? details;

  @override
  String toString() {
    return 'ApiError.unknown(message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UnknownErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      __$$UnknownErrorImplCopyWithImpl<_$UnknownErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode, String? details)
        network,
    required TResult Function(String message, String? details) timeout,
    required TResult Function(String message, int? retryAfter, String? details)
        rateLimit,
    required TResult Function(String message, String? details) unauthorized,
    required TResult Function(String message, String? details) notFound,
    required TResult Function(String message, int? statusCode, String? details)
        server,
    required TResult Function(String message, String? details) parsing,
    required TResult Function(String message, String? details) unknown,
    required TResult Function(String message, String? details) offline,
  }) {
    return unknown(message, details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? details)?
        network,
    TResult? Function(String message, String? details)? timeout,
    TResult? Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult? Function(String message, String? details)? unauthorized,
    TResult? Function(String message, String? details)? notFound,
    TResult? Function(String message, int? statusCode, String? details)? server,
    TResult? Function(String message, String? details)? parsing,
    TResult? Function(String message, String? details)? unknown,
    TResult? Function(String message, String? details)? offline,
  }) {
    return unknown?.call(message, details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? details)? network,
    TResult Function(String message, String? details)? timeout,
    TResult Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult Function(String message, String? details)? unauthorized,
    TResult Function(String message, String? details)? notFound,
    TResult Function(String message, int? statusCode, String? details)? server,
    TResult Function(String message, String? details)? parsing,
    TResult Function(String message, String? details)? unknown,
    TResult Function(String message, String? details)? offline,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(message, details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(RateLimitError value) rateLimit,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(NotFoundError value) notFound,
    required TResult Function(ServerError value) server,
    required TResult Function(ParsingError value) parsing,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(OfflineError value) offline,
  }) {
    return unknown(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(RateLimitError value)? rateLimit,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(NotFoundError value)? notFound,
    TResult? Function(ServerError value)? server,
    TResult? Function(ParsingError value)? parsing,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(OfflineError value)? offline,
  }) {
    return unknown?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(RateLimitError value)? rateLimit,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(NotFoundError value)? notFound,
    TResult Function(ServerError value)? server,
    TResult Function(ParsingError value)? parsing,
    TResult Function(UnknownError value)? unknown,
    TResult Function(OfflineError value)? offline,
    required TResult orElse(),
  }) {
    if (unknown != null) {
      return unknown(this);
    }
    return orElse();
  }
}

abstract class UnknownError implements ApiError {
  const factory UnknownError(
      {required final String message,
      final String? details}) = _$UnknownErrorImpl;

  @override
  String get message;
  @override
  String? get details;
  @override
  @JsonKey(ignore: true)
  _$$UnknownErrorImplCopyWith<_$UnknownErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$OfflineErrorImplCopyWith<$Res>
    implements $ApiErrorCopyWith<$Res> {
  factory _$$OfflineErrorImplCopyWith(
          _$OfflineErrorImpl value, $Res Function(_$OfflineErrorImpl) then) =
      __$$OfflineErrorImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String message, String? details});
}

/// @nodoc
class __$$OfflineErrorImplCopyWithImpl<$Res>
    extends _$ApiErrorCopyWithImpl<$Res, _$OfflineErrorImpl>
    implements _$$OfflineErrorImplCopyWith<$Res> {
  __$$OfflineErrorImplCopyWithImpl(
      _$OfflineErrorImpl _value, $Res Function(_$OfflineErrorImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? message = null,
    Object? details = freezed,
  }) {
    return _then(_$OfflineErrorImpl(
      message: null == message
          ? _value.message
          : message // ignore: cast_nullable_to_non_nullable
              as String,
      details: freezed == details
          ? _value.details
          : details // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc

class _$OfflineErrorImpl implements OfflineError {
  const _$OfflineErrorImpl({required this.message, this.details});

  @override
  final String message;
  @override
  final String? details;

  @override
  String toString() {
    return 'ApiError.offline(message: $message, details: $details)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OfflineErrorImpl &&
            (identical(other.message, message) || other.message == message) &&
            (identical(other.details, details) || other.details == details));
  }

  @override
  int get hashCode => Object.hash(runtimeType, message, details);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$OfflineErrorImplCopyWith<_$OfflineErrorImpl> get copyWith =>
      __$$OfflineErrorImplCopyWithImpl<_$OfflineErrorImpl>(this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function(String message, int? statusCode, String? details)
        network,
    required TResult Function(String message, String? details) timeout,
    required TResult Function(String message, int? retryAfter, String? details)
        rateLimit,
    required TResult Function(String message, String? details) unauthorized,
    required TResult Function(String message, String? details) notFound,
    required TResult Function(String message, int? statusCode, String? details)
        server,
    required TResult Function(String message, String? details) parsing,
    required TResult Function(String message, String? details) unknown,
    required TResult Function(String message, String? details) offline,
  }) {
    return offline(message, details);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function(String message, int? statusCode, String? details)?
        network,
    TResult? Function(String message, String? details)? timeout,
    TResult? Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult? Function(String message, String? details)? unauthorized,
    TResult? Function(String message, String? details)? notFound,
    TResult? Function(String message, int? statusCode, String? details)? server,
    TResult? Function(String message, String? details)? parsing,
    TResult? Function(String message, String? details)? unknown,
    TResult? Function(String message, String? details)? offline,
  }) {
    return offline?.call(message, details);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function(String message, int? statusCode, String? details)? network,
    TResult Function(String message, String? details)? timeout,
    TResult Function(String message, int? retryAfter, String? details)?
        rateLimit,
    TResult Function(String message, String? details)? unauthorized,
    TResult Function(String message, String? details)? notFound,
    TResult Function(String message, int? statusCode, String? details)? server,
    TResult Function(String message, String? details)? parsing,
    TResult Function(String message, String? details)? unknown,
    TResult Function(String message, String? details)? offline,
    required TResult orElse(),
  }) {
    if (offline != null) {
      return offline(message, details);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(NetworkError value) network,
    required TResult Function(TimeoutError value) timeout,
    required TResult Function(RateLimitError value) rateLimit,
    required TResult Function(UnauthorizedError value) unauthorized,
    required TResult Function(NotFoundError value) notFound,
    required TResult Function(ServerError value) server,
    required TResult Function(ParsingError value) parsing,
    required TResult Function(UnknownError value) unknown,
    required TResult Function(OfflineError value) offline,
  }) {
    return offline(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(NetworkError value)? network,
    TResult? Function(TimeoutError value)? timeout,
    TResult? Function(RateLimitError value)? rateLimit,
    TResult? Function(UnauthorizedError value)? unauthorized,
    TResult? Function(NotFoundError value)? notFound,
    TResult? Function(ServerError value)? server,
    TResult? Function(ParsingError value)? parsing,
    TResult? Function(UnknownError value)? unknown,
    TResult? Function(OfflineError value)? offline,
  }) {
    return offline?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(NetworkError value)? network,
    TResult Function(TimeoutError value)? timeout,
    TResult Function(RateLimitError value)? rateLimit,
    TResult Function(UnauthorizedError value)? unauthorized,
    TResult Function(NotFoundError value)? notFound,
    TResult Function(ServerError value)? server,
    TResult Function(ParsingError value)? parsing,
    TResult Function(UnknownError value)? unknown,
    TResult Function(OfflineError value)? offline,
    required TResult orElse(),
  }) {
    if (offline != null) {
      return offline(this);
    }
    return orElse();
  }
}

abstract class OfflineError implements ApiError {
  const factory OfflineError(
      {required final String message,
      final String? details}) = _$OfflineErrorImpl;

  @override
  String get message;
  @override
  String? get details;
  @override
  @JsonKey(ignore: true)
  _$$OfflineErrorImplCopyWith<_$OfflineErrorImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
