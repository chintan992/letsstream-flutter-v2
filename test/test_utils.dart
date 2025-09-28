import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/services/accessibility_service.dart';
import 'package:lets_stream/src/shared/theme/theme_providers.dart';

// Generate mocks
@GenerateMocks([AccessibilityService])
import 'test_utils.mocks.dart';

/// Test utilities for widget tests
class TestUtils {
  /// Creates a test movie with default values
  static Movie createTestMovie({
    int id = 1,
    String title = 'Test Movie',
    String? posterPath = '/test-poster.jpg',
    String? backdropPath = '/test-backdrop.jpg',
    String overview = 'Test overview',
    double voteAverage = 8.5,
    DateTime? releaseDate,
    List<int>? genreIds,
    double popularity = 100.0,
    int voteCount = 1000,
  }) {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      backdropPath: backdropPath,
      releaseDate: releaseDate ?? DateTime(2023),
      voteAverage: voteAverage,
      voteCount: voteCount,
      genreIds: genreIds,
    );
  }

  /// Creates a test TV show with default values
  static TvShow createTestTvShow({
    int id = 1,
    String name = 'Test TV Show',
    String? posterPath = '/test-poster.jpg',
    String? backdropPath = '/test-backdrop.jpg',
    String overview = 'Test overview',
    double voteAverage = 8.5,
    DateTime? firstAirDate,
    List<int>? genreIds,
    double popularity = 100.0,
    int voteCount = 1000,
  }) {
    return TvShow(
      id: id,
      name: name,
      overview: overview,
      popularity: popularity,
      posterPath: posterPath,
      backdropPath: backdropPath,
      firstAirDate: firstAirDate ?? DateTime(2023),
      voteAverage: voteAverage,
      voteCount: voteCount,
      genreIds: genreIds,
    );
  }

  /// Creates a test widget wrapped with necessary providers
  static Widget wrapWithProviders(Widget child) {
    return ProviderScope(
      overrides: [
        // Override theme provider for consistent testing
        themeNotifierProvider.overrideWith(
          (ref) => ThemeNotifier(ThemeService()),
        ),
      ],
      child: MaterialApp(home: child),
    );
  }

  /// Pumps widget with providers and waits for animations
  static Future<void> pumpWidgetWithProviders(
    WidgetTester tester,
    Widget child, {
    Duration? duration,
  }) async {
    await tester.pumpWidget(wrapWithProviders(child));
    await tester.pumpAndSettle(duration ?? const Duration(milliseconds: 100));
  }

  /// Creates a mock accessibility service
  static MockAccessibilityService createMockAccessibilityService() {
    final mock = MockAccessibilityService();
    when(mock.getRecommendedTouchTargetSize(any)).thenReturn(48.0);
    return mock;
  }

  /// Finds a widget by semantic label
  static Finder findBySemanticLabel(String label) {
    return find.byWidgetPredicate(
      (widget) => widget is Semantics && widget.properties.label == label,
    );
  }

  /// Finds a widget by tooltip
  static Finder findByTooltip(String tooltip) {
    return find.byWidgetPredicate(
      (widget) => widget is Tooltip && widget.message == tooltip,
    );
  }

  /// Expects widget to be accessible with given label
  static void expectWidgetAccessible(WidgetTester tester, String label) {
    final semantics = tester.widget<Semantics>(
      find.byWidgetPredicate(
        (widget) => widget is Semantics && widget.properties.label == label,
      ),
    );
    expect(semantics.properties.label, equals(label));
  }
}

/// Common test data
class TestData {
  static const String testImageUrl = 'https://image.tmdb.org/t/p/w500/test.jpg';
  static const String testPosterPath = '/test-poster.jpg';
  static const String testBackdropPath = '/test-backdrop.jpg';
  static const String testMovieTitle = 'Test Movie';
  static const String testTvShowTitle = 'Test TV Show';
  static const double testRating = 8.5;
  static const String testReleaseYear = '2023';

  static final List<Movie> testMovies = List.generate(
    5,
    (index) => TestUtils.createTestMovie(
      id: index + 1,
      title: 'Test Movie $index',
      posterPath: '/test-poster-$index.jpg',
    ),
  );

  static final List<TvShow> testTvShows = List.generate(
    5,
    (index) => TestUtils.createTestTvShow(
      id: index + 1,
      name: 'Test TV Show $index',
      posterPath: '/test-poster-$index.jpg',
    ),
  );
}
