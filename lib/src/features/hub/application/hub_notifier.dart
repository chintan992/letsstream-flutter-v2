import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/services/simple_cached_repository.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/core/services/user_preferences_service.dart';
import 'package:lets_stream/src/core/constants/content_constants.dart';
import 'package:logger/logger.dart';

part 'hub_notifier.freezed.dart';

@freezed
class HubState with _$HubState {
  const factory HubState({
    // Standard movie categories
    @Default([]) List<Movie> trendingMovies,
    @Default([]) List<Movie> nowPlayingMovies,
    @Default([]) List<Movie> popularMovies,
    @Default([]) List<Movie> topRatedMovies,
    
    // Standard TV show categories
    @Default([]) List<TvShow> trendingTvShows,
    @Default([]) List<TvShow> airingTodayTvShows,
    @Default([]) List<TvShow> popularTvShows,
    @Default([]) List<TvShow> topRatedTvShows,
    
    // Genre mappings
    @Default({}) Map<int, String> movieGenres,
    @Default({}) Map<int, String> tvGenres,
    
    // Expanded Movie Genres
    @Default([]) List<Movie> actionMovies,
    @Default([]) List<Movie> comedyMovies,
    @Default([]) List<Movie> horrorMovies,
    @Default([]) List<Movie> dramaMovies,
    @Default([]) List<Movie> sciFiMovies,
    @Default([]) List<Movie> adventureMovies,
    @Default([]) List<Movie> thrillerMovies,
    @Default([]) List<Movie> romanceMovies,
    
    // Expanded TV Show Genres
    @Default([]) List<TvShow> dramaTvShows,
    @Default([]) List<TvShow> comedyTvShows,
    @Default([]) List<TvShow> crimeTvShows,
    @Default([]) List<TvShow> sciFiFantasyTvShows,
    @Default([]) List<TvShow> documentaryTvShows,
    
    // Expanded Streaming Platforms
    @Default([]) List<TvShow> netflixShows,
    @Default([]) List<TvShow> amazonPrimeShows,
    @Default([]) List<TvShow> disneyPlusShows,
    @Default([]) List<TvShow> huluShows,
    @Default([]) List<TvShow> hboMaxShows,
    @Default([]) List<TvShow> appleTvShows,
    @Default([]) List<Movie> netflixMovies,
    @Default([]) List<Movie> amazonPrimeMovies,
    @Default([]) List<Movie> disneyPlusMovies,
    
    // Personalized content
    @Default([]) List<Movie> personalizedMovies,
    @Default([]) List<TvShow> personalizedTvShows,
    @Default([]) List<Movie> recommendedMovies,
    @Default([]) List<TvShow> recommendedTvShows,
    @Default([]) List<Movie> genreBasedMovies,
    @Default([]) List<TvShow> genreBasedTvShows,
    
    // Personalization settings
    @Default(false) bool isPersonalizationEnabled,
    @Default([]) List<int> userPreferredGenres,
    @Default([]) List<int> userPreferredPlatforms,
    
    // Loading and error states
    @Default(true) bool isLoading,
    Object? error,
  }) = _HubState;
}

class HubNotifier extends StateNotifier<HubState> {
  final SimpleCachedRepository _repo;
  final UserPreferencesService _prefsService = UserPreferencesService.instance;
  final Logger _logger = Logger();

  HubNotifier(this._repo) : super(const HubState()) {
    _initializeHub();
  }

  Future<void> _initializeHub() async {
    // Load user preferences first
    await _loadUserPreferences();
    // Then fetch all content
    await _fetchAll();
  }

  Future<void> _loadUserPreferences() async {
    try {
      final isPersonalizationEnabled = await _prefsService.isHubPersonalizationEnabled();
      final preferredGenres = await _prefsService.getPreferredGenres();
      final preferredPlatforms = await _prefsService.getPreferredPlatforms();

      state = state.copyWith(
        isPersonalizationEnabled: isPersonalizationEnabled,
        userPreferredGenres: preferredGenres.isNotEmpty 
          ? preferredGenres 
          : ContentConstants.defaultMovieGenres,
        userPreferredPlatforms: preferredPlatforms.isNotEmpty 
          ? preferredPlatforms 
          : ContentConstants.defaultPlatforms,
      );
    } catch (e) {
      // Use defaults if preferences can't be loaded
      state = state.copyWith(
        isPersonalizationEnabled: true,
        userPreferredGenres: ContentConstants.defaultMovieGenres,
        userPreferredPlatforms: ContentConstants.defaultPlatforms,
      );
    }
  }

  Future<void> _fetchAll() async {
    state = state.copyWith(isLoading: true);
    try {
      // Fetch basic content and genres first
      final basicResults = await Future.wait([
        _repo.getTrendingMovies(),
        _repo.getNowPlayingMovies(),
        _repo.getPopularMovies(),
        _repo.getTopRatedMovies(),
        _repo.getTrendingTvShows(),
        _repo.getAiringTodayTvShows(),
        _repo.getPopularTvShows(),
        _repo.getTopRatedTvShows(),
        _repo.getMovieGenres(),
        _repo.getTvGenres(),
      ]);

      // Update state with basic content
      state = state.copyWith(
        trendingMovies: basicResults[0] as List<Movie>,
        nowPlayingMovies: basicResults[1] as List<Movie>,
        popularMovies: basicResults[2] as List<Movie>,
        topRatedMovies: basicResults[3] as List<Movie>,
        trendingTvShows: basicResults[4] as List<TvShow>,
        airingTodayTvShows: basicResults[5] as List<TvShow>,
        popularTvShows: basicResults[6] as List<TvShow>,
        topRatedTvShows: basicResults[7] as List<TvShow>,
        movieGenres: basicResults[8] as Map<int, String>,
        tvGenres: basicResults[9] as Map<int, String>,
      );

      // Fetch expanded content in parallel
      await Future.wait([
        _fetchExpandedGenres(),
        _fetchExpandedPlatforms(),
        if (state.isPersonalizationEnabled) _fetchPersonalizedContent(),
      ]);

      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e, isLoading: false);
    }
  }

  Future<void> _fetchExpandedGenres() async {
    try {
      final genreResults = await Future.wait([
        // Movie genres
        _repo.getMoviesByGenre(28), // Action
        _repo.getMoviesByGenre(35), // Comedy
        _repo.getMoviesByGenre(27), // Horror
        _repo.getMoviesByGenre(18), // Drama
        _repo.getMoviesByGenre(878), // Sci-Fi
        _repo.getMoviesByGenre(12), // Adventure
        _repo.getMoviesByGenre(53), // Thriller
        _repo.getMoviesByGenre(10749), // Romance
        
        // TV show genres
        _repo.getTvByGenre(18), // Drama
        _repo.getTvByGenre(35), // Comedy
        _repo.getTvByGenre(80), // Crime
        _repo.getTvByGenre(10765), // Sci-Fi & Fantasy
        _repo.getTvByGenre(99), // Documentary
      ]);

      state = state.copyWith(
        // Movie genres
        actionMovies: genreResults[0] as List<Movie>,
        comedyMovies: genreResults[1] as List<Movie>,
        horrorMovies: genreResults[2] as List<Movie>,
        dramaMovies: genreResults[3] as List<Movie>,
        sciFiMovies: genreResults[4] as List<Movie>,
        adventureMovies: genreResults[5] as List<Movie>,
        thrillerMovies: genreResults[6] as List<Movie>,
        romanceMovies: genreResults[7] as List<Movie>,
        
        // TV show genres
        dramaTvShows: genreResults[8] as List<TvShow>,
        comedyTvShows: genreResults[9] as List<TvShow>,
        crimeTvShows: genreResults[10] as List<TvShow>,
        sciFiFantasyTvShows: genreResults[11] as List<TvShow>,
        documentaryTvShows: genreResults[12] as List<TvShow>,
      );
    } catch (e) {
      // Log error but don't fail the entire fetch
      _logger.e('Error fetching expanded genres: $e');
    }
  }

  Future<void> _fetchExpandedPlatforms() async {
    try {
      final platformResults = await Future.wait([
        // TV Shows
        _repo.getTvShowsByWatchProvider(8), // Netflix
        _repo.getTvShowsByWatchProvider(9), // Amazon Prime Video
        _repo.getTvShowsByWatchProvider(337), // Disney Plus
        _repo.getTvShowsByWatchProvider(15), // Hulu
        _repo.getTvShowsByWatchProvider(384), // HBO Max
        _repo.getTvShowsByWatchProvider(2), // Apple TV Plus
        
        // Movies
        _repo.getMoviesByWatchProvider(8), // Netflix Movies
        _repo.getMoviesByWatchProvider(9), // Amazon Prime Movies
        _repo.getMoviesByWatchProvider(337), // Disney Plus Movies
      ]);

      state = state.copyWith(
        // TV Shows
        netflixShows: platformResults[0] as List<TvShow>,
        amazonPrimeShows: platformResults[1] as List<TvShow>,
        disneyPlusShows: platformResults[2] as List<TvShow>,
        huluShows: platformResults[3] as List<TvShow>,
        hboMaxShows: platformResults[4] as List<TvShow>,
        appleTvShows: platformResults[5] as List<TvShow>,
        
        // Movies
        netflixMovies: platformResults[6] as List<Movie>,
        amazonPrimeMovies: platformResults[7] as List<Movie>,
        disneyPlusMovies: platformResults[8] as List<Movie>,
      );
    } catch (e) {
      // Log error but don't fail the entire fetch
      _logger.e('Error fetching expanded platforms: $e');
    }
  }

  Future<void> _fetchPersonalizedContent() async {
    try {
      final personalizedResults = await Future.wait([
        // Personalized movies based on user's preferred genres
        if (state.userPreferredGenres.isNotEmpty)
          _repo.getMoviesByGenres(state.userPreferredGenres.take(3).toList())
        else
          _repo.getPopularMovies(),
          
        // Personalized TV shows based on user's preferred genres  
        if (state.userPreferredGenres.isNotEmpty)
          _repo.getTvByGenres(state.userPreferredGenres.take(3).toList())
        else
          _repo.getPopularTvShows(),
          
        // Platform-based recommendations
        if (state.userPreferredPlatforms.isNotEmpty)
          _repo.getTvShowsByWatchProvider(state.userPreferredPlatforms.first)
        else
          _repo.getTvShowsByWatchProvider(8), // Default to Netflix
      ]);

      state = state.copyWith(
        personalizedMovies: personalizedResults[0] as List<Movie>,
        personalizedTvShows: personalizedResults[1] as List<TvShow>,
        recommendedTvShows: personalizedResults[2] as List<TvShow>,
      );
    } catch (e) {
      // Log error but don't fail the entire fetch
      _logger.e('Error fetching personalized content: $e');
    }
  }

  /// Refresh all content
  Future<void> refresh() async {
    await _fetchAll();
  }

  /// Update user preferences and refresh personalized content
  /// Update user preferences and refresh personalized content
  Future<void> updatePreferences({
    List<int>? preferredGenres,
    List<int>? preferredPlatforms,
    bool? personalizationEnabled,
  }) async {
    try {
      if (preferredGenres != null) {
        await _prefsService.setPreferredGenres(preferredGenres);
        state = state.copyWith(userPreferredGenres: preferredGenres);
      }
      
      if (preferredPlatforms != null) {
        await _prefsService.setPreferredPlatforms(preferredPlatforms);
        state = state.copyWith(userPreferredPlatforms: preferredPlatforms);
      }
      
      if (personalizationEnabled != null) {
        await _prefsService.setHubPersonalizationEnabled(personalizationEnabled);
        state = state.copyWith(isPersonalizationEnabled: personalizationEnabled);
      }

      // Refresh personalized content if personalization is enabled
      if (state.isPersonalizationEnabled) {
        await _fetchPersonalizedContent();
      }
    } catch (e) {
      _logger.e('Error updating preferences: $e');
    }
  }

  /// Toggle personalization on/off
  Future<void> togglePersonalization() async {
    await updatePreferences(personalizationEnabled: !state.isPersonalizationEnabled);
  }
}

final hubNotifierProvider = StateNotifierProvider<HubNotifier, HubState>((ref) {
  final repo = ref.watch(tmdbRepositoryProvider);
  return HubNotifier(repo);
});
