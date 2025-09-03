// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'tv_list_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$TvListState {
  List<TvShow> get tvShows => throw _privateConstructorUsedError;
  bool get hasMore => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  bool get isInitialLoad => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $TvListStateCopyWith<TvListState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TvListStateCopyWith<$Res> {
  factory $TvListStateCopyWith(
          TvListState value, $Res Function(TvListState) then) =
      _$TvListStateCopyWithImpl<$Res, TvListState>;
  @useResult
  $Res call(
      {List<TvShow> tvShows,
      bool hasMore,
      bool isLoading,
      bool isInitialLoad,
      Object? error});
}

/// @nodoc
class _$TvListStateCopyWithImpl<$Res, $Val extends TvListState>
    implements $TvListStateCopyWith<$Res> {
  _$TvListStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tvShows = null,
    Object? hasMore = null,
    Object? isLoading = null,
    Object? isInitialLoad = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      tvShows: null == tvShows
          ? _value.tvShows
          : tvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
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
abstract class _$$TvListStateImplCopyWith<$Res>
    implements $TvListStateCopyWith<$Res> {
  factory _$$TvListStateImplCopyWith(
          _$TvListStateImpl value, $Res Function(_$TvListStateImpl) then) =
      __$$TvListStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<TvShow> tvShows,
      bool hasMore,
      bool isLoading,
      bool isInitialLoad,
      Object? error});
}

/// @nodoc
class __$$TvListStateImplCopyWithImpl<$Res>
    extends _$TvListStateCopyWithImpl<$Res, _$TvListStateImpl>
    implements _$$TvListStateImplCopyWith<$Res> {
  __$$TvListStateImplCopyWithImpl(
      _$TvListStateImpl _value, $Res Function(_$TvListStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? tvShows = null,
    Object? hasMore = null,
    Object? isLoading = null,
    Object? isInitialLoad = null,
    Object? error = freezed,
  }) {
    return _then(_$TvListStateImpl(
      tvShows: null == tvShows
          ? _value._tvShows
          : tvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
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

class _$TvListStateImpl implements _TvListState {
  const _$TvListStateImpl(
      {final List<TvShow> tvShows = const [],
      this.hasMore = true,
      this.isLoading = false,
      this.isInitialLoad = false,
      this.error})
      : _tvShows = tvShows;

  final List<TvShow> _tvShows;
  @override
  @JsonKey()
  List<TvShow> get tvShows {
    if (_tvShows is EqualUnmodifiableListView) return _tvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tvShows);
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
    return 'TvListState(tvShows: $tvShows, hasMore: $hasMore, isLoading: $isLoading, isInitialLoad: $isInitialLoad, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TvListStateImpl &&
            const DeepCollectionEquality().equals(other._tvShows, _tvShows) &&
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
      const DeepCollectionEquality().hash(_tvShows),
      hasMore,
      isLoading,
      isInitialLoad,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$TvListStateImplCopyWith<_$TvListStateImpl> get copyWith =>
      __$$TvListStateImplCopyWithImpl<_$TvListStateImpl>(this, _$identity);
}

abstract class _TvListState implements TvListState {
  const factory _TvListState(
      {final List<TvShow> tvShows,
      final bool hasMore,
      final bool isLoading,
      final bool isInitialLoad,
      final Object? error}) = _$TvListStateImpl;

  @override
  List<TvShow> get tvShows;
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
  _$$TvListStateImplCopyWith<_$TvListStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
