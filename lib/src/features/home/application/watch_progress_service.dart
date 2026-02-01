import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/tv_show.dart';

/// Model representing watch progress for a movie or episode
class WatchProgress {
  final String contentId;
  final String contentType; // 'movie' or 'tv'
  final String? episodeId; // For TV shows
  final int? seasonNumber; // For TV shows
  final int? episodeNumber; // For TV shows
  final Duration position;
  final Duration duration;
  final DateTime lastWatched;
  final String? title;
  final String? posterPath;
  final double? voteAverage;

  WatchProgress({
    required this.contentId,
    required this.contentType,
    this.episodeId,
    this.seasonNumber,
    this.episodeNumber,
    required this.position,
    required this.duration,
    required this.lastWatched,
    this.title,
    this.posterPath,
    this.voteAverage,
  });

  /// Calculate progress percentage (0.0 to 1.0)
  double get progressPercent {
    if (duration.inSeconds == 0) return 0.0;
    return (position.inSeconds / duration.inSeconds).clamp(0.0, 1.0);
  }

  /// Check if content is completed (> 95% watched)
  bool get isCompleted => progressPercent >= 0.95;

  /// Check if content has meaningful progress (> 5% and < 95%)
  bool get hasValidProgress => progressPercent > 0.05 && progressPercent < 0.95;

  /// Format remaining time
  String get remainingTime {
    final remaining = duration - position;
    if (remaining.inHours > 0) {
      return '${remaining.inHours}h ${remaining.inMinutes.remainder(60)}m left';
    } else {
      return '${remaining.inMinutes}m left';
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'contentId': contentId,
      'contentType': contentType,
      'episodeId': episodeId,
      'seasonNumber': seasonNumber,
      'episodeNumber': episodeNumber,
      'positionSeconds': position.inSeconds,
      'durationSeconds': duration.inSeconds,
      'lastWatched': lastWatched.toIso8601String(),
      'title': title,
      'posterPath': posterPath,
      'voteAverage': voteAverage,
    };
  }

  factory WatchProgress.fromJson(Map<String, dynamic> json) {
    return WatchProgress(
      contentId: json['contentId'] as String,
      contentType: json['contentType'] as String,
      episodeId: json['episodeId'] as String?,
      seasonNumber: json['seasonNumber'] as int?,
      episodeNumber: json['episodeNumber'] as int?,
      position: Duration(seconds: json['positionSeconds'] as int),
      duration: Duration(seconds: json['durationSeconds'] as int),
      lastWatched: DateTime.parse(json['lastWatched'] as String),
      title: json['title'] as String?,
      posterPath: json['posterPath'] as String?,
      voteAverage: json['voteAverage'] as double?,
    );
  }

  WatchProgress copyWith({
    String? contentId,
    String? contentType,
    String? episodeId,
    int? seasonNumber,
    int? episodeNumber,
    Duration? position,
    Duration? duration,
    DateTime? lastWatched,
    String? title,
    String? posterPath,
    double? voteAverage,
  }) {
    return WatchProgress(
      contentId: contentId ?? this.contentId,
      contentType: contentType ?? this.contentType,
      episodeId: episodeId ?? this.episodeId,
      seasonNumber: seasonNumber ?? this.seasonNumber,
      episodeNumber: episodeNumber ?? this.episodeNumber,
      position: position ?? this.position,
      duration: duration ?? this.duration,
      lastWatched: lastWatched ?? this.lastWatched,
      title: title ?? this.title,
      posterPath: posterPath ?? this.posterPath,
      voteAverage: voteAverage ?? this.voteAverage,
    );
  }
}

/// Provider for shared preferences
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('Initialize in main.dart with SharedPreferences.getInstance()');
});

/// Service for tracking watch progress
class WatchProgressService {
  static const String _prefsKey = 'watch_progress';
  final SharedPreferences _prefs;

  WatchProgressService(this._prefs);

  /// Save progress for a movie
  Future<void> saveMovieProgress({
    required Movie movie,
    required Duration position,
    required Duration duration,
  }) async {
    final progress = WatchProgress(
      contentId: movie.id.toString(),
      contentType: 'movie',
      position: position,
      duration: duration,
      lastWatched: DateTime.now(),
      title: movie.title,
      posterPath: movie.posterPath,
      voteAverage: movie.voteAverage,
    );

    await _saveProgress(progress);
  }

  /// Save progress for a TV episode
  Future<void> saveEpisodeProgress({
    required TvShow tvShow,
    required int seasonNumber,
    required int episodeNumber,
    required String? episodeId,
    required Duration position,
    required Duration duration,
    required String episodeTitle,
  }) async {
    final progress = WatchProgress(
      contentId: tvShow.id.toString(),
      contentType: 'tv',
      seasonNumber: seasonNumber,
      episodeNumber: episodeNumber,
      episodeId: episodeId,
      position: position,
      duration: duration,
      lastWatched: DateTime.now(),
      title: '${tvShow.name} - S${seasonNumber}E$episodeNumber',
      posterPath: tvShow.posterPath,
      voteAverage: tvShow.voteAverage,
    );

    await _saveProgress(progress);
  }

  /// Get all continue watching items (valid progress only)
  Future<List<WatchProgress>> getContinueWatching() async {
    final allProgress = await _getAllProgress();
    return allProgress
        .where((p) => p.hasValidProgress)
        .toList()
      ..sort((a, b) => b.lastWatched.compareTo(a.lastWatched));
  }

  /// Get progress for specific content
  Future<WatchProgress?> getProgress(String contentId, {String? episodeId}) async {
    final allProgress = await _getAllProgress();
    try {
      return allProgress.firstWhere(
        (p) => p.contentId == contentId && (episodeId == null || p.episodeId == episodeId),
      );
    } catch (_) {
      return null;
    }
  }

  /// Remove completed items or specific content
  Future<void> removeProgress(String contentId, {String? episodeId}) async {
    final allProgress = await _getAllProgress();
    allProgress.removeWhere(
      (p) => p.contentId == contentId && (episodeId == null || p.episodeId == episodeId),
    );
    await _saveAllProgress(allProgress);
  }

  /// Clear all watch progress
  Future<void> clearAllProgress() async {
    await _prefs.remove(_prefsKey);
  }

  /// Save progress to local storage
  Future<void> _saveProgress(WatchProgress progress) async {
    final allProgress = await _getAllProgress();
    
    // Remove existing entry for this content
    allProgress.removeWhere(
      (p) => p.contentId == progress.contentId && p.episodeId == progress.episodeId,
    );
    
    // Add new progress
    allProgress.add(progress);
    
    await _saveAllProgress(allProgress);
  }

  /// Get all progress from local storage
  Future<List<WatchProgress>> _getAllProgress() async {
    final jsonString = _prefs.getString(_prefsKey);
    if (jsonString == null || jsonString.isEmpty) return [];

    try {
      final List<dynamic> jsonList = jsonDecode(jsonString) as List<dynamic>;
      return jsonList
          .map((json) => WatchProgress.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // If parsing fails, clear corrupted data
      await _prefs.remove(_prefsKey);
      return [];
    }
  }

  /// Save all progress to local storage
  Future<void> _saveAllProgress(List<WatchProgress> progress) async {
    final jsonList = progress.map((p) => p.toJson()).toList();
    final jsonString = jsonEncode(jsonList);
    await _prefs.setString(_prefsKey, jsonString);
  }
}

/// Provider for watch progress service
final watchProgressServiceProvider = Provider<WatchProgressService>((ref) {
  final prefs = ref.watch(sharedPreferencesProvider);
  return WatchProgressService(prefs);
});

/// Provider for continue watching list
final continueWatchingProvider = FutureProvider<List<WatchProgress>>((ref) async {
  final service = ref.watch(watchProgressServiceProvider);
  return service.getContinueWatching();
});
