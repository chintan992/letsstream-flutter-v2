import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';

enum SearchFilter { all, movies, tv }

enum SortBy { popularity, releaseDate, rating, title }

class SearchFilters {
  final List<int> genres;
  final int? releaseYear;
  final double? minRating;
  final SortBy sortBy;

  const SearchFilters({
    this.genres = const [],
    this.releaseYear,
    this.minRating,
    this.sortBy = SortBy.popularity,
  });

  SearchFilters copyWith({
    List<int>? genres,
    int? releaseYear,
    double? minRating,
    SortBy? sortBy,
  }) {
    return SearchFilters(
      genres: genres ?? this.genres,
      releaseYear: releaseYear ?? this.releaseYear,
      minRating: minRating ?? this.minRating,
      sortBy: sortBy ?? this.sortBy,
    );
  }

  bool get hasActiveFilters =>
      genres.isNotEmpty || releaseYear != null || minRating != null;

  SearchFilters clear() {
    return const SearchFilters();
  }

  Map<String, dynamic> toApiParams() {
    final params = <String, dynamic>{};

    if (genres.isNotEmpty) {
      params['with_genres'] = genres.join(',');
    }

    if (releaseYear != null) {
      params['primary_release_year'] = releaseYear.toString();
    }

    if (minRating != null) {
      params['vote_average.gte'] = minRating.toString();
    }

    // Add sorting
    switch (sortBy) {
      case SortBy.popularity:
        params['sort_by'] = 'popularity.desc';
        break;
      case SortBy.releaseDate:
        params['sort_by'] = 'release_date.desc';
        break;
      case SortBy.rating:
        params['sort_by'] = 'vote_average.desc';
        break;
      case SortBy.title:
        params['sort_by'] = 'title.asc';
        break;
    }

    return params;
  }
}

class SearchState {
  final String query;
  final int page;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final List<dynamic> items; // Movie or TvShow
  final SearchFilter filter;
  final SearchFilters advancedFilters;

  const SearchState({
    this.query = '',
    this.page = 1,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.error,
    this.items = const [],
    this.filter = SearchFilter.all,
    this.advancedFilters = const SearchFilters(),
  });

  bool get isEmptyQuery => query.trim().isEmpty;

  SearchState copyWith({
    String? query,
    int? page,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? error,
    List<dynamic>? items,
    SearchFilter? filter,
    SearchFilters? advancedFilters,
  }) {
    return SearchState(
      query: query ?? this.query,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      error: error,
      items: items ?? this.items,
      filter: filter ?? this.filter,
      advancedFilters: advancedFilters ?? this.advancedFilters,
    );
  }

  static int _popularity(dynamic item) {
    if (item is Movie) return item.popularity.round();
    if (item is TvShow) return item.popularity.round();
    return 0;
  }

  List<dynamic> mergedSorted(List<Movie> movies, List<TvShow> tvs) {
    final list = <dynamic>[...movies, ...tvs];
    list.sort((a, b) => _popularity(b).compareTo(_popularity(a)));
    return list;
  }

  List<dynamic> filteredItems() {
    switch (filter) {
      case SearchFilter.all:
        return items;
      case SearchFilter.movies:
        return items.whereType<Movie>().toList();
      case SearchFilter.tv:
        return items.whereType<TvShow>().toList();
    }
  }
}
