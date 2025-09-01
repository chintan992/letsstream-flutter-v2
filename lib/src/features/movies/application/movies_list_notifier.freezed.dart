// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'movies_list_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$MoviesListState {
  List<Movie> get movies => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isInitialLoad => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $MoviesListStateCopyWith<MoviesListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MoviesListStateCopyWith<$Res> {
  factory $MoviesListStateCopyWith(
          MoviesListState value, $Res Function(MoviesListState) then) =
      _$MoviesListStateCopyWithImpl<$Res, MoviesListState>;
  @useResult
  $Res call(
      {List<Movie> movies,
      bool hasMore,
      bool isLoading,
      bool isInitialLoad,
      Object? error});
}

/// @nodoc
class _$MoviesListStateCopyWithImpl<$Res, $Val extends MoviesListState>
    implements $MoviesListStateCopyWith<$Res> {
  _$MoviesListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? movies = null,
    Object? hasMore = null,
    Object? isLoading = null,
    Object? isInitialLoad = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      movies: null == movies
          ? _value.movies
          : movies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isInitialLoad: null == isInitialLoad
          ? _value.isInitialLoad
          : isInitialLoad // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MoviesListStateImplCopyWith<$Res>
    implements $MoviesListStateCopyWith<$Res> {
  factory _$$MoviesListStateImplCopyWith(_$MoviesListStateImpl value,
          $Res Function(_$MoviesListStateImpl) then) =
      __$$MoviesListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Movie> movies,
      bool hasMore,
      bool isLoading,
      bool isInitialLoad,
      Object? error});
}

/// @nodoc
class __$$MoviesListStateImplCopyWithImpl<$Res>
    extends _$MoviesListStateCopyWithImpl<$Res, _$MoviesListStateImpl>
    implements _$$MoviesListStateImplCopyWith<$Res> {
  __$$MoviesListStateImplCopyWithImpl(
      _$MoviesListStateImpl _value, $Res Function(_$MoviesListStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? movies = null,
    Object? hasMore = null,
    Object? isLoading = null,
    Object? isInitialLoad = null,
    Object? error = freezed,
  }) {
    return _then(_$MoviesListStateImpl(
      movies: null == movies
          ? _value._movies
          : movies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      hasMore: null == hasMore
          ? _value.hasMore
          : hasMore // ignore: cast_nullable_to_non_nullable
              as bool,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      isInitialLoad: null == isInitialLoad
          ? _value.isInitialLoad
          : isInitialLoad // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$MoviesListStateImpl implements _MoviesListState {
  const _$MoviesListStateImpl(
      {final List<Movie> movies = const [],
      this.hasMore = true,
      this.isLoading = false,
      this.isInitialLoad = false,
      this.error})
      : _movies = movies;

  final List<Movie> _movies;
  @override
  @JsonKey()
  List<Movie> get movies {
    if (_movies is EqualUnmodifiableListView) return _movies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_movies);
  }

  @override
  @JsonKey()
  final bool hasMore;
  @override
  @JsonKey()
  final bool isLoading;
  @override
  @JsonKey()
  final bool isInitialLoad;
  @override
  final Object? error;

  @override
  String toString() {
    return 'MoviesListState(movies: $movies, hasMore: $hasMore, isLoading: $isLoading, isInitialLoad: $isInitialLoad, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MoviesListStateImpl &&
            const DeepCollectionEquality().equals(other._movies, _movies) &&
            (identical(other.hasMore, hasMore) || other.hasMore == hasMore) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            (identical(other.isInitialLoad, isInitialLoad) ||
                other.isInitialLoad == isInitialLoad) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_movies),
      hasMore,
      isLoading,
      isInitialLoad,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$MoviesListStateImplCopyWith<_$MoviesListStateImpl> get copyWith =>
      __$$MoviesListStateImplCopyWithImpl<_$MoviesListStateImpl>(
          this, _$identity);
}

abstract class _MoviesListState implements MoviesListState {
  const factory _MoviesListState(
      {final List<Movie> movies,
      final bool hasMore,
      final bool isLoading,
      final bool isInitialLoad,
      final Object? error}) = _$MoviesListStateImpl;

  @override
  List<Movie> get movies;
  @override
  bool get hasMore;
  @override
  bool get isLoading;
  @override
  bool get isInitialLoad;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$MoviesListStateImplCopyWith<_$MoviesListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
