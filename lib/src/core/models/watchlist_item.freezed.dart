// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'watchlist_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

WatchlistItem _$WatchlistItemFromJson(Map<String, dynamic> json) {
  return _WatchlistItem.fromJson(json);
}

/// @nodoc
mixin _$WatchlistItem {
  /// Unique identifier for the item
  String get id => throw _privateConstructorUsedError;

  /// Content ID (movie or TV show ID)
  int get contentId => throw _privateConstructorUsedError;

  /// Content type (movie or tv)
  String get contentType => throw _privateConstructorUsedError;

  /// Title of the content
  String get title => throw _privateConstructorUsedError;

  /// Poster path for the content
  String? get posterPath => throw _privateConstructorUsedError;

  /// Overview/description
  String? get overview => throw _privateConstructorUsedError;

  /// Release date
  DateTime? get releaseDate => throw _privateConstructorUsedError;

  /// Vote average/rating
  double? get voteAverage => throw _privateConstructorUsedError;

  /// Categories this item belongs to
  List<String> get categories => throw _privateConstructorUsedError;

  /// User rating (1-10, null if not rated)
  double? get userRating => throw _privateConstructorUsedError;

  /// User notes
  String? get notes => throw _privateConstructorUsedError;

  /// Priority level (1-5, higher = more priority)
  int get priority => throw _privateConstructorUsedError;

  /// When the item was added to watchlist
  DateTime get addedAt => throw _privateConstructorUsedError;

  /// When the item was last updated
  DateTime? get updatedAt => throw _privateConstructorUsedError;

  /// Whether the item has been watched
  bool get isWatched => throw _privateConstructorUsedError;

  /// When the item was marked as watched
  DateTime? get watchedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $WatchlistItemCopyWith<WatchlistItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WatchlistItemCopyWith<$Res> {
  factory $WatchlistItemCopyWith(
          WatchlistItem value, $Res Function(WatchlistItem) then) =
      _$WatchlistItemCopyWithImpl<$Res, WatchlistItem>;
  @useResult
  $Res call(
      {String id,
      int contentId,
      String contentType,
      String title,
      String? posterPath,
      String? overview,
      DateTime? releaseDate,
      double? voteAverage,
      List<String> categories,
      double? userRating,
      String? notes,
      int priority,
      DateTime addedAt,
      DateTime? updatedAt,
      bool isWatched,
      DateTime? watchedAt});
}

/// @nodoc
class _$WatchlistItemCopyWithImpl<$Res, $Val extends WatchlistItem>
    implements $WatchlistItemCopyWith<$Res> {
  _$WatchlistItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contentId = null,
    Object? contentType = null,
    Object? title = null,
    Object? posterPath = freezed,
    Object? overview = freezed,
    Object? releaseDate = freezed,
    Object? voteAverage = freezed,
    Object? categories = null,
    Object? userRating = freezed,
    Object? notes = freezed,
    Object? priority = null,
    Object? addedAt = null,
    Object? updatedAt = freezed,
    Object? isWatched = null,
    Object? watchedAt = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      contentId: null == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as int,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      posterPath: freezed == posterPath
          ? _value.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String?,
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      voteAverage: freezed == voteAverage
          ? _value.voteAverage
          : voteAverage // ignore: cast_nullable_to_non_nullable
              as double?,
      categories: null == categories
          ? _value.categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userRating: freezed == userRating
          ? _value.userRating
          : userRating // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isWatched: null == isWatched
          ? _value.isWatched
          : isWatched // ignore: cast_nullable_to_non_nullable
              as bool,
      watchedAt: freezed == watchedAt
          ? _value.watchedAt
          : watchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$WatchlistItemImplCopyWith<$Res>
    implements $WatchlistItemCopyWith<$Res> {
  factory _$$WatchlistItemImplCopyWith(
          _$WatchlistItemImpl value, $Res Function(_$WatchlistItemImpl) then) =
      __$$WatchlistItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      int contentId,
      String contentType,
      String title,
      String? posterPath,
      String? overview,
      DateTime? releaseDate,
      double? voteAverage,
      List<String> categories,
      double? userRating,
      String? notes,
      int priority,
      DateTime addedAt,
      DateTime? updatedAt,
      bool isWatched,
      DateTime? watchedAt});
}

/// @nodoc
class __$$WatchlistItemImplCopyWithImpl<$Res>
    extends _$WatchlistItemCopyWithImpl<$Res, _$WatchlistItemImpl>
    implements _$$WatchlistItemImplCopyWith<$Res> {
  __$$WatchlistItemImplCopyWithImpl(
      _$WatchlistItemImpl _value, $Res Function(_$WatchlistItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? contentId = null,
    Object? contentType = null,
    Object? title = null,
    Object? posterPath = freezed,
    Object? overview = freezed,
    Object? releaseDate = freezed,
    Object? voteAverage = freezed,
    Object? categories = null,
    Object? userRating = freezed,
    Object? notes = freezed,
    Object? priority = null,
    Object? addedAt = null,
    Object? updatedAt = freezed,
    Object? isWatched = null,
    Object? watchedAt = freezed,
  }) {
    return _then(_$WatchlistItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      contentId: null == contentId
          ? _value.contentId
          : contentId // ignore: cast_nullable_to_non_nullable
              as int,
      contentType: null == contentType
          ? _value.contentType
          : contentType // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      posterPath: freezed == posterPath
          ? _value.posterPath
          : posterPath // ignore: cast_nullable_to_non_nullable
              as String?,
      overview: freezed == overview
          ? _value.overview
          : overview // ignore: cast_nullable_to_non_nullable
              as String?,
      releaseDate: freezed == releaseDate
          ? _value.releaseDate
          : releaseDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      voteAverage: freezed == voteAverage
          ? _value.voteAverage
          : voteAverage // ignore: cast_nullable_to_non_nullable
              as double?,
      categories: null == categories
          ? _value._categories
          : categories // ignore: cast_nullable_to_non_nullable
              as List<String>,
      userRating: freezed == userRating
          ? _value.userRating
          : userRating // ignore: cast_nullable_to_non_nullable
              as double?,
      notes: freezed == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String?,
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      isWatched: null == isWatched
          ? _value.isWatched
          : isWatched // ignore: cast_nullable_to_non_nullable
              as bool,
      watchedAt: freezed == watchedAt
          ? _value.watchedAt
          : watchedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$WatchlistItemImpl implements _WatchlistItem {
  const _$WatchlistItemImpl(
      {required this.id,
      required this.contentId,
      required this.contentType,
      required this.title,
      this.posterPath,
      this.overview,
      this.releaseDate,
      this.voteAverage,
      final List<String> categories = const [],
      this.userRating,
      this.notes,
      this.priority = 3,
      required this.addedAt,
      this.updatedAt,
      this.isWatched = false,
      this.watchedAt})
      : _categories = categories;

  factory _$WatchlistItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$WatchlistItemImplFromJson(json);

  /// Unique identifier for the item
  @override
  final String id;

  /// Content ID (movie or TV show ID)
  @override
  final int contentId;

  /// Content type (movie or tv)
  @override
  final String contentType;

  /// Title of the content
  @override
  final String title;

  /// Poster path for the content
  @override
  final String? posterPath;

  /// Overview/description
  @override
  final String? overview;

  /// Release date
  @override
  final DateTime? releaseDate;

  /// Vote average/rating
  @override
  final double? voteAverage;

  /// Categories this item belongs to
  final List<String> _categories;

  /// Categories this item belongs to
  @override
  @JsonKey()
  List<String> get categories {
    if (_categories is EqualUnmodifiableListView) return _categories;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_categories);
  }

  /// User rating (1-10, null if not rated)
  @override
  final double? userRating;

  /// User notes
  @override
  final String? notes;

  /// Priority level (1-5, higher = more priority)
  @override
  @JsonKey()
  final int priority;

  /// When the item was added to watchlist
  @override
  final DateTime addedAt;

  /// When the item was last updated
  @override
  final DateTime? updatedAt;

  /// Whether the item has been watched
  @override
  @JsonKey()
  final bool isWatched;

  /// When the item was marked as watched
  @override
  final DateTime? watchedAt;

  @override
  String toString() {
    return 'WatchlistItem(id: $id, contentId: $contentId, contentType: $contentType, title: $title, posterPath: $posterPath, overview: $overview, releaseDate: $releaseDate, voteAverage: $voteAverage, categories: $categories, userRating: $userRating, notes: $notes, priority: $priority, addedAt: $addedAt, updatedAt: $updatedAt, isWatched: $isWatched, watchedAt: $watchedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WatchlistItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.contentId, contentId) ||
                other.contentId == contentId) &&
            (identical(other.contentType, contentType) ||
                other.contentType == contentType) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.posterPath, posterPath) ||
                other.posterPath == posterPath) &&
            (identical(other.overview, overview) ||
                other.overview == overview) &&
            (identical(other.releaseDate, releaseDate) ||
                other.releaseDate == releaseDate) &&
            (identical(other.voteAverage, voteAverage) ||
                other.voteAverage == voteAverage) &&
            const DeepCollectionEquality()
                .equals(other._categories, _categories) &&
            (identical(other.userRating, userRating) ||
                other.userRating == userRating) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isWatched, isWatched) ||
                other.isWatched == isWatched) &&
            (identical(other.watchedAt, watchedAt) ||
                other.watchedAt == watchedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      contentId,
      contentType,
      title,
      posterPath,
      overview,
      releaseDate,
      voteAverage,
      const DeepCollectionEquality().hash(_categories),
      userRating,
      notes,
      priority,
      addedAt,
      updatedAt,
      isWatched,
      watchedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$WatchlistItemImplCopyWith<_$WatchlistItemImpl> get copyWith =>
      __$$WatchlistItemImplCopyWithImpl<_$WatchlistItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WatchlistItemImplToJson(
      this,
    );
  }
}

abstract class _WatchlistItem implements WatchlistItem {
  const factory _WatchlistItem(
      {required final String id,
      required final int contentId,
      required final String contentType,
      required final String title,
      final String? posterPath,
      final String? overview,
      final DateTime? releaseDate,
      final double? voteAverage,
      final List<String> categories,
      final double? userRating,
      final String? notes,
      final int priority,
      required final DateTime addedAt,
      final DateTime? updatedAt,
      final bool isWatched,
      final DateTime? watchedAt}) = _$WatchlistItemImpl;

  factory _WatchlistItem.fromJson(Map<String, dynamic> json) =
      _$WatchlistItemImpl.fromJson;

  @override

  /// Unique identifier for the item
  String get id;
  @override

  /// Content ID (movie or TV show ID)
  int get contentId;
  @override

  /// Content type (movie or tv)
  String get contentType;
  @override

  /// Title of the content
  String get title;
  @override

  /// Poster path for the content
  String? get posterPath;
  @override

  /// Overview/description
  String? get overview;
  @override

  /// Release date
  DateTime? get releaseDate;
  @override

  /// Vote average/rating
  double? get voteAverage;
  @override

  /// Categories this item belongs to
  List<String> get categories;
  @override

  /// User rating (1-10, null if not rated)
  double? get userRating;
  @override

  /// User notes
  String? get notes;
  @override

  /// Priority level (1-5, higher = more priority)
  int get priority;
  @override

  /// When the item was added to watchlist
  DateTime get addedAt;
  @override

  /// When the item was last updated
  DateTime? get updatedAt;
  @override

  /// Whether the item has been watched
  bool get isWatched;
  @override

  /// When the item was marked as watched
  DateTime? get watchedAt;
  @override
  @JsonKey(ignore: true)
  _$$WatchlistItemImplCopyWith<_$WatchlistItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
