import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';
import 'package:lets_stream/src/core/models/tmdb_response.dart';
import 'package:lets_stream/src/core/models/video.dart';
import 'package:lets_stream/src/core/models/cast_member.dart';
import 'package:lets_stream/src/core/models/season.dart';
import 'package:lets_stream/src/core/models/season_detail.dart';
import 'package:lets_stream/src/core/models/episode.dart';

class TmdbApi {
  final Dio _dio = Dio();
  final String _baseUrl = dotenv.env['TMDB_BASE_URL'] ?? 'https://api.themoviedb.org/3';
  final String _apiKey = dotenv.env['TMDB_API_KEY'] ?? '';

  static TmdbApi? _instance;
  static TmdbApi get instance {
    _instance ??= TmdbApi();
    return _instance!;
  }

  // Helper to GET with api_key
  Future<Response<dynamic>> _get(String path, {Map<String, dynamic>? query}) {
    final qp = {'api_key': _apiKey, if (query != null) ...query};
    return _dio.get('$_baseUrl$path', queryParameters: qp);
  }

  Future<List<Movie>> getTrendingMovies({int page = 1}) async {
    try {
      final response = await _get('/trending/movie/day', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<Movie>> getNowPlayingMovies({int page = 1}) async {
    try {
      final response = await _get('/movie/now_playing', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<Movie>> getPopularMovies({int page = 1}) async {
    try {
      final response = await _get('/movie/popular', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<Movie>> getTopRatedMovies({int page = 1}) async {
    try {
      final response = await _get('/movie/top_rated', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<Movie>> getMoviesByGenre(int genreId, {int page = 1}) async {
    try {
      final response = await _get('/discover/movie', query: {
        'with_genres': '$genreId',
        'page': page,
        'sort_by': 'popularity.desc',
      });
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Movie>> getMoviesByGenres(List<int> genreIds, {int page = 1}) async {
    try {
      final response = await _get('/discover/movie', query: {
        'with_genres': genreIds.join(','),
        'page': page,
        'sort_by': 'popularity.desc',
      });
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TvShow>> getTrendingTvShows({int page = 1}) async {
    try {
      final response = await _get('/trending/tv/day', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<TvShow>> getAiringTodayTvShows({int page = 1}) async {
    try {
      final response = await _get('/tv/airing_today', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<TvShow>> getPopularTvShows({int page = 1}) async {
    try {
      final response = await _get('/tv/popular', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<TvShow>> getTopRatedTvShows({int page = 1}) async {
    try {
      final response = await _get('/tv/top_rated', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      // Handle error appropriately
      rethrow;
    }
  }

  Future<List<TvShow>> getTvByGenre(int genreId, {int page = 1}) async {
    try {
      final response = await _get('/discover/tv', query: {
        'with_genres': '$genreId',
        'page': page,
        'sort_by': 'popularity.desc',
      });
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TvShow>> getTvByGenres(List<int> genreIds, {int page = 1}) async {
    try {
      final response = await _get('/discover/tv', query: {
        'with_genres': genreIds.join(','),
        'page': page,
        'sort_by': 'popularity.desc',
      });
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  // Anime discovery (genre 16)
  Future<List<Movie>> getAnimeMovies({int page = 1}) async {
    try {
      final response = await _get('/discover/movie', query: {
        'with_genres': '16',
        'sort_by': 'popularity.desc',
        'page': page,
      });
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TvShow>> getAnimeTvShows({int page = 1}) async {
    try {
      final response = await _get('/discover/tv', query: {
        'with_genres': '16',
        'sort_by': 'popularity.desc',
        'page': page,
      });
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  // Search
  Future<List<Movie>> searchMovies(String query, {int page = 1}) async {
    try {
      final response = await _get('/search/movie', query: {'query': query, 'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TvShow>> searchTvShows(String query, {int page = 1}) async {
    try {
      final response = await _get('/search/tv', query: {'query': query, 'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  // Similar and videos
  Future<List<Movie>> getSimilarMovies(int movieId, {int page = 1}) async {
    try {
      final response = await _get('/movie/$movieId/similar', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => Movie.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TvShow>> getSimilarTvShows(int tvId, {int page = 1}) async {
    try {
      final response = await _get('/tv/$tvId/similar', query: {'page': page});
      final tmdbResponse = TmdbResponse.fromJson(
        response.data as Map<String, dynamic>,
        (json) => TvShow.fromJson(json),
      );
      return tmdbResponse.results;
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Video>> getMovieVideos(int movieId) async {
    try {
      final response = await _get('/movie/$movieId/videos');
      final results = (response.data['results'] as List?) ?? [];
      return results.map((e) => Video.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Video>> getTvVideos(int tvId) async {
    try {
      final response = await _get('/tv/$tvId/videos');
      final results = (response.data['results'] as List?) ?? [];
      return results.map((e) => Video.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CastMember>> getMovieCredits(int movieId) async {
    try {
      final response = await _get('/movie/$movieId/credits');
      final cast = (response.data['cast'] as List?) ?? [];
      return cast.map((e) => CastMember.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<List<CastMember>> getTvCredits(int tvId) async {
    try {
      final response = await _get('/tv/$tvId/credits');
      final cast = (response.data['cast'] as List?) ?? [];
      return cast.map((e) => CastMember.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // TV details with seasons
  Future<List<SeasonSummary>> getTvSeasons(int tvId) async {
    try {
      // append_to_response=seasons is not supported by TMDB; seasons are in TV details
      final response = await _get('/tv/$tvId');
      final seasons = (response.data['seasons'] as List?) ?? [];
      return seasons.map((e) => SeasonSummary.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Episodes for a specific season
  Future<List<EpisodeSummary>> getSeasonEpisodes(int tvId, int seasonNumber) async {
    try {
      final response = await _get('/tv/$tvId/season/$seasonNumber');
      final episodes = (response.data['episodes'] as List?) ?? [];
      return episodes.map((e) => EpisodeSummary.fromJson(e as Map<String, dynamic>)).toList();
    } catch (e) {
      rethrow;
    }
  }

  Future<SeasonDetail> getSeasonDetails(int tvId, int seasonNumber) async {
    try {
      final response = await _get('/tv/$tvId/season/$seasonNumber');
      return SeasonDetail.fromJson(response.data as Map<String, dynamic>);
    } catch (e) {
      rethrow;
    }
  }
}
