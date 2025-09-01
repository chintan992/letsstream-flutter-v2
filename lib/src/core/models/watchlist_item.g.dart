// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watchlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WatchlistItemImpl _$$WatchlistItemImplFromJson(Map<String, dynamic> json) =>
    _$WatchlistItemImpl(
      id: json['id'] as String,
      contentId: (json['contentId'] as num).toInt(),
      contentType: json['contentType'] as String,
      title: json['title'] as String,
      posterPath: json['posterPath'] as String?,
      overview: json['overview'] as String?,
      releaseDate: json['releaseDate'] == null
          ? null
          : DateTime.parse(json['releaseDate'] as String),
      voteAverage: (json['voteAverage'] as num?)?.toDouble(),
      categories: (json['categories'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      userRating: (json['userRating'] as num?)?.toDouble(),
      notes: json['notes'] as String?,
      priority: (json['priority'] as num?)?.toInt() ?? 3,
      addedAt: DateTime.parse(json['addedAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      isWatched: json['isWatched'] as bool? ?? false,
      watchedAt: json['watchedAt'] == null
          ? null
          : DateTime.parse(json['watchedAt'] as String),
    );

Map<String, dynamic> _$$WatchlistItemImplToJson(_$WatchlistItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'contentId': instance.contentId,
      'contentType': instance.contentType,
      'title': instance.title,
      'posterPath': instance.posterPath,
      'overview': instance.overview,
      'releaseDate': instance.releaseDate?.toIso8601String(),
      'voteAverage': instance.voteAverage,
      'categories': instance.categories,
      'userRating': instance.userRating,
      'notes': instance.notes,
      'priority': instance.priority,
      'addedAt': instance.addedAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'isWatched': instance.isWatched,
      'watchedAt': instance.watchedAt?.toIso8601String(),
    };
