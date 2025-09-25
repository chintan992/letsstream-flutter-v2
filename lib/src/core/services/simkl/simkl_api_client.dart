// Simkl API Client
// Based on Simkl API Blueprint v1A

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/simkl/simkl_auth_models.dart';
import '../../models/simkl/simkl_media_models.dart';
import 'simkl_config.dart';

// Model classes for API client
class SimklMediaIds {
  final int? simkl;
  final String? slug;
  final String? imdb;
  final int? tmdb;
  final int? tvdb;
  final int? mal;
  final int? anidb;
  final int? hulu;
  final int? netflix;
  final int? crunchyroll;
  final int? anilist;
  final int? kitsu;
  final int? livechart;
  final int? anisearch;
  final String? animeplanet;
  final String? traktslug;
  final String? letterboxd;

  const SimklMediaIds({
    this.simkl,
    this.slug,
    this.imdb,
    this.tmdb,
    this.tvdb,
    this.mal,
    this.anidb,
    this.hulu,
    this.netflix,
    this.crunchyroll,
    this.anilist,
    this.kitsu,
    this.livechart,
    this.anisearch,
    this.animeplanet,
    this.traktslug,
    this.letterboxd,
  });

  factory SimklMediaIds.fromJson(Map<String, dynamic> json) {
    return SimklMediaIds(
      simkl: json['simkl'] as int?,
      slug: json['slug'] as String?,
      imdb: json['imdb'] as String?,
      tmdb: json['tmdb'] as int?,
      tvdb: json['tvdb'] as int?,
      mal: json['mal'] as int?,
      anidb: json['anidb'] as int?,
      hulu: json['hulu'] as int?,
      netflix: json['netflix'] as int?,
      crunchyroll: json['crunchyroll'] as int?,
      anilist: json['anilist'] as int?,
      kitsu: json['kitsu'] as int?,
      livechart: json['livechart'] as int?,
      anisearch: json['anisearch'] as int?,
      animeplanet: json['animeplanet'] as String?,
      traktslug: json['traktslug'] as String?,
      letterboxd: json['letterboxd'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (simkl != null) 'simkl': simkl,
      if (slug != null) 'slug': slug,
      if (imdb != null) 'imdb': imdb,
      if (tmdb != null) 'tmdb': tmdb,
      if (tvdb != null) 'tvdb': tvdb,
      if (mal != null) 'mal': mal,
      if (anidb != null) 'anidb': anidb,
      if (hulu != null) 'hulu': hulu,
      if (netflix != null) 'netflix': netflix,
      if (crunchyroll != null) 'crunchyroll': crunchyroll,
      if (anilist != null) 'anilist': anilist,
      if (kitsu != null) 'kitsu': kitsu,
      if (livechart != null) 'livechart': livechart,
      if (anisearch != null) 'anisearch': anisearch,
      if (animeplanet != null) 'animeplanet': animeplanet,
      if (traktslug != null) 'traktslug': traktslug,
      if (letterboxd != null) 'letterboxd': letterboxd,
    };
  }

  @override
  String toString() => 'SimklMediaIds(simkl: $simkl, slug: $slug)';
}

/// Watchlist Item Model
class SimklWatchlistItem {
  final String? addedToWatchlistAt;
  final String? lastWatchedAt;
  final String? userRatedAt;
  final int? userRating;
  final String status;
  final String? lastWatched;
  final String? nextToWatch;
  final int? watchedEpisodesCount;
  final int? totalEpisodesCount;
  final int? notAiredEpisodesCount;
  final String? animeType;
  final dynamic show; // Can be SimklMovie, SimklShow, or SimklAnime
  final List<SimklSeason>? seasons;

  const SimklWatchlistItem({
    this.addedToWatchlistAt,
    this.lastWatchedAt,
    this.userRatedAt,
    this.userRating,
    required this.status,
    this.lastWatched,
    this.nextToWatch,
    this.watchedEpisodesCount,
    this.totalEpisodesCount,
    this.notAiredEpisodesCount,
    this.animeType,
    this.show,
    this.seasons,
  });

  factory SimklWatchlistItem.fromJson(Map<String, dynamic> json) {
    return SimklWatchlistItem(
      addedToWatchlistAt: json['added_to_watchlist_at'] as String?,
      lastWatchedAt: json['last_watched_at'] as String?,
      userRatedAt: json['user_rated_at'] as String?,
      userRating: json['user_rating'] as int?,
      status: json['status'] as String,
      lastWatched: json['last_watched'] as String?,
      nextToWatch: json['next_to_watch'] as String?,
      watchedEpisodesCount: json['watched_episodes_count'] as int?,
      totalEpisodesCount: json['total_episodes_count'] as int?,
      notAiredEpisodesCount: json['not_aired_episodes_count'] as int?,
      animeType: json['anime_type'] as String?,
      show: json['show'] as dynamic,
      seasons: json['seasons'] != null
          ? (json['seasons'] as List)
                .map((e) => SimklSeason.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (addedToWatchlistAt != null)
        'added_to_watchlist_at': addedToWatchlistAt,
      if (lastWatchedAt != null) 'last_watched_at': lastWatchedAt,
      if (userRatedAt != null) 'user_rated_at': userRatedAt,
      if (userRating != null) 'user_rating': userRating,
      'status': status,
      if (lastWatched != null) 'last_watched': lastWatched,
      if (nextToWatch != null) 'next_to_watch': nextToWatch,
      if (watchedEpisodesCount != null)
        'watched_episodes_count': watchedEpisodesCount,
      if (totalEpisodesCount != null)
        'total_episodes_count': totalEpisodesCount,
      if (notAiredEpisodesCount != null)
        'not_aired_episodes_count': notAiredEpisodesCount,
      if (animeType != null) 'anime_type': animeType,
      if (show != null) 'show': show,
      if (seasons != null) 'seasons': seasons!.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() =>
      'SimklWatchlistItem(status: $status, rating: $userRating)';
}

/// Season Model
class SimklSeason {
  final int number;
  final List<SimklEpisode> episodes;

  const SimklSeason({required this.number, required this.episodes});

  factory SimklSeason.fromJson(Map<String, dynamic> json) {
    return SimklSeason(
      number: json['number'] as int,
      episodes: (json['episodes'] as List)
          .map((e) => SimklEpisode.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'episodes': episodes.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() =>
      'SimklSeason(number: $number, episodes: ${episodes.length})';
}

/// Episode Model
class SimklEpisode {
  final int number;
  final String? title;
  final String? description;
  final String? type;
  final bool? aired;
  final String? img;
  final String? date;
  final Map<String, dynamic>? ids;

  const SimklEpisode({
    required this.number,
    this.title,
    this.description,
    this.type,
    this.aired,
    this.img,
    this.date,
    this.ids,
  });

  factory SimklEpisode.fromJson(Map<String, dynamic> json) {
    return SimklEpisode(
      number: json['number'] as int,
      title: json['title'] as String?,
      description: json['description'] as String?,
      type: json['type'] as String?,
      aired: json['aired'] as bool?,
      img: json['img'] as String?,
      date: json['date'] as String?,
      ids: json['ids'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (type != null) 'type': type,
      if (aired != null) 'aired': aired,
      if (img != null) 'img': img,
      if (date != null) 'date': date,
      if (ids != null) 'ids': ids,
    };
  }

  @override
  String toString() => 'SimklEpisode(number: $number, title: $title)';
}

/// Token Request Model
class SimklTokenRequest {
  final String code;
  final String clientId;
  final String clientSecret;
  final String redirectUri;
  final String grantType;

  const SimklTokenRequest({
    required this.code,
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
    required this.grantType,
  });

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'client_id': clientId,
      'client_secret': clientSecret,
      'redirect_uri': redirectUri,
      'grant_type': grantType,
    };
  }

  @override
  String toString() => 'SimklTokenRequest(code: $code, grantType: $grantType)';
}

/// PIN Request Model
class SimklPinRequest {
  final String clientId;
  final String? redirect;

  const SimklPinRequest({required this.clientId, this.redirect});

  Map<String, dynamic> toJson() {
    return {'client_id': clientId, if (redirect != null) 'redirect': redirect};
  }

  @override
  String toString() => 'SimklPinRequest(clientId: $clientId)';
}

/// Simkl API Client
class SimklApiClient {
  final http.Client _httpClient;

  SimklApiClient({http.Client? httpClient})
    : _httpClient = httpClient ?? http.Client();

  /// Headers required for all requests
  Map<String, String> get _defaultHeaders => {
    'Content-Type': 'application/json',
    'simkl-api-key': SimklConfig.clientId,
  };

  /// Headers for authenticated requests
  Map<String, String> _authHeaders(String accessToken) => {
    ..._defaultHeaders,
    'Authorization': 'Bearer $accessToken',
  };

  /// OAuth 2.0 Authorization URL
  Uri getAuthorizationUrl({required String redirectUri, String? state}) {
    return Uri.parse(SimklConfig.authUrl).replace(
      queryParameters: {
        'response_type': 'code',
        'client_id': SimklConfig.clientId,
        'redirect_uri': redirectUri,
        if (state != null) 'state': state,
      },
    );
  }

  /// Exchange authorization code for access token
  Future<SimklAuthResponse> exchangeCodeForToken({
    required String code,
    required String redirectUri,
    required String accessToken,
  }) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/oauth/token');
    final body = SimklTokenRequest(
      code: code,
      clientId: SimklConfig.clientId,
      clientSecret: SimklConfig.clientSecret,
      redirectUri: redirectUri,
      grantType: 'authorization_code',
    ).toJson();

    final response = await _httpClient.post(
      url,
      headers: _authHeaders(accessToken),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return SimklAuthResponse.fromJson(jsonDecode(response.body));
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// PIN Authentication - Request device code
  Future<SimklPinResponse> requestPinCode({String? redirect}) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/oauth/pin');
    final body = SimklPinRequest(
      clientId: SimklConfig.clientId,
      redirect: redirect,
    ).toJson();

    final response = await _httpClient.get(
      url.replace(queryParameters: body),
      headers: _defaultHeaders,
    );

    if (response.statusCode == 200) {
      return SimklPinResponse.fromJson(jsonDecode(response.body));
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// PIN Authentication - Check authorization status
  Future<SimklPinStatusResponse> checkPinStatus(String userCode) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/oauth/pin/$userCode');

    final response = await _httpClient.get(
      url.replace(queryParameters: {'client_id': SimklConfig.clientId}),
      headers: _defaultHeaders,
    );

    if (response.statusCode == 200) {
      return SimklPinStatusResponse.fromJson(jsonDecode(response.body));
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// Get user settings
  Future<SimklUserSettings> getUserSettings(String accessToken) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/users/settings');

    final response = await _httpClient.post(
      url,
      headers: _authHeaders(accessToken),
    );

    if (response.statusCode == 200) {
      return SimklUserSettings.fromJson(jsonDecode(response.body));
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// Get all items in user's watchlist
  Future<Map<String, List<SimklWatchlistItem>>> getAllItems({
    required String accessToken,
    String? type, // 'shows', 'movies', 'anime'
    String? status, // 'watching', 'plantowatch', 'completed', 'hold', 'dropped'
    String? dateFrom,
    String?
    extended, // 'full', 'full_anime_seasons', 'simkl_ids_only', 'ids_only'
    String? episodeWatchedAt, // 'yes'
    String? memos, // 'yes'
  }) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/sync/all-items').replace(
      path: type != null
          ? '${SimklConfig.baseUrl}/sync/all-items/$type'
          : '${SimklConfig.baseUrl}/sync/all-items',
      queryParameters: {
        if (status != null) 'status': status,
        if (dateFrom != null) 'date_from': dateFrom,
        if (extended != null) 'extended': extended,
        if (episodeWatchedAt != null) 'episode_watched_at': episodeWatchedAt,
        if (memos != null) 'memos': memos,
      },
    );

    final response = await _httpClient.get(
      url,
      headers: _authHeaders(accessToken),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data.map((key, value) {
        if (value is List) {
          return MapEntry(
            key,
            value.map((e) => SimklWatchlistItem.fromJson(e)).toList(),
          );
        }
        return MapEntry(key, <SimklWatchlistItem>[]);
      });
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// Add items to watch history
  Future<SimklSyncResponse> addToHistory({
    required String accessToken,
    List<SimklMovie>? movies,
    List<SimklShow>? shows,
    List<SimklEpisode>? episodes,
  }) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/sync/history');
    final body = <String, dynamic>{};

    if (movies != null && movies.isNotEmpty) {
      body['movies'] = movies.map((e) => e.toJson()).toList();
    }

    if (shows != null && shows.isNotEmpty) {
      body['shows'] = shows.map((e) => e.toJson()).toList();
    }

    if (episodes != null && episodes.isNotEmpty) {
      body['episodes'] = episodes.map((e) => e.toJson()).toList();
    }

    final response = await _httpClient.post(
      url,
      headers: _authHeaders(accessToken),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return SimklSyncResponse.fromJson(jsonDecode(response.body));
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// Remove items from watch history
  Future<SimklSyncResponse> removeFromHistory({
    required String accessToken,
    List<SimklMovie>? movies,
    List<SimklShow>? shows,
  }) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/sync/history/remove');
    final body = <String, dynamic>{};

    if (movies != null && movies.isNotEmpty) {
      body['movies'] = movies.map((e) => e.toJson()).toList();
    }

    if (shows != null && shows.isNotEmpty) {
      body['shows'] = shows.map((e) => e.toJson()).toList();
    }

    final response = await _httpClient.post(
      url,
      headers: _authHeaders(accessToken),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return SimklSyncResponse.fromJson(jsonDecode(response.body));
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// Get user ratings
  Future<Map<String, List<SimklRatingItem>>> getUserRatings({
    required String accessToken,
    String? type, // 'shows', 'movies', 'anime'
    String? rating, // comma-separated ratings like '8,9,10'
    String? dateFrom,
  }) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/sync/ratings').replace(
      path: type != null
          ? '${SimklConfig.baseUrl}/sync/ratings/$type'
          : '${SimklConfig.baseUrl}/sync/ratings',
      queryParameters: {
        if (rating != null) 'rating': rating,
        if (dateFrom != null) 'date_from': dateFrom,
      },
    );

    final response = await _httpClient.post(
      url,
      headers: _authHeaders(accessToken),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      return data.map((key, value) {
        if (value is List) {
          return MapEntry(
            key,
            value.map((e) => SimklRatingItem.fromJson(e)).toList(),
          );
        }
        return MapEntry(key, <SimklRatingItem>[]);
      });
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// Add ratings
  Future<SimklSyncResponse> addRatings({
    required String accessToken,
    List<SimklRatingItem>? movies,
    List<SimklRatingItem>? shows,
  }) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/sync/ratings');
    final body = <String, dynamic>{};

    if (movies != null && movies.isNotEmpty) {
      body['movies'] = movies.map((e) => e.toJson()).toList();
    }

    if (shows != null && shows.isNotEmpty) {
      body['shows'] = shows.map((e) => e.toJson()).toList();
    }

    final response = await _httpClient.post(
      url,
      headers: _authHeaders(accessToken),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return SimklSyncResponse.fromJson(jsonDecode(response.body));
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// Remove ratings
  Future<SimklSyncResponse> removeRatings({
    required String accessToken,
    List<SimklMovie>? movies,
    List<SimklShow>? shows,
  }) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/sync/ratings/remove');
    final body = <String, dynamic>{};

    if (movies != null && movies.isNotEmpty) {
      body['movies'] = movies.map((e) => e.toJson()).toList();
    }

    if (shows != null && shows.isNotEmpty) {
      body['shows'] = shows.map((e) => e.toJson()).toList();
    }

    final response = await _httpClient.post(
      url,
      headers: _authHeaders(accessToken),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return SimklSyncResponse.fromJson(jsonDecode(response.body));
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// Add items to specific watchlist
  Future<SimklSyncResponse> addToList({
    required String accessToken,
    List<SimklListItem>? movies,
    List<SimklListItem>? shows,
  }) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/sync/add-to-list');
    final body = <String, dynamic>{};

    if (movies != null && movies.isNotEmpty) {
      body['movies'] = movies.map((e) => e.toJson()).toList();
    }

    if (shows != null && shows.isNotEmpty) {
      body['shows'] = shows.map((e) => e.toJson()).toList();
    }

    final response = await _httpClient.post(
      url,
      headers: _authHeaders(accessToken),
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      return SimklSyncResponse.fromJson(jsonDecode(response.body));
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// Search for media by ID
  Future<List<SimklMediaItem>> searchById({
    int? simkl,
    int? hulu,
    int? netflix,
    int? mal,
    int? tvdb,
    String? type, // 'show', 'movie'
    String? tmdb,
    String? imdb,
    int? anidb,
    int? crunchyroll,
    int? anilist,
    int? kitsu,
    int? livechart,
    int? anisearch,
    String? animeplanet,
    String? title,
    int? year,
  }) async {
    final url = Uri.parse('${SimklConfig.baseUrl}/search/id').replace(
      queryParameters: {
        if (simkl != null) 'simkl': simkl.toString(),
        if (hulu != null) 'hulu': hulu.toString(),
        if (netflix != null) 'netflix': netflix.toString(),
        if (mal != null) 'mal': mal.toString(),
        if (tvdb != null) 'tvdb': tvdb.toString(),
        if (type != null) 'type': type,
        if (tmdb != null) 'tmdb': tmdb,
        if (imdb != null) 'imdb': imdb,
        if (anidb != null) 'anidb': anidb.toString(),
        if (crunchyroll != null) 'crunchyroll': crunchyroll.toString(),
        if (anilist != null) 'anilist': anilist.toString(),
        if (kitsu != null) 'kitsu': kitsu.toString(),
        if (livechart != null) 'livechart': livechart.toString(),
        if (anisearch != null) 'anisearch': anisearch.toString(),
        if (animeplanet != null) 'animeplanet': animeplanet,
        if (title != null) 'title': title,
        if (year != null) 'year': year.toString(),
      },
    );

    final response = await _httpClient.get(url, headers: _defaultHeaders);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      return data.map((e) => SimklMediaItem.fromJson(e)).toList();
    } else {
      throw SimklApiException.fromResponse(response);
    }
  }

  /// Close the HTTP client
  void close() {
    _httpClient.close();
  }
}

/// Sync Response Model
class SimklSyncResponse {
  final Map<String, int> added;
  final Map<String, List<dynamic>> notFound;

  const SimklSyncResponse({required this.added, required this.notFound});

  factory SimklSyncResponse.fromJson(Map<String, dynamic> json) {
    return SimklSyncResponse(
      added: Map.from(json['added'] as Map),
      notFound: Map.from(json['not_found'] as Map),
    );
  }

  Map<String, dynamic> toJson() {
    return {'added': added, 'not_found': notFound};
  }

  @override
  String toString() => 'SimklSyncResponse(added: $added, notFound: $notFound)';
}

/// Rating Item Model
class SimklRatingItem {
  final String? lastWatchedAt;
  final String? userRatedAt;
  final int userRating;
  final String status;
  final String? lastWatched;
  final String? nextToWatch;
  final dynamic show; // Can be SimklMovie, SimklShow, or SimklAnime

  const SimklRatingItem({
    this.lastWatchedAt,
    this.userRatedAt,
    required this.userRating,
    required this.status,
    this.lastWatched,
    this.nextToWatch,
    this.show,
  });

  factory SimklRatingItem.fromJson(Map<String, dynamic> json) {
    return SimklRatingItem(
      lastWatchedAt: json['last_watched_at'] as String?,
      userRatedAt: json['user_rated_at'] as String?,
      userRating: json['user_rating'] as int,
      status: json['status'] as String,
      lastWatched: json['last_watched'] as String?,
      nextToWatch: json['next_to_watch'] as String?,
      show: json['show'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (lastWatchedAt != null) 'last_watched_at': lastWatchedAt,
      if (userRatedAt != null) 'user_rated_at': userRatedAt,
      'user_rating': userRating,
      'status': status,
      if (lastWatched != null) 'last_watched': lastWatched,
      if (nextToWatch != null) 'next_to_watch': nextToWatch,
      if (show != null) 'show': show,
    };
  }

  @override
  String toString() => 'SimklRatingItem(rating: $userRating, status: $status)';
}

/// List Item Model
class SimklListItem {
  final String to;
  final String? addedAt;
  final String? watchedAt;
  final dynamic show; // Can be SimklMovie, SimklShow, or SimklAnime

  const SimklListItem({
    required this.to,
    this.addedAt,
    this.watchedAt,
    this.show,
  });

  factory SimklListItem.fromJson(Map<String, dynamic> json) {
    return SimklListItem(
      to: json['to'] as String,
      addedAt: json['added_at'] as String?,
      watchedAt: json['watched_at'] as String?,
      show: json['show'] as dynamic,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'to': to,
      if (addedAt != null) 'added_at': addedAt,
      if (watchedAt != null) 'watched_at': watchedAt,
      if (show != null) 'show': show,
    };
  }

  @override
  String toString() => 'SimklListItem(to: $to)';
}

/// Media Item Model for Search Results
class SimklMediaItem {
  final String type;
  final String title;
  final String? poster;
  final int year;
  final String? status;
  final SimklMediaIds ids;
  final int? totalEpisodes;

  const SimklMediaItem({
    required this.type,
    required this.title,
    this.poster,
    required this.year,
    this.status,
    required this.ids,
    this.totalEpisodes,
  });

  factory SimklMediaItem.fromJson(Map<String, dynamic> json) {
    return SimklMediaItem(
      type: json['type'] as String,
      title: json['title'] as String,
      poster: json['poster'] as String?,
      year: json['year'] as int,
      status: json['status'] as String?,
      ids: SimklMediaIds.fromJson(json['ids'] as Map<String, dynamic>),
      totalEpisodes: json['total_episodes'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'title': title,
      if (poster != null) 'poster': poster,
      'year': year,
      if (status != null) 'status': status,
      'ids': ids.toJson(),
      if (totalEpisodes != null) 'total_episodes': totalEpisodes,
    };
  }

  @override
  String toString() => 'SimklMediaItem(type: $type, title: $title)';
}

/// Simkl API Exception
class SimklApiException implements Exception {
  final int statusCode;
  final String message;
  final Map<String, dynamic>? responseBody;

  SimklApiException({
    required this.statusCode,
    required this.message,
    this.responseBody,
  });

  factory SimklApiException.fromResponse(http.Response response) {
    String message = 'API Error';
    Map<String, dynamic>? body;

    try {
      body = jsonDecode(response.body) as Map<String, dynamic>;
      message = body['error'] as String? ?? 'HTTP ${response.statusCode}';
    } catch (_) {
      message = 'HTTP ${response.statusCode}: ${response.reasonPhrase}';
    }

    return SimklApiException(
      statusCode: response.statusCode,
      message: message,
      responseBody: body,
    );
  }

  @override
  String toString() => 'SimklApiException($statusCode): $message';
}
