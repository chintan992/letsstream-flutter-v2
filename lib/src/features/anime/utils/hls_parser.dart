import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:lets_stream/src/features/anime/application/models/quality_option.dart';
import 'package:lets_stream/src/features/anime/application/models/network_quality.dart'
    as models;

/// Utility class for parsing HLS (.m3u8) manifests to extract quality options.
class HlsParser {
  /// Parses an HLS manifest URL and returns available quality options.
  ///
  /// [manifestUrl] The URL to the HLS manifest (.m3u8 file).
  /// Returns a list of available quality options.
  static Future<List<QualityOption>> parseManifest(String manifestUrl) async {
    try {
      final response = await http.get(Uri.parse(manifestUrl));
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch manifest: ${response.statusCode}');
      }

      final manifest = utf8.decode(response.bodyBytes);
      return _parseManifestContent(manifest, manifestUrl);
    } catch (e) {
      throw Exception('Failed to parse HLS manifest: $e');
    }
  }

  /// Parses HLS manifest content and extracts quality options.
  static List<QualityOption> _parseManifestContent(
      String content, String baseUrl,) {
    final lines = content.split('\n');
    final qualities = <QualityOption>[];

    // Add auto quality option
    qualities.add(
      QualityOption(
        label: 'Auto',
        height: 0,
        bitrate: 0,
        url: baseUrl,
        isAuto: true,
      ),
    );

    for (int i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // Look for EXT-X-STREAM-INF lines
      if (line.startsWith('#EXT-X-STREAM-INF:')) {
        final nextLine = i + 1 < lines.length ? lines[i + 1].trim() : '';
        if (nextLine.isNotEmpty && !nextLine.startsWith('#')) {
          final quality = _parseStreamInfo(line, nextLine, baseUrl);
          if (quality != null) {
            qualities.add(quality);
          }
        }
      }
    }

    // Sort qualities by height (descending)
    qualities.sort((a, b) => b.height.compareTo(a.height));

    return qualities;
  }

  /// Parses a single stream info line and creates a quality option.
  static QualityOption? _parseStreamInfo(
      String streamInfo, String streamUrl, String baseUrl,) {
    try {
      // Extract RESOLUTION
      final resolutionMatch =
          RegExp(r'RESOLUTION=(\d+x\d+)').firstMatch(streamInfo);
      if (resolutionMatch == null) return null;

      final resolution = resolutionMatch.group(1)!;
      final dimensions = resolution.split('x');
      final height = int.parse(dimensions[1]);

      // Extract BANDWIDTH
      final bandwidthMatch = RegExp(r'BANDWIDTH=(\d+)').firstMatch(streamInfo);
      final bitrate = bandwidthMatch != null
          ? int.parse(bandwidthMatch.group(1)!) ~/ 1000
          : 0;

      // Extract CODECS (optional)
      final codecsMatch = RegExp(r'CODECS="([^"]+)"').firstMatch(streamInfo);
      final hasVideo = codecsMatch?.group(1)?.contains('avc1') ?? true;

      if (!hasVideo) return null; // Skip audio-only streams

      // Build full URL
      final fullUrl = streamUrl.startsWith('http')
          ? streamUrl
          : Uri.parse(baseUrl).resolve(streamUrl).toString();

      // Generate quality label
      String label;
      if (height >= 1080) {
        label = '1080p';
      } else if (height >= 720) {
        label = '720p';
      } else if (height >= 480) {
        label = '480p';
      } else if (height >= 360) {
        label = '360p';
      } else {
        label = '${height}p';
      }

      return QualityOption(
        label: label,
        height: height,
        bitrate: bitrate,
        url: fullUrl,
        isAuto: false,
      );
    } catch (e) {
      return null;
    }
  }

  /// Estimates network quality based on download speed.
  static Future<models.NetworkQuality> estimateNetworkQuality(
      String testUrl,) async {
    try {
      final stopwatch = Stopwatch()..start();
      final response = await http.head(Uri.parse(testUrl));
      stopwatch.stop();

      if (response.statusCode != 200) {
        return models.NetworkQuality.poor;
      }

      final contentLength = response.headers['content-length'];
      if (contentLength == null) {
        return models.NetworkQuality.unknown;
      }

      final bytes = int.parse(contentLength);
      final seconds = stopwatch.elapsedMilliseconds / 1000.0;
      final speed = (bytes * 8) / (seconds * 1000); // kbps

      if (speed >= 5000) {
        return models.NetworkQuality.excellent;
      } else if (speed >= 3000) {
        return models.NetworkQuality.good;
      } else if (speed >= 1500) {
        return models.NetworkQuality.fair;
      } else {
        return models.NetworkQuality.poor;
      }
    } catch (e) {
      return models.NetworkQuality.unknown;
    }
  }

  /// Selects the best quality option based on network conditions.
  static QualityOption selectBestQuality(
    List<QualityOption> qualities,
    models.NetworkQuality networkQuality,
  ) {
    if (qualities.isEmpty) {
      throw Exception('No quality options available');
    }

    // If auto quality is available and enabled, return it
    final autoQuality = qualities.firstWhere(
      (q) => q.isAuto,
      orElse: () => qualities.first,
    );

    if (autoQuality.isAuto) {
      return autoQuality;
    }

    // Select quality based on network conditions
    final targetHeight = networkQuality.recommendedHeight;

    // Find the closest quality to target height
    QualityOption? bestQuality;
    int minDifference = double.infinity.toInt();

    for (final quality in qualities) {
      if (quality.isAuto) continue;

      final difference = (quality.height - targetHeight).abs();
      if (difference < minDifference) {
        minDifference = difference;
        bestQuality = quality;
      }
    }

    return bestQuality ?? qualities.first;
  }
}
