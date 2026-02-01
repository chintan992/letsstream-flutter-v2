import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/models/genre.dart';

/// Provider for home screen filter state
/// 
/// Manages active filters for content on the home screen, including
/// language, genre, year, and minimum rating filters.
final homeFilterProvider = StateNotifierProvider<HomeFilterNotifier, HomeFilterState>(
  (ref) => HomeFilterNotifier(),
);

/// State class for home filters
class HomeFilterState {
  final String? selectedLanguage;
  final Genre? selectedGenre;
  final int? selectedYear;
  final double? minRating;
  
  const HomeFilterState({
    this.selectedLanguage,
    this.selectedGenre,
    this.selectedYear,
    this.minRating,
  });
  
  HomeFilterState copyWith({
    String? selectedLanguage,
    Genre? selectedGenre,
    int? selectedYear,
    double? minRating,
  }) {
    return HomeFilterState(
      selectedLanguage: selectedLanguage ?? this.selectedLanguage,
      selectedGenre: selectedGenre ?? this.selectedGenre,
      selectedYear: selectedYear ?? this.selectedYear,
      minRating: minRating ?? this.minRating,
    );
  }
  
  /// Check if any filter is active
  bool get hasActiveFilter => 
    selectedLanguage != null ||
    selectedGenre != null ||
    selectedYear != null ||
    minRating != null;
}

/// Notifier for managing filter state
class HomeFilterNotifier extends StateNotifier<HomeFilterState> {
  HomeFilterNotifier() : super(const HomeFilterState());
  
  /// Set language filter
  void setLanguage(String? language) {
    state = state.copyWith(selectedLanguage: language);
  }
  
  /// Set genre filter
  void setGenre(Genre? genre) {
    state = state.copyWith(selectedGenre: genre);
  }
  
  /// Set year filter
  void setYear(int? year) {
    state = state.copyWith(selectedYear: year);
  }
  
  /// Set minimum rating filter
  void setRating(double? rating) {
    state = state.copyWith(minRating: rating);
  }
  
  /// Clear all filters
  void clearAll() {
    state = const HomeFilterState();
  }
  
  /// Clear specific filter by type
  void clearFilter(String filterType) {
    switch (filterType) {
      case 'language':
        state = state.copyWith(selectedLanguage: null);
        break;
      case 'genre':
        state = state.copyWith(selectedGenre: null);
        break;
      case 'year':
        state = state.copyWith(selectedYear: null);
        break;
      case 'rating':
        state = state.copyWith(minRating: null);
        break;
    }
  }
}
