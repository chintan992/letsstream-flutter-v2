import 'package:flutter/material.dart';
import 'package:lets_stream/src/shared/widgets/optimized_image.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Service for pre-fetching images to improve user experience
class ImagePrefetchService {
  static final ImagePrefetchService _instance =
      ImagePrefetchService._internal();
  factory ImagePrefetchService() => _instance;
  ImagePrefetchService._internal();

  final Set<String> _prefetchedImages = {};
  bool _isPrefetching = false;

  String _buildImageUrl(String baseUrl, String imagePath, ImageSize size) {
    final sizeSuffix = switch (size) {
      ImageSize.small => 'w154',
      ImageSize.medium => 'w342',
      ImageSize.large => 'w500',
      ImageSize.xlarge => 'w780',
      ImageSize.original => 'original',
    };
    return '$baseUrl/$sizeSuffix$imagePath';
  }

  /// Pre-fetch images for movies
  Future<void> prefetchMovieImages(
    List<Movie> movies, {
    ImageSize size = ImageSize.medium,
    int maxImages = 10,
  }) async {
    if (_isPrefetching) return;

    _isPrefetching = true;
    try {
      final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
      if (imageBaseUrl.isEmpty) return;

      final posterPaths = movies
          .take(maxImages)
          .map((movie) => movie.posterPath)
          .whereType<String>()
          .where((path) => path.isNotEmpty)
          .toList();

      await ImagePreloader.preloadPosters(
        posterPaths,
        baseUrl: imageBaseUrl,
        size: size,
      );

      // Mark images as prefetched
      for (final path in posterPaths) {
        final imageUrl = _buildImageUrl(imageBaseUrl, path, size);
        _prefetchedImages.add(imageUrl);
      }
    } finally {
      _isPrefetching = false;
    }
  }

  /// Pre-fetch images for TV shows
  Future<void> prefetchTvShowImages(
    List<TvShow> tvShows, {
    ImageSize size = ImageSize.medium,
    int maxImages = 10,
  }) async {
    if (_isPrefetching) return;

    _isPrefetching = true;
    try {
      final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
      if (imageBaseUrl.isEmpty) return;

      final posterPaths = tvShows
          .take(maxImages)
          .map((tvShow) => tvShow.posterPath)
          .whereType<String>()
          .where((path) => path.isNotEmpty)
          .toList();

      await ImagePreloader.preloadPosters(
        posterPaths,
        baseUrl: imageBaseUrl,
        size: size,
      );

      // Mark images as prefetched
      for (final path in posterPaths) {
        final imageUrl = _buildImageUrl(imageBaseUrl, path, size);
        _prefetchedImages.add(imageUrl);
      }
    } finally {
      _isPrefetching = false;
    }
  }

  /// Pre-fetch mixed content (movies and TV shows)
  Future<void> prefetchMixedContent(
    List<dynamic> items, {
    ImageSize size = ImageSize.medium,
    int maxImages = 10,
  }) async {
    if (_isPrefetching) return;

    _isPrefetching = true;
    try {
      final imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? '';
      if (imageBaseUrl.isEmpty) return;

      final posterPaths = items
          .take(maxImages)
          .map((item) {
            if (item is Movie) return item.posterPath;
            if (item is TvShow) return item.posterPath;
            return null;
          })
          .whereType<String>()
          .where((path) => path.isNotEmpty)
          .toList();

      await ImagePreloader.preloadPosters(
        posterPaths,
        baseUrl: imageBaseUrl,
        size: size,
      );

      // Mark images as prefetched
      for (final path in posterPaths) {
        final imageUrl = _buildImageUrl(imageBaseUrl, path, size);
        _prefetchedImages.add(imageUrl);
      }
    } finally {
      _isPrefetching = false;
    }
  }

  /// Check if an image has been prefetched
  bool isImagePrefetched(String imageUrl) {
    return _prefetchedImages.contains(imageUrl);
  }

  /// Clear prefetch cache
  void clearPrefetchCache() {
    _prefetchedImages.clear();
  }

  /// Get prefetch statistics
  Map<String, dynamic> getPrefetchStats() {
    return {
      'prefetchedImagesCount': _prefetchedImages.length,
      'isCurrentlyPrefetching': _isPrefetching,
    };
  }
}

/// Extension methods for easy pre-fetching
extension PrefetchExtensions on State {
  /// Pre-fetch images when widget is mounted
  void prefetchImagesOnMount(
    List<dynamic> items, {
    ImageSize size = ImageSize.medium,
    int maxImages = 10,
  }) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ImagePrefetchService().prefetchMixedContent(
        items,
        size: size,
        maxImages: maxImages,
      );
    });
  }
}
