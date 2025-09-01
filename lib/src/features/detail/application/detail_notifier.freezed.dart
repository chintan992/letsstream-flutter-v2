// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'detail_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$DetailState {
  Object? get item => throw _privateConstructorUsedError;
  List<Video> get videos => throw _privateConstructorUsedError;
  List<CastMember> get cast => throw _privateConstructorUsedError;
  List<dynamic> get similar => throw _privateConstructorUsedError;
  List<SeasonSummary> get seasons => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $DetailStateCopyWith<DetailState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DetailStateCopyWith<$Res> {
  factory $DetailStateCopyWith(
          DetailState value, $Res Function(DetailState) then) =
      _$DetailStateCopyWithImpl<$Res, DetailState>;
  @useResult
  $Res call(
      {Object? item,
      List<Video> videos,
      List<CastMember> cast,
      List<dynamic> similar,
      List<SeasonSummary> seasons,
      bool isLoading,
      Object? error});
}

/// @nodoc
class _$DetailStateCopyWithImpl<$Res, $Val extends DetailState>
    implements $DetailStateCopyWith<$Res> {
  _$DetailStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = freezed,
    Object? videos = null,
    Object? cast = null,
    Object? similar = null,
    Object? seasons = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      item: freezed == item ? _value.item : item,
      videos: null == videos
          ? _value.videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<Video>,
      cast: null == cast
          ? _value.cast
          : cast // ignore: cast_nullable_to_non_nullable
              as List<CastMember>,
      similar: null == similar
          ? _value.similar
          : similar // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      seasons: null == seasons
          ? _value.seasons
          : seasons // ignore: cast_nullable_to_non_nullable
              as List<SeasonSummary>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$DetailStateImplCopyWith<$Res>
    implements $DetailStateCopyWith<$Res> {
  factory _$$DetailStateImplCopyWith(
          _$DetailStateImpl value, $Res Function(_$DetailStateImpl) then) =
      __$$DetailStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {Object? item,
      List<Video> videos,
      List<CastMember> cast,
      List<dynamic> similar,
      List<SeasonSummary> seasons,
      bool isLoading,
      Object? error});
}

/// @nodoc
class __$$DetailStateImplCopyWithImpl<$Res>
    extends _$DetailStateCopyWithImpl<$Res, _$DetailStateImpl>
    implements _$$DetailStateImplCopyWith<$Res> {
  __$$DetailStateImplCopyWithImpl(
      _$DetailStateImpl _value, $Res Function(_$DetailStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? item = freezed,
    Object? videos = null,
    Object? cast = null,
    Object? similar = null,
    Object? seasons = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$DetailStateImpl(
      item: freezed == item ? _value.item : item,
      videos: null == videos
          ? _value._videos
          : videos // ignore: cast_nullable_to_non_nullable
              as List<Video>,
      cast: null == cast
          ? _value._cast
          : cast // ignore: cast_nullable_to_non_nullable
              as List<CastMember>,
      similar: null == similar
          ? _value._similar
          : similar // ignore: cast_nullable_to_non_nullable
              as List<dynamic>,
      seasons: null == seasons
          ? _value._seasons
          : seasons // ignore: cast_nullable_to_non_nullable
              as List<SeasonSummary>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$DetailStateImpl implements _DetailState {
  const _$DetailStateImpl(
      {this.item,
      final List<Video> videos = const [],
      final List<CastMember> cast = const [],
      final List<dynamic> similar = const [],
      final List<SeasonSummary> seasons = const [],
      this.isLoading = false,
      this.error})
      : _videos = videos,
        _cast = cast,
        _similar = similar,
        _seasons = seasons;

  @override
  final Object? item;
  final List<Video> _videos;
  @override
  @JsonKey()
  List<Video> get videos {
    if (_videos is EqualUnmodifiableListView) return _videos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_videos);
  }

  final List<CastMember> _cast;
  @override
  @JsonKey()
  List<CastMember> get cast {
    if (_cast is EqualUnmodifiableListView) return _cast;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_cast);
  }

  final List<dynamic> _similar;
  @override
  @JsonKey()
  List<dynamic> get similar {
    if (_similar is EqualUnmodifiableListView) return _similar;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_similar);
  }

  final List<SeasonSummary> _seasons;
  @override
  @JsonKey()
  List<SeasonSummary> get seasons {
    if (_seasons is EqualUnmodifiableListView) return _seasons;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_seasons);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final Object? error;

  @override
  String toString() {
    return 'DetailState(item: $item, videos: $videos, cast: $cast, similar: $similar, seasons: $seasons, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DetailStateImpl &&
            const DeepCollectionEquality().equals(other.item, item) &&
            const DeepCollectionEquality().equals(other._videos, _videos) &&
            const DeepCollectionEquality().equals(other._cast, _cast) &&
            const DeepCollectionEquality().equals(other._similar, _similar) &&
            const DeepCollectionEquality().equals(other._seasons, _seasons) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(item),
      const DeepCollectionEquality().hash(_videos),
      const DeepCollectionEquality().hash(_cast),
      const DeepCollectionEquality().hash(_similar),
      const DeepCollectionEquality().hash(_seasons),
      isLoading,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$DetailStateImplCopyWith<_$DetailStateImpl> get copyWith =>
      __$$DetailStateImplCopyWithImpl<_$DetailStateImpl>(this, _$identity);
}

abstract class _DetailState implements DetailState {
  const factory _DetailState(
      {final Object? item,
      final List<Video> videos,
      final List<CastMember> cast,
      final List<dynamic> similar,
      final List<SeasonSummary> seasons,
      final bool isLoading,
      final Object? error}) = _$DetailStateImpl;

  @override
  Object? get item;
  @override
  List<Video> get videos;
  @override
  List<CastMember> get cast;
  @override
  List<dynamic> get similar;
  @override
  List<SeasonSummary> get seasons;
  @override
  bool get isLoading;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$DetailStateImplCopyWith<_$DetailStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
