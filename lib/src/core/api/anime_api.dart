import 'package:dio/dio.dart';
import 'package:lets_stream/src/core/models/anime/anime_search_result.dart';
import 'package:lets_stream/src/core/models/anime/anime_info.dart';
import 'package:lets_stream/src/core/models/anime/anime_episode.dart';
import 'package:lets_stream/src/core/models/anime/anime_server.dart';
import 'package:lets_stream/src/core/models/anime/anime_stream.dart';

/// API client for the Anime API.
///
/// This class handles all communication with the Anime API endpoints
/// for searching, retrieving anime information, episodes, servers, and streams.
class AnimeApi {
  /// The HTTP client used for making API requests.
  final Dio _dio;

  /// The base URL for the Anime API.
  static const String baseUrl = 'https://anime-api-test-one.vercel.app/api';

  /// Creates a new AnimeApi instance.
  ///
  /// [_dio] The HTTP client to use for API requests.
  AnimeApi(this._dio);

  /// Searches for anime by keyword.
  ///
  /// [keyword] The search keyword (anime title).
  ///
  /// Returns a list of anime search results matching the keyword.
  /// Throws an [Exception] if the request fails.
  Future<List<AnimeSearchResult>> searchAnime(String keyword) async {
    try {
      final response = await _dio.get(
        '$baseUrl/search',
        queryParameters: {'keyword': keyword},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to search anime: ${response.statusCode}');
      }

      final data = response.data;
      if (!data['success']) {
        throw Exception('API returned success: false');
      }

      final results = data['results'] as Map<String, dynamic>;
      final animeData = results['data'] as List<dynamic>;

      return animeData
          .map((json) => AnimeSearchResult.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to search anime: $e');
    }
  }

  /// Gets detailed information about an anime by its ID.
  ///
  /// [animeId] The unique identifier for the anime.
  ///
  /// Returns detailed anime information including seasons and metadata.
  /// Throws an [Exception] if the request fails.
  Future<AnimeInfo> getAnimeInfo(String animeId) async {
    try {
      final response = await _dio.get(
        '$baseUrl/info',
        queryParameters: {'id': animeId},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get anime info: ${response.statusCode}');
      }

      final data = response.data;
      if (!data['success']) {
        throw Exception('API returned success: false');
      }

      final results = data['results'] as Map<String, dynamic>;
      return AnimeInfo.fromJson(results);
    } catch (e) {
      throw Exception('Failed to get anime info: $e');
    }
  }

  /// Gets the list of episodes for an anime.
  ///
  /// [animeId] The unique identifier for the anime.
  ///
  /// Returns a list of episodes with their details.
  /// Throws an [Exception] if the request fails.
  Future<List<AnimeEpisode>> getEpisodes(String animeId) async {
    try {
      final response = await _dio.get('$baseUrl/episodes/$animeId');

      if (response.statusCode != 200) {
        throw Exception('Failed to get episodes: ${response.statusCode}');
      }

      final data = response.data;
      if (!data['success']) {
        throw Exception('API returned success: false');
      }

      final results = data['results'] as List<dynamic>;
      
      // Find the episodes array in the results
      List<dynamic> episodesData;
      if (results.isNotEmpty && results.first is Map<String, dynamic>) {
        final firstResult = results.first as Map<String, dynamic>;
        episodesData = firstResult['episodes'] as List<dynamic>;
      } else {
        episodesData = results;
      }

      return episodesData
          .map((json) => AnimeEpisode.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get episodes: $e');
    }
  }

  /// Gets available servers for an episode.
  ///
  /// [episodeId] The unique identifier for the episode.
  ///
  /// Returns a list of available servers (sub/dub) for the episode.
  /// Throws an [Exception] if the request fails.
  Future<List<AnimeServer>> getServers(String episodeId) async {
    try {
      final response = await _dio.get('$baseUrl/servers/$episodeId');

      if (response.statusCode != 200) {
        throw Exception('Failed to get servers: ${response.statusCode}');
      }

      final data = response.data;
      if (!data['success']) {
        throw Exception('API returned success: false');
      }

      final results = data['results'] as List<dynamic>;
      return results
          .map((json) => AnimeServer.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get servers: $e');
    }
  }

  /// Gets the streaming link for an episode from a specific server.
  ///
  /// [episodeId] The unique identifier for the episode.
  /// [serverId] The server ID to use for streaming.
  /// [type] The type of stream ("sub" or "dub").
  ///
  /// Returns streaming information including HLS URL, subtitles, and metadata.
  /// Throws an [Exception] if the request fails.
  Future<AnimeStream> getStream(String episodeId, String serverId, String type) async {
    try {
      final response = await _dio.get(
        '$baseUrl/stream',
        queryParameters: {
          'id': episodeId,
          'server': serverId,
          'type': type,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get stream: ${response.statusCode}');
      }

      final data = response.data;
      if (!data['success']) {
        throw Exception('API returned success: false');
      }

      final results = data['results'] as Map<String, dynamic>;
      return AnimeStream.fromJson(results);
    } catch (e) {
      throw Exception('Failed to get stream: $e');
    }
  }

  /// Gets the fallback streaming link for an episode.
  ///
  /// This is used as a backup when the primary stream fails.
  ///
  /// [episodeId] The unique identifier for the episode.
  /// [serverId] The server ID to use for streaming.
  /// [type] The type of stream ("sub" or "dub").
  ///
  /// Returns streaming information including HLS URL and metadata.
  /// Throws an [Exception] if the request fails.
  Future<AnimeStream> getStreamFallback(String episodeId, String serverId, String type) async {
    try {
      final response = await _dio.get(
        '$baseUrl/stream/fallback',
        queryParameters: {
          'id': episodeId,
          'server': serverId,
          'type': type,
        },
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get fallback stream: ${response.statusCode}');
      }

      final data = response.data;
      if (!data['success']) {
        throw Exception('API returned success: false');
      }

      final results = data['results'] as Map<String, dynamic>;
      return AnimeStream.fromJson(results);
    } catch (e) {
      throw Exception('Failed to get fallback stream: $e');
    }
  }

  /// Gets anime suggestions based on a keyword.
  ///
  /// [keyword] The search keyword.
  ///
  /// Returns a list of anime suggestions for autocomplete.
  /// Throws an [Exception] if the request fails.
  Future<List<AnimeSearchResult>> getSearchSuggestions(String keyword) async {
    try {
      final response = await _dio.get(
        '$baseUrl/search/suggest',
        queryParameters: {'keyword': keyword},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to get search suggestions: ${response.statusCode}');
      }

      final data = response.data;
      if (!data['success']) {
        throw Exception('API returned success: false');
      }

      final results = data['results'] as List<dynamic>;
      return results
          .map((json) => AnimeSearchResult.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception('Failed to get search suggestions: $e');
    }
  }

  /// Gets a random anime.
  ///
  /// Returns detailed information about a random anime.
  /// Throws an [Exception] if the request fails.
  Future<AnimeInfo> getRandomAnime() async {
    try {
      final response = await _dio.get('$baseUrl/random');

      if (response.statusCode != 200) {
        throw Exception('Failed to get random anime: ${response.statusCode}');
      }

      final data = response.data;
      if (!data['success']) {
        throw Exception('API returned success: false');
      }

      final results = data['results'] as Map<String, dynamic>;
      return AnimeInfo.fromJson(results);
    } catch (e) {
      throw Exception('Failed to get random anime: $e');
    }
  }
}
