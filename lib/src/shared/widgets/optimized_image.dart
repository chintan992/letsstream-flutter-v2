import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';

enum ImageSize {
  small, // w154
  medium, // w342
  large, // w500
  xlarge, // w780
  original, // original
}

class OptimizedImage extends StatelessWidget {
  final String? imagePath;
  final ImageSize size;
  final BoxFit fit;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool enableFadeIn;
  final Duration fadeInDuration;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final Duration? cacheDuration;
  final bool enableNetworkAwareLoading;
  final bool enableProgressiveLoading;
  final bool enablePreloading;

  const OptimizedImage({
    super.key,
    required this.imagePath,
    this.size = ImageSize.medium,
    this.fit = BoxFit.cover,
    this.width,
    this.height,
    this.borderRadius,
    this.placeholder,
    this.errorWidget,
    this.enableFadeIn = true,
    this.fadeInDuration = const Duration(milliseconds: 300),
    this.memCacheWidth,
    this.memCacheHeight,
    this.cacheDuration,
    this.enableNetworkAwareLoading = true,
    this.enableProgressiveLoading = true,
    this.enablePreloading = false,
  });

  @override
  Widget build(BuildContext context) {
    final String imageBaseUrl = dotenv.env['TMDB_IMAGE_BASE_URL'] ?? 'https://image.tmdb.org/t/p';
    final String? fullImageUrl = _buildImageUrl(imageBaseUrl);

    if (fullImageUrl == null) {
      return _buildFallbackWidget(context);
    }

    // Network-aware size selection
    final effectiveSize = enableNetworkAwareLoading
        ? _getNetworkAwareSize(size)
        : size;

    final optimizedUrl = _buildImageUrlWithSize(imageBaseUrl, effectiveSize);

    Widget imageWidget;

    if (enableProgressiveLoading) {
      imageWidget = _buildProgressiveImageWidget(
        context,
        optimizedUrl,
        effectiveSize,
      );
    } else {
      imageWidget = _buildStandardImageWidget(context, optimizedUrl);
    }

    // Preload if enabled
    if (enablePreloading) {
      _preloadImage(optimizedUrl);
    }

    if (borderRadius != null) {
      imageWidget = ClipRRect(borderRadius: borderRadius!, child: imageWidget);
    }

    return imageWidget;
  }

  String? _buildImageUrl(String baseUrl) {
    if (imagePath == null || imagePath!.isEmpty) return null;

    final sizeSuffix = switch (size) {
      ImageSize.small => 'w154',
      ImageSize.medium => 'w342',
      ImageSize.large => 'w500',
      ImageSize.xlarge => 'w780',
      ImageSize.original => 'original',
    };

    return '$baseUrl/$sizeSuffix$imagePath';
  }

  String _buildImageUrlWithSize(String baseUrl, ImageSize imageSize) {
    final sizeSuffix = switch (imageSize) {
      ImageSize.small => 'w154',
      ImageSize.medium => 'w342',
      ImageSize.large => 'w500',
      ImageSize.xlarge => 'w780',
      ImageSize.original => 'original',
    };

    return '$baseUrl/$sizeSuffix$imagePath';
  }

  ImageSize _getNetworkAwareSize(ImageSize baseSize) {
    // For now, use a simple heuristic
    // In a real implementation, you could check connectivity here
    // and adjust image size accordingly

    // Reduce image quality on smaller screens to save bandwidth
    return baseSize;
  }

  ImageSize _getSmallerSize(ImageSize size) {
    return switch (size) {
      ImageSize.small => ImageSize.small,
      ImageSize.medium => ImageSize.small,
      ImageSize.large => ImageSize.medium,
      ImageSize.xlarge => ImageSize.large,
      ImageSize.original => ImageSize.xlarge,
    };
  }

  Widget _buildProgressiveImageWidget(
    BuildContext context,
    String url,
    ImageSize effectiveSize,
  ) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      memCacheWidth: memCacheWidth ?? _getOptimalMemCacheWidth(context),
      memCacheHeight: memCacheHeight ?? _getOptimalMemCacheHeight(context),
      maxWidthDiskCache: _getMaxDiskCacheWidth(context),
      maxHeightDiskCache: _getMaxDiskCacheHeight(context),
      fadeInDuration: enableFadeIn ? fadeInDuration : Duration.zero,
      fadeOutDuration: enableFadeIn
          ? const Duration(milliseconds: 100)
          : Duration.zero,
      placeholder: (context, url) =>
          placeholder ?? _buildProgressivePlaceholder(context, effectiveSize),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildErrorWidget(context),
      httpHeaders: _getOptimizedHeaders(),
    );
  }

  Widget _buildStandardImageWidget(BuildContext context, String url) {
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      width: width,
      height: height,
      memCacheWidth: memCacheWidth ?? _getOptimalMemCacheWidth(context),
      memCacheHeight: memCacheHeight ?? _getOptimalMemCacheHeight(context),
      maxWidthDiskCache: _getMaxDiskCacheWidth(context),
      maxHeightDiskCache: _getMaxDiskCacheHeight(context),
      fadeInDuration: enableFadeIn ? fadeInDuration : Duration.zero,
      fadeOutDuration: enableFadeIn
          ? const Duration(milliseconds: 100)
          : Duration.zero,
      placeholder: (context, url) => placeholder ?? _buildPlaceholder(),
      errorWidget: (context, url, error) =>
          errorWidget ?? _buildErrorWidget(context),
      httpHeaders: _getOptimizedHeaders(),
    );
  }

  Map<String, String> _getOptimizedHeaders() {
    return const {
      'User-Agent': 'LetsStream/1.0.0',
      'Accept': 'image/webp,image/avif,image/*,*/*;q=0.8',
      'Accept-Encoding': 'gzip, deflate, br',
    };
  }

  Widget _buildProgressivePlaceholder(
    BuildContext context,
    ImageSize effectiveSize,
  ) {
    // Start with a very small placeholder, then progressively load higher quality
    final smallUrl = _buildImageUrlWithSize(
      dotenv.env['TMDB_IMAGE_BASE_URL'] ?? 'https://image.tmdb.org/t/p',
      _getSmallerSize(effectiveSize),
    );

    return CachedNetworkImage(
      imageUrl: smallUrl,
      fit: fit,
      width: width,
      height: height,
      placeholder: (context, url) => _buildPlaceholder(),
      errorWidget: (context, url, error) => _buildPlaceholder(),
      httpHeaders: _getOptimizedHeaders(),
    );
  }

  void _preloadImage(String url) {
    // Preload the image in the background
    // Note: CachedNetworkImageProvider handles caching automatically
    CachedNetworkImageProvider(url, headers: _getOptimizedHeaders());
  }

  int? _getOptimalMemCacheWidth(BuildContext context) {
    if (width != null && width!.isFinite) {
      final devicePixelRatio = View.of(context).devicePixelRatio;
      final result = width! * devicePixelRatio;
      if (result.isFinite) {
        return result.round();
      }
    }
    return null;
  }

  int? _getOptimalMemCacheHeight(BuildContext context) {
    if (height != null && height!.isFinite) {
      final devicePixelRatio = View.of(context).devicePixelRatio;
      final result = height! * devicePixelRatio;
      if (result.isFinite) {
        return result.round();
      }
    }
    return null;
  }

  int? _getMaxDiskCacheWidth(BuildContext context) {
    final devicePixelRatio = View.of(context).devicePixelRatio;
    if (!devicePixelRatio.isFinite) return null;

    return switch (size) {
      ImageSize.small => (154 * devicePixelRatio).round(),
      ImageSize.medium => (342 * devicePixelRatio).round(),
      ImageSize.large => (500 * devicePixelRatio).round(),
      ImageSize.xlarge => (780 * devicePixelRatio).round(),
      ImageSize.original => null, // No limit for original
    };
  }

  int? _getMaxDiskCacheHeight(BuildContext context) {
    final devicePixelRatio = View.of(context).devicePixelRatio;
    if (!devicePixelRatio.isFinite) return null;

    return switch (size) {
      ImageSize.small =>
        (231 * devicePixelRatio).round(), // 154 * 1.5 for poster ratio
      ImageSize.medium => (513 * devicePixelRatio).round(), // 342 * 1.5
      ImageSize.large => (750 * devicePixelRatio).round(), // 500 * 1.5
      ImageSize.xlarge => (1170 * devicePixelRatio).round(), // 780 * 1.5
      ImageSize.original => null,
    };
  }

  Widget _buildPlaceholder() {
    return ShimmerBox(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
    );
  }

  Widget _buildErrorWidget(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(
        child: Icon(Icons.broken_image_outlined, color: Colors.grey),
      ),
    );
  }

  Widget _buildFallbackWidget(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height ?? double.infinity,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: const Center(
        child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
      ),
    );
  }
}

// Convenience widget for poster images
class PosterImage extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool enableProgressiveLoading;
  final bool enablePreloading;

  const PosterImage({
    super.key,
    required this.imagePath,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.enableProgressiveLoading = true,
    this.enablePreloading = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = OptimizedImage(
      imagePath: imagePath,
      size: ImageSize.medium,
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(8),
      fit: BoxFit.cover,
      enableProgressiveLoading: enableProgressiveLoading,
      enablePreloading: enablePreloading,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.circular(8),
          onTap: onTap,
          child: imageWidget,
        ),
      );
    }

    return imageWidget;
  }
}

// Convenience widget for backdrop images
class BackdropImage extends StatelessWidget {
  final String? imagePath;
  final VoidCallback? onTap;
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final bool enableProgressiveLoading;
  final bool enablePreloading;

  const BackdropImage({
    super.key,
    required this.imagePath,
    this.onTap,
    this.width,
    this.height,
    this.borderRadius,
    this.enableProgressiveLoading = true,
    this.enablePreloading = false,
  });

  @override
  Widget build(BuildContext context) {
    final imageWidget = OptimizedImage(
      imagePath: imagePath,
      size: ImageSize.xlarge,
      width: width,
      height: height,
      borderRadius: borderRadius ?? BorderRadius.circular(12),
      fit: BoxFit.cover,
      enableProgressiveLoading: enableProgressiveLoading,
      enablePreloading: enablePreloading,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        child: InkWell(
          borderRadius: borderRadius ?? BorderRadius.circular(12),
          onTap: onTap,
          child: imageWidget,
        ),
      );
    }

    return imageWidget;
  }
}

// Utility class for preloading images
class ImagePreloader {
  static final Map<String, bool> _preloadedImages = {};

  /// Preload a single image
  static Future<void> preloadImage(
    String imageUrl, {
    Map<String, String>? headers,
  }) async {
    if (_preloadedImages.containsKey(imageUrl)) return;

    try {
      CachedNetworkImageProvider(
        imageUrl,
        headers: headers ?? _getDefaultHeaders(),
      ).resolve(ImageConfiguration.empty);
      _preloadedImages[imageUrl] = true;
    } catch (e) {
      // Ignore preloading errors
    }
  }

  /// Preload multiple images concurrently
  static Future<void> preloadImages(
    List<String> imageUrls, {
    Map<String, String>? headers,
  }) async {
    final futures = imageUrls.map((url) => preloadImage(url, headers: headers));
    await Future.wait(futures);
  }

  /// Preload images for a list of items with poster paths
  static Future<void> preloadPosters(
    List<String?> posterPaths, {
    required String baseUrl,
    ImageSize size = ImageSize.medium,
    Map<String, String>? headers,
  }) async {
    final imageUrls = posterPaths
        .where((path) => path != null && path.isNotEmpty)
        .map((path) => _buildImageUrl(baseUrl, path!, size))
        .toList();

    await preloadImages(imageUrls, headers: headers ?? _getDefaultHeaders());
  }

  static String _buildImageUrl(
    String baseUrl,
    String imagePath,
    ImageSize size,
  ) {
    final sizeSuffix = switch (size) {
      ImageSize.small => 'w154',
      ImageSize.medium => 'w342',
      ImageSize.large => 'w500',
      ImageSize.xlarge => 'w780',
      ImageSize.original => 'original',
    };
    return '$baseUrl/$sizeSuffix$imagePath';
  }

  static Map<String, String> _getDefaultHeaders() {
    return const {
      'User-Agent': 'LetsStream/1.0.0',
      'Accept': 'image/webp,image/avif,image/*,*/*;q=0.8',
      'Accept-Encoding': 'gzip, deflate, br',
    };
  }

  /// Clear preloaded images cache
  static void clearCache() {
    _preloadedImages.clear();
  }
}
