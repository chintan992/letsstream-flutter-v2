import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/models/hive_adapters.dart';
import 'package:lets_stream/src/core/services/cache_service.dart';

void main() {
  late CacheService cacheService;

  setUpAll(() async {
    await Hive.initFlutter();
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(MovieAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(TvShowAdapter());
    }
  });

  setUp(() async {
    cacheService = CacheService.instance;
    await cacheService.initialize();
  });

  tearDown(() async {
    await cacheService.clearAllCache();
  });

  group('CacheService', () {
    test('should cache and retrieve movies', () async {
      final movies = [
        Movie(
          id: 1,
          title: 'Test Movie',
          overview: 'Test overview',
          popularity: 7.5,
          posterPath: '/test.jpg',
          backdropPath: '/test_backdrop.jpg',
          releaseDate: DateTime(2023, 1, 1),
          genreIds: [28, 12],
          voteAverage: 7.5,
          voteCount: 100,
        ),
      ];

      await cacheService.cacheMovies(key: 'popular', movies: movies);
      final cachedMovies = cacheService.getCachedMovies('popular');

      expect(cachedMovies, isNotNull);
      expect(cachedMovies!.length, 1);
      expect(cachedMovies[0].title, 'Test Movie');
    });

    test('should cache and retrieve TV shows', () async {
      final tvShows = [
        TvShow(
          id: 1,
          name: 'Test TV Show',
          overview: 'Test overview',
          popularity: 8.0,
          posterPath: '/test.jpg',
          backdropPath: '/test_backdrop.jpg',
          firstAirDate: DateTime(2023, 1, 1),
          genreIds: [18, 10765],
          voteAverage: 8.0,
          voteCount: 50,
        ),
      ];

      await cacheService.cacheTvShows(key: 'popular', tvShows: tvShows);
      final cachedTvShows = cacheService.getCachedTvShows('popular');

      expect(cachedTvShows, isNotNull);
      expect(cachedTvShows!.length, 1);
      expect(cachedTvShows[0].name, 'Test TV Show');
    });

    test('should clear all cache', () async {
      final movies = [
        Movie(
          id: 1,
          title: 'Test Movie',
          overview: 'Test overview',
          popularity: 7.5,
          posterPath: '/test.jpg',
          backdropPath: '/test_backdrop.jpg',
          releaseDate: DateTime(2023, 1, 1),
          voteAverage: 7.5,
          voteCount: 100,
        ),
      ];
      await cacheService.cacheMovies(key: 'popular', movies: movies);

      var cachedMovies = cacheService.getCachedMovies('popular');
      expect(cachedMovies, isNotNull);

      await cacheService.clearAllCache();
      cachedMovies = cacheService.getCachedMovies('popular');
      expect(cachedMovies, isNull);
    });

    test('should return null for non-existent cache key', () async {
      final cachedMovies = cacheService.getCachedMovies('nonexistent');
      expect(cachedMovies, isNull);
    });
  });
}
