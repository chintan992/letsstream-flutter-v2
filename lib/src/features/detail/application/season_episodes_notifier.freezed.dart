// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'season_episodes_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$SeasonEpisodesState {
  List<EpisodeSummary> get episodes => throw _privateConstructorUsedError;
  bool get isLoading => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $SeasonEpisodesStateCopyWith<SeasonEpisodesState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SeasonEpisodesStateCopyWith<$Res> {
  factory $SeasonEpisodesStateCopyWith(
          SeasonEpisodesState value, $Res Function(SeasonEpisodesState) then) =
      _$SeasonEpisodesStateCopyWithImpl<$Res, SeasonEpisodesState>;
  @useResult
  $Res call({List<EpisodeSummary> episodes, bool isLoading, Object? error});
}

/// @nodoc
class _$SeasonEpisodesStateCopyWithImpl<$Res, $Val extends SeasonEpisodesState>
    implements $SeasonEpisodesStateCopyWith<$Res> {
  _$SeasonEpisodesStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? episodes = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      episodes: null == episodes
          ? _value.episodes
          : episodes // ignore: cast_nullable_to_non_nullable
              as List<EpisodeSummary>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SeasonEpisodesStateImplCopyWith<$Res>
    implements $SeasonEpisodesStateCopyWith<$Res> {
  factory _$$SeasonEpisodesStateImplCopyWith(_$SeasonEpisodesStateImpl value,
          $Res Function(_$SeasonEpisodesStateImpl) then) =
      __$$SeasonEpisodesStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({List<EpisodeSummary> episodes, bool isLoading, Object? error});
}

/// @nodoc
class __$$SeasonEpisodesStateImplCopyWithImpl<$Res>
    extends _$SeasonEpisodesStateCopyWithImpl<$Res, _$SeasonEpisodesStateImpl>
    implements _$$SeasonEpisodesStateImplCopyWith<$Res> {
  __$$SeasonEpisodesStateImplCopyWithImpl(_$SeasonEpisodesStateImpl _value,
      $Res Function(_$SeasonEpisodesStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? episodes = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$SeasonEpisodesStateImpl(
      episodes: null == episodes
          ? _value._episodes
          : episodes // ignore: cast_nullable_to_non_nullable
              as List<EpisodeSummary>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$SeasonEpisodesStateImpl implements _SeasonEpisodesState {
  const _$SeasonEpisodesStateImpl(
      {final List<EpisodeSummary> episodes = const [],
      this.isLoading = false,
      this.error})
      : _episodes = episodes;

  final List<EpisodeSummary> _episodes;
  @override
  @JsonKey()
  List<EpisodeSummary> get episodes {
    if (_episodes is EqualUnmodifiableListView) return _episodes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_episodes);
  }

  @override
  @JsonKey()
  final bool isLoading;
  @override
  final Object? error;

  @override
  String toString() {
    return 'SeasonEpisodesState(episodes: $episodes, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SeasonEpisodesStateImpl &&
            const DeepCollectionEquality().equals(other._episodes, _episodes) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_episodes),
      isLoading,
      const DeepCollectionEquality().hash(error));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$SeasonEpisodesStateImplCopyWith<_$SeasonEpisodesStateImpl> get copyWith =>
      __$$SeasonEpisodesStateImplCopyWithImpl<_$SeasonEpisodesStateImpl>(
          this, _$identity);
}

abstract class _SeasonEpisodesState implements SeasonEpisodesState {
  const factory _SeasonEpisodesState(
      {final List<EpisodeSummary> episodes,
      final bool isLoading,
      final Object? error}) = _$SeasonEpisodesStateImpl;

  @override
  List<EpisodeSummary> get episodes;
  @override
  bool get isLoading;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$SeasonEpisodesStateImplCopyWith<_$SeasonEpisodesStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
