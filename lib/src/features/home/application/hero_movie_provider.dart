import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/movie.dart';
import '../../../core/models/tv_show.dart';
import '../../../core/services/tmdb_repository_provider.dart';
import 'home_filter_provider.dart';

/// Provider for curated hero content (featured movies/TV shows)
/// 
/// This provider fetches a curated selection of content for the hero carousel,
/// combining trending, popular, and highly-rated items. It supports filtering
/// by genre, year, and rating.
final heroMovieProvider = FutureProvider<List<dynamic>>((ref) async {
  final repository = ref.watch(tmdbRepositoryProvider);
  final filters = ref.watch(homeFilterProvider);
  
  try {
    // Fetch multiple categories for variety
    final trendingMovies = await repository.getTrendingMovies();
    final popularMovies = await repository.getPopularMovies();
    final topRatedMovies = await repository.getTopRatedMovies();
    
    // Combine and deduplicate
    final Set<int> seenIds = {};
    final List<dynamic> curated = [];
    
    // Helper function to add items with filters
    void addItems(List<dynamic> items) {
      for (final item in items) {
        if (seenIds.contains(_getId(item))) continue;
        
        // Apply filters
        if (!_passesFilters(item, filters)) continue;
        
        seenIds.add(_getId(item));
        curated.add(item);
        
        if (curated.length >= 8) break; // Limit to 8 hero items
      }
    }
    
    // Add in priority order
    addItems(trendingMovies.take(3).toList()); // Top 3 trending
    addItems(popularMovies.take(3).toList()); // Top 3 popular  
    addItems(topRatedMovies.take(4).toList()); // Top 4 rated
    
    // If we don't have enough, add more from any source
    if (curated.length < 5) {
      addItems(trendingMovies.skip(3).toList());
      addItems(popularMovies.skip(3).toList());
    }
    
    return curated.take(6).toList(); // Return max 6 items
  } catch (e) {
    // Return empty list on error
    return [];
  }
});

/// Get ID from either Movie or TvShow
int _getId(dynamic item) {
  if (item is Movie) return item.id;
  if (item is TvShow) return item.id;
  return 0;
}

/// Check if item passes all active filters
bool _passesFilters(dynamic item, HomeFilterState filters) {
  // Check genre filter
  if (filters.selectedGenre != null) {
    final genreIds = _getGenreIds(item);
    if (!genreIds.contains(filters.selectedGenre!.id)) {
      return false;
    }
  }
  
  // Check year filter
  if (filters.selectedYear != null) {
    final year = _getYear(item);
    if (year != filters.selectedYear) {
      return false;
    }
  }
  
  // Check rating filter
  if (filters.minRating != null) {
    final rating = _getRating(item);
    if (rating < filters.minRating!) {
      return false;
    }
  }
  
  return true;
}

/// Get genre IDs from item
List<int> _getGenreIds(dynamic item) {
  if (item is Movie) return item.genreIds ?? [];
  if (item is TvShow) return item.genreIds ?? [];
  return [];
}

/// Get year from item
int? _getYear(dynamic item) {
  try {
    if (item is Movie && item.releaseDate != null) {
      return item.releaseDate!.year;
    }
    if (item is TvShow && item.firstAirDate != null) {
      return item.firstAirDate!.year;
    }
  } catch (_) {}
  return null;
}

/// Get rating from item
double _getRating(dynamic item) {
  if (item is Movie) return item.voteAverage;
  if (item is TvShow) return item.voteAverage;
  return 0;
}
