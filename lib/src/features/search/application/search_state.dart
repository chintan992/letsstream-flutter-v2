import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';

enum SearchFilter { all, movies, tv }

class SearchState {
  final String query;
  final int page;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? error;
  final List<dynamic> items; // Movie or TvShow
  final SearchFilter filter;

  const SearchState({
    this.query = '',
    this.page = 1,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.error,
    this.items = const [],
    this.filter = SearchFilter.all,
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
