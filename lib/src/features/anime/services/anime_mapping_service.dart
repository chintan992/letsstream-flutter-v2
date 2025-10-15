import 'package:lets_stream/src/core/api/anime_api.dart';
import 'package:lets_stream/src/core/models/anime/anime_search_result.dart';
import 'package:lets_stream/src/core/models/anime/tmdb_anime_mapping.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';

/// Service for mapping TMDB anime entries to Anime API entries.
///
/// This service handles the complex task of finding corresponding anime
/// entries between TMDB and the Anime API using fuzzy matching algorithms.
class AnimeMappingService {
  /// The Anime API client for searching anime.
  final AnimeApi _animeApi;

  /// Cache for storing successful mappings.
  final Map<int, TmdbAnimeMapping> _mappingCache = {};

  /// Creates a new AnimeMappingService instance.
  ///
  /// [_animeApi] The Anime API client to use for searching.
  AnimeMappingService(this._animeApi);

  /// Maps a TMDB anime to an Anime API entry.
  ///
  /// [tmdbAnime] The TMDB anime (Movie or TvShow).
  /// [forceRefresh] Whether to bypass cache and force a new search.
  ///
  /// Returns the best matching Anime API entry, or null if no good match found.
  /// Throws an [Exception] if the search fails.
  Future<AnimeSearchResult?> mapTmdbToAnimeApi(
    dynamic tmdbAnime, {
    bool forceRefresh = false,
  }) async {
    if (tmdbAnime is! Movie && tmdbAnime is! TvShow) {
      throw Exception('Invalid TMDB anime type: ${tmdbAnime.runtimeType}');
    }

    final tmdbId = tmdbAnime.id;

    // Check cache first (unless force refresh)
    if (!forceRefresh && _mappingCache.containsKey(tmdbId)) {
      final cachedMapping = _mappingCache[tmdbId]!;
      if (!cachedMapping.shouldRefresh) {
        // Return cached result by searching for the cached ID
        try {
          final results = await _animeApi.searchAnime(cachedMapping.animeApiId);
          if (results.isNotEmpty) {
            return results.firstWhere(
              (result) => result.id == cachedMapping.animeApiId,
              orElse: () => results.first,
            );
          }
        } catch (_) {
          // If cached result fails, continue with new search
        }
      }
    }

    // Perform new search
    final searchResults = await _searchAnimeApi(tmdbAnime);
    
    if (searchResults.isEmpty) {
      return null;
    }

    // Find the best match
    final bestMatch = _findBestMatch(tmdbAnime, searchResults);
    
    if (bestMatch != null) {
      // Cache the successful mapping
      _mappingCache[tmdbId] = TmdbAnimeMapping(
        tmdbId: tmdbId,
        animeApiId: bestMatch.id,
        animeTitle: bestMatch.title,
        cachedAt: DateTime.now(),
        isManualMapping: false,
      );
    }

    return bestMatch;
  }

  /// Searches the Anime API using both English and Japanese titles from TMDB.
  Future<List<AnimeSearchResult>> _searchAnimeApi(dynamic tmdbAnime) async {
    final Set<AnimeSearchResult> allResults = {};

    try {
      final title = tmdbAnime is Movie ? tmdbAnime.title : tmdbAnime.name;
      
      // Search using English title
      final englishResults = await _animeApi.searchAnime(title);
      allResults.addAll(englishResults);

      // If we have original language info, search using Japanese title too
      if (tmdbAnime is TvShow) {
        // For TV shows, we might have original_name field
        // This would require extending the TvShow model to include original_name
        // For now, we'll try some common Japanese title variations
        final japaneseVariations = _generateJapaneseTitleVariations(title);
        for (final variation in japaneseVariations) {
          try {
            final japaneseResults = await _animeApi.searchAnime(variation);
            allResults.addAll(japaneseResults);
          } catch (_) {
            // Continue if Japanese search fails
          }
        }
      }
    } catch (e) {
      throw Exception('Failed to search Anime API: $e');
    }

    return allResults.toList();
  }

  /// Generates possible Japanese title variations for search.
  List<String> _generateJapaneseTitleVariations(String englishTitle) {
    // This is a simplified approach - in a real implementation,
    // you might want to use a translation service or maintain a mapping
    final variations = <String>[];
    
    // Add some common anime title patterns
    if (englishTitle.toLowerCase().contains('demon slayer')) {
      variations.addAll(['鬼滅の刃', 'kimetsu no yaiba']);
    }
    if (englishTitle.toLowerCase().contains('one piece')) {
      variations.addAll(['ワンピース', 'one piece']);
    }
    if (englishTitle.toLowerCase().contains('attack on titan')) {
      variations.addAll(['進撃の巨人', 'shingeki no kyojin']);
    }
    if (englishTitle.toLowerCase().contains('naruto')) {
      variations.addAll(['ナルト', 'naruto']);
    }
    
    return variations;
  }

  /// Finds the best match from search results using fuzzy matching.
  AnimeSearchResult? _findBestMatch(
    dynamic tmdbAnime,
    List<AnimeSearchResult> searchResults,
  ) {
    if (searchResults.isEmpty) return null;

    final title = tmdbAnime is Movie ? tmdbAnime.title : tmdbAnime.name;
    AnimeSearchResult? bestMatch;
    double bestScore = 0.0;

    for (final result in searchResults) {
      final score = _calculateMatchScore(tmdbAnime, result, title);
      if (score > bestScore) {
        bestScore = score;
        bestMatch = result;
      }
    }

    // Only return matches with a reasonable confidence level
    return bestScore > 0.3 ? bestMatch : null;
  }

  /// Calculates a match score between TMDB anime and Anime API result.
  double _calculateMatchScore(
    dynamic tmdbAnime,
    AnimeSearchResult result,
    String tmdbTitle,
  ) {
    double score = 0.0;

    // Exact title match gets highest score
    if (result.title.toLowerCase() == tmdbTitle.toLowerCase()) {
      score += 1.0;
    } else if (result.japaneseTitle.toLowerCase() == tmdbTitle.toLowerCase()) {
      score += 0.9;
    }

    // Partial title match
    final tmdbWords = tmdbTitle.toLowerCase().split(' ');
    final animeWords = result.title.toLowerCase().split(' ');
    final japaneseWords = result.japaneseTitle.toLowerCase().split(' ');

    // Check for word overlap in English title
    final englishWordOverlap = _calculateWordOverlap(tmdbWords, animeWords);
    score += englishWordOverlap * 0.6;

    // Check for word overlap in Japanese title
    final japaneseWordOverlap = _calculateWordOverlap(tmdbWords, japaneseWords);
    score += japaneseWordOverlap * 0.5;

    // Prefer main series over arcs/specials (higher episode count)
    final episodeCount = result.tvInfo.eps ?? 0;
    if (episodeCount > 20) {
      score += 0.2; // Bonus for long-running series
    } else if (episodeCount > 0) {
      score += 0.1; // Small bonus for having episodes
    }

    // Prefer TV series over movies for TV shows
    if (tmdbAnime is TvShow && result.tvInfo.showType == 'TV') {
      score += 0.1;
    }

    // Prefer movies over TV for movies
    if (tmdbAnime is Movie && result.tvInfo.showType == 'Movie') {
      score += 0.1;
    }

    // Penalty for very different show types
    if (tmdbAnime is TvShow && result.tvInfo.showType == 'Movie') {
      score -= 0.3;
    }
    if (tmdbAnime is Movie && result.tvInfo.showType == 'TV') {
      score -= 0.3;
    }

    return score;
  }

  /// Calculates word overlap between two word lists.
  double _calculateWordOverlap(List<String> words1, List<String> words2) {
    if (words1.isEmpty || words2.isEmpty) return 0.0;

    final set1 = words1.toSet();
    final set2 = words2.toSet();
    final intersection = set1.intersection(set2);
    final union = set1.union(set2);

    return intersection.length / union.length;
  }

  /// Manually maps a TMDB anime to an Anime API entry.
  ///
  /// This is used when the user manually selects a mapping from search results.
  void setManualMapping(int tmdbId, AnimeSearchResult animeResult) {
    _mappingCache[tmdbId] = TmdbAnimeMapping(
      tmdbId: tmdbId,
      animeApiId: animeResult.id,
      animeTitle: animeResult.title,
      cachedAt: DateTime.now(),
      isManualMapping: true,
    );
  }

  /// Gets cached mapping for a TMDB ID.
  TmdbAnimeMapping? getCachedMapping(int tmdbId) {
    return _mappingCache[tmdbId];
  }

  /// Clears the mapping cache.
  void clearCache() {
    _mappingCache.clear();
  }

  /// Gets all cached mappings.
  List<TmdbAnimeMapping> getAllCachedMappings() {
    return _mappingCache.values.toList();
  }

  /// Removes a specific mapping from cache.
  void removeMapping(int tmdbId) {
    _mappingCache.remove(tmdbId);
  }

  /// Checks if a TMDB anime has a cached mapping.
  bool hasCachedMapping(int tmdbId) {
    final mapping = _mappingCache[tmdbId];
    return mapping != null && !mapping.shouldRefresh;
  }
}
