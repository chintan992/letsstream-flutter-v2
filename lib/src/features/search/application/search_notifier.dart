import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/services/tmdb_repository_provider.dart';
import 'package:lets_stream/src/features/search/application/search_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

const kSearchDebounce = Duration(milliseconds: 400);

class SearchNotifier extends StateNotifier<SearchState> {
  static const _kPrefQuery = 'search.lastQuery';
  static const _kPrefFilter = 'search.lastFilter';
  final Ref ref;
  Timer? _debounce;
  int _requestId = 0; // helps ignore stale responses

  SearchNotifier(this.ref) : super(const SearchState());

  Future<String> loadPersisted() async {
    final prefs = await SharedPreferences.getInstance();
    final savedQuery = prefs.getString(_kPrefQuery) ?? '';
    final savedFilterStr = prefs.getString(_kPrefFilter);
    SearchFilter savedFilter = state.filter;
    if (savedFilterStr != null) {
      switch (savedFilterStr) {
        case 'all':
          savedFilter = SearchFilter.all;
          break;
        case 'movies':
          savedFilter = SearchFilter.movies;
          break;
        case 'tv':
          savedFilter = SearchFilter.tv;
          break;
      }
    }

    if (savedQuery.isEmpty) {
      state = state.copyWith(query: '', filter: savedFilter, items: const [], page: 1, hasMore: false, error: null);
      return savedQuery;
    }

    state = state.copyWith(query: savedQuery, filter: savedFilter, page: 1, items: const [], hasMore: false, error: null);
    // Trigger initial search without debounce
    await _search(page: 1, append: false);
    return savedQuery;
  }

  Future<void> _persistState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kPrefQuery, state.query);
    await prefs.setString(_kPrefFilter, state.filter.name);
  }

  void onQueryChanged(String raw) {
    final q = raw.trim();
    // Cancel any existing debounce
    _debounce?.cancel();

    if (q.isEmpty) {
      // Reset state when cleared
      state = const SearchState();
      // Persist cleared query and current filter
      _persistState();
      return;
    }

    // Optimistically set the query immediately
    state = state.copyWith(query: q, page: 1, items: const [], hasMore: false, error: null);

    _debounce = Timer(kSearchDebounce, () {
      _search(page: 1, append: false);
    });
  }

  Future<void> retry() async {
    if (state.query.isEmpty) return;
    await _search(page: 1, append: false);
  }

  void setFilter(SearchFilter filter) {
    if (state.filter == filter) return;
    state = state.copyWith(filter: filter);
    _persistState();
  }

  Future<void> fetchNextPage() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore || state.query.isEmpty) return;
    await _search(page: state.page + 1, append: true);
  }

  Future<void> _search({required int page, required bool append}) async {
    final query = state.query;
    if (query.isEmpty) return;

    final currentRequest = ++_requestId;

    if (append) {
      state = state.copyWith(isLoadingMore: true, error: null);
    } else {
      state = state.copyWith(isLoading: true, error: null);
    }

    try {
      final repo = ref.read(tmdbRepositoryProvider);
      // Fetch movies and TV in parallel
      final results = await Future.wait<List<dynamic>>([
        repo.searchMovies(query, page: page),
        repo.searchTvShows(query, page: page),
      ]);

      // If another request began after this one, ignore these results
      if (currentRequest != _requestId) return;

      final movies = (results[0] as List<Movie>);
      final tvs = (results[1] as List<TvShow>);
      final merged = state.mergedSorted(movies, tvs);

      final newItems = append ? [...state.items, ...merged] : merged;
      final hasMore = movies.isNotEmpty || tvs.isNotEmpty;

      state = state.copyWith(
        page: page,
        isLoading: false,
        isLoadingMore: false,
        hasMore: hasMore,
        items: newItems,
        error: null,
      );
      // Persist latest successful state (query/filter)
      _persistState();
    } catch (e) {
      // Only set error if request is still relevant
      if (currentRequest != _requestId) return;
      state = state.copyWith(
        isLoading: false,
        isLoadingMore: false,
        error: e.toString(),
      );
    }
  }
}

final searchNotifierProvider = StateNotifierProvider<SearchNotifier, SearchState>((ref) {
  return SearchNotifier(ref);
});
