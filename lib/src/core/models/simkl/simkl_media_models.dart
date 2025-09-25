// Simkl Media Models
// Based on Simkl API Blueprint v1A

/// Simkl Media IDs
class SimklMediaIds {
  final int? simkl;
  final String? slug;
  final int? tvdb;
  final String? imdb;
  final int? tmdb;
  final int? mal;
  final int? anidb;
  final int? anilist;
  final int? kitsu;
  final int? livechart;
  final int? anisearch;
  final String? animeplanet;
  final int? hulu;
  final int? netflix;
  final int? crunchyroll;
  final String? offen;
  final String? zap2it;
  final String? offjp;
  final String? allcin;
  final String? wikien;
  final String? anfo;

  const SimklMediaIds({
    this.simkl,
    this.slug,
    this.tvdb,
    this.imdb,
    this.tmdb,
    this.mal,
    this.anidb,
    this.anilist,
    this.kitsu,
    this.livechart,
    this.anisearch,
    this.animeplanet,
    this.hulu,
    this.netflix,
    this.crunchyroll,
    this.offen,
    this.zap2it,
    this.offjp,
    this.allcin,
    this.wikien,
    this.anfo,
  });

  factory SimklMediaIds.fromJson(Map<String, dynamic> json) {
    return SimklMediaIds(
      simkl: json['simkl'] as int?,
      slug: json['slug'] as String?,
      tvdb: json['tvdb'] as int?,
      imdb: json['imdb'] as String?,
      tmdb: json['tmdb'] as int?,
      mal: json['mal'] as int?,
      anidb: json['anidb'] as int?,
      anilist: json['anilist'] as int?,
      kitsu: json['kitsu'] as int?,
      livechart: json['livechart'] as int?,
      anisearch: json['anisearch'] as int?,
      animeplanet: json['animeplanet'] as String?,
      hulu: json['hulu'] as int?,
      netflix: json['netflix'] as int?,
      crunchyroll: json['crunchyroll'] as int?,
      offen: json['offen'] as String?,
      zap2it: json['zap2it'] as String?,
      offjp: json['offjp'] as String?,
      allcin: json['allcin'] as String?,
      wikien: json['wikien'] as String?,
      anfo: json['anfo'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (simkl != null) 'simkl': simkl,
      if (slug != null) 'slug': slug,
      if (tvdb != null) 'tvdb': tvdb,
      if (imdb != null) 'imdb': imdb,
      if (tmdb != null) 'tmdb': tmdb,
      if (mal != null) 'mal': mal,
      if (anidb != null) 'anidb': anidb,
      if (anilist != null) 'anilist': anilist,
      if (kitsu != null) 'kitsu': kitsu,
      if (livechart != null) 'livechart': livechart,
      if (anisearch != null) 'anisearch': anisearch,
      if (animeplanet != null) 'animeplanet': animeplanet,
      if (hulu != null) 'hulu': hulu,
      if (netflix != null) 'netflix': netflix,
      if (crunchyroll != null) 'crunchyroll': crunchyroll,
      if (offen != null) 'offen': offen,
      if (zap2it != null) 'zap2it': zap2it,
      if (offjp != null) 'offjp': offjp,
      if (allcin != null) 'allcin': allcin,
      if (wikien != null) 'wikien': wikien,
      if (anfo != null) 'anfo': anfo,
    };
  }

  @override
  String toString() => 'SimklMediaIds(simkl: $simkl, slug: $slug)';
}

/// Simkl Movie
class SimklMovie {
  final String? title;
  final int? year;
  final SimklMediaIds ids;

  const SimklMovie({this.title, this.year, required this.ids});

  factory SimklMovie.fromJson(Map<String, dynamic> json) {
    return SimklMovie(
      title: json['title'] as String?,
      year: json['year'] as int?,
      ids: SimklMediaIds.fromJson(json['ids'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (year != null) 'year': year,
      'ids': ids.toJson(),
    };
  }

  @override
  String toString() => 'SimklMovie(title: $title, year: $year)';
}

/// Simkl Show
class SimklShow {
  final String? title;
  final int? year;
  final SimklMediaIds ids;
  final List<SimklSeason>? seasons;

  const SimklShow({this.title, this.year, required this.ids, this.seasons});

  factory SimklShow.fromJson(Map<String, dynamic> json) {
    return SimklShow(
      title: json['title'] as String?,
      year: json['year'] as int?,
      ids: SimklMediaIds.fromJson(json['ids'] as Map<String, dynamic>),
      seasons: json['seasons'] != null
          ? (json['seasons'] as List<dynamic>)
                .map((e) => SimklSeason.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (year != null) 'year': year,
      'ids': ids.toJson(),
      if (seasons != null) 'seasons': seasons!.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() => 'SimklShow(title: $title, year: $year)';
}

/// Simkl Anime
class SimklAnime {
  final String? title;
  final int? year;
  final SimklMediaIds ids;
  final String? animeType;
  final List<SimklEpisode>? episodes;

  const SimklAnime({
    this.title,
    this.year,
    required this.ids,
    this.animeType,
    this.episodes,
  });

  factory SimklAnime.fromJson(Map<String, dynamic> json) {
    return SimklAnime(
      title: json['title'] as String?,
      year: json['year'] as int?,
      ids: SimklMediaIds.fromJson(json['ids'] as Map<String, dynamic>),
      animeType: json['anime_type'] as String?,
      episodes: json['episodes'] != null
          ? (json['episodes'] as List<dynamic>)
                .map((e) => SimklEpisode.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (title != null) 'title': title,
      if (year != null) 'year': year,
      'ids': ids.toJson(),
      if (animeType != null) 'anime_type': animeType,
      if (episodes != null)
        'episodes': episodes!.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() =>
      'SimklAnime(title: $title, year: $year, type: $animeType)';
}

/// Simkl Episode
class SimklEpisode {
  final String? watchedAt;
  final SimklMediaIds ids;
  final int? season;
  final int? number;
  final String? title;
  final String? description;
  final String? img;
  final String? date;
  final bool? aired;

  const SimklEpisode({
    this.watchedAt,
    required this.ids,
    this.season,
    this.number,
    this.title,
    this.description,
    this.img,
    this.date,
    this.aired,
  });

  factory SimklEpisode.fromJson(Map<String, dynamic> json) {
    return SimklEpisode(
      watchedAt: json['watched_at'] as String?,
      ids: SimklMediaIds.fromJson(json['ids'] as Map<String, dynamic>),
      season: json['season'] as int?,
      number: json['number'] as int?,
      title: json['title'] as String?,
      description: json['description'] as String?,
      img: json['img'] as String?,
      date: json['date'] as String?,
      aired: json['aired'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (watchedAt != null) 'watched_at': watchedAt,
      'ids': ids.toJson(),
      if (season != null) 'season': season,
      if (number != null) 'number': number,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (img != null) 'img': img,
      if (date != null) 'date': date,
      if (aired != null) 'aired': aired,
    };
  }

  @override
  String toString() => 'SimklEpisode(season: $season, number: $number)';
}

/// Simkl Season
class SimklSeason {
  final int number;
  final List<SimklEpisode>? episodes;

  const SimklSeason({required this.number, this.episodes});

  factory SimklSeason.fromJson(Map<String, dynamic> json) {
    return SimklSeason(
      number: json['number'] as int,
      episodes: json['episodes'] != null
          ? (json['episodes'] as List<dynamic>)
                .map((e) => SimklEpisode.fromJson(e))
                .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      if (episodes != null)
        'episodes': episodes!.map((e) => e.toJson()).toList(),
    };
  }

  @override
  String toString() => 'SimklSeason(number: $number)';
}

/// Simkl Watchlist Item
class SimklWatchlistItem {
  final String? addedToWatchlistAt;
  final String? lastWatchedAt;
  final String? userRatedAt;
  final String? userRating;
  final String status;
  final String? lastWatched;
  final String? nextToWatch;
  final int? watchedEpisodesCount;
  final int? totalEpisodesCount;
  final int? notAiredEpisodesCount;
  final String? animeType;
  final dynamic show; // Can be SimklMovie, SimklShow, or SimklAnime

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
  });

  factory SimklWatchlistItem.fromJson(Map<String, dynamic> json) {
    return SimklWatchlistItem(
      addedToWatchlistAt: json['added_to_watchlist_at'] as String?,
      lastWatchedAt: json['last_watched_at'] as String?,
      userRatedAt: json['user_rated_at'] as String?,
      userRating: json['user_rating'] as String?,
      status: json['status'] as String,
      lastWatched: json['last_watched'] as String?,
      nextToWatch: json['next_to_watch'] as String?,
      watchedEpisodesCount: json['watched_episodes_count'] as int?,
      totalEpisodesCount: json['total_episodes_count'] as int?,
      notAiredEpisodesCount: json['not_aired_episodes_count'] as int?,
      animeType: json['anime_type'] as String?,
      show: json['show'] as dynamic,
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
    };
  }

  @override
  String toString() =>
      'SimklWatchlistItem(status: $status, rating: $userRating)';
}

/// Simkl Watchlist Status Enum
enum SimklWatchlistStatus { watching, plantowatch, completed, hold, dropped }

/// Simkl Anime Type Enum
enum SimklAnimeType { tv, movie, special, ova, ona, music }
