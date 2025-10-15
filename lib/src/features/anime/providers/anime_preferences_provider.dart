import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Enum for anime streaming source options.
enum AnimeStreamingSource {
  /// Use TMDB sources with iframe embedding.
  tmdbSources,
  
  /// Use Anime API with direct streaming.
  animeApi,
}

/// Extension to provide display names and descriptions.
extension AnimeStreamingSourceExtension on AnimeStreamingSource {
  String get displayName {
    switch (this) {
      case AnimeStreamingSource.tmdbSources:
        return 'TMDB Sources';
      case AnimeStreamingSource.animeApi:
        return 'Anime API';
    }
  }

  String get description {
    switch (this) {
      case AnimeStreamingSource.tmdbSources:
        return 'Use traditional iframe-based streaming sources';
      case AnimeStreamingSource.animeApi:
        return 'Use direct HLS streaming with Chewie player';
    }
  }

  String get icon {
    switch (this) {
      case AnimeStreamingSource.tmdbSources:
        return '🌐';
      case AnimeStreamingSource.animeApi:
        return '🎬';
    }
  }
}

/// Provider for anime streaming source preference.
final animeStreamingSourceProvider = StateNotifierProvider<AnimeStreamingSourceNotifier, AnimeStreamingSource>((ref) {
  return AnimeStreamingSourceNotifier();
});

/// Notifier for managing anime streaming source preference.
class AnimeStreamingSourceNotifier extends StateNotifier<AnimeStreamingSource> {
  static const String _preferenceKey = 'anime_streaming_source';
  
  /// Creates a new AnimeStreamingSourceNotifier instance.
  AnimeStreamingSourceNotifier() : super(AnimeStreamingSource.tmdbSources) {
    _loadPreference();
  }

  /// Loads the preference from SharedPreferences.
  Future<void> _loadPreference() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final sourceIndex = prefs.getInt(_preferenceKey) ?? AnimeStreamingSource.tmdbSources.index;
      
      if (sourceIndex >= 0 && sourceIndex < AnimeStreamingSource.values.length) {
        state = AnimeStreamingSource.values[sourceIndex];
      }
    } catch (e) {
      // If loading fails, keep the default value
      state = AnimeStreamingSource.tmdbSources;
    }
  }

  /// Sets the anime streaming source preference.
  Future<void> setSource(AnimeStreamingSource source) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt(_preferenceKey, source.index);
      state = source;
    } catch (e) {
      // Handle error silently or log it
    }
  }

  /// Returns true if Anime API is the selected source.
  bool get isAnimeApiSelected => state == AnimeStreamingSource.animeApi;

  /// Returns true if TMDB sources are selected.
  bool get isTmdbSourcesSelected => state == AnimeStreamingSource.tmdbSources;
}
