
/// Represents detailed information about an anime.
///
/// This model encapsulates comprehensive anime information including detailed data,
/// seasons, related anime, and recommendations.
class AnimeInfo {
  /// The detailed anime data.
  final AnimeData data;

  /// The list of seasons available for this anime.
  final List<AnimeSeason> seasons;

  /// Creates a new AnimeInfo instance.
  const AnimeInfo({
    required this.data,
    required this.seasons,
  });

  /// Creates an AnimeInfo instance from a JSON map.
  ///
  /// [json] A map containing detailed anime data from the Anime API.
  factory AnimeInfo.fromJson(Map<String, dynamic> json) {
    return AnimeInfo(
      data: AnimeData.fromJson(json['data'] as Map<String, dynamic>),
      seasons: _parseSeasons(json['seasons']),
    );
  }

  /// Helper method to parse seasons data that might come as List or Map.
  static List<AnimeSeason> _parseSeasons(dynamic seasonsData) {
    if (seasonsData is List) {
      return seasonsData
          .map((seasonJson) => AnimeSeason.fromJson(seasonJson as Map<String, dynamic>))
          .toList();
    } else if (seasonsData is Map<String, dynamic>) {
      // If seasons is a map, try to extract a list from it
      // Check common keys that might contain the seasons list
      final possibleKeys = ['data', 'seasons', 'list', 'items'];
      for (final key in possibleKeys) {
        final value = seasonsData[key];
        if (value is List) {
          return value
              .map((seasonJson) => AnimeSeason.fromJson(seasonJson as Map<String, dynamic>))
              .toList();
        }
      }
      // If no list found, return empty list
      return [];
    }
    return [];
  }

  /// Converts the AnimeInfo instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'data': data.toJson(),
      'seasons': seasons.map((season) => season.toJson()).toList(),
    };
  }

  /// Returns the total number of episodes across all seasons.
  int get totalEpisodes {
    return seasons.fold(0, (total, season) => total + (season.episodeCount ?? 0));
  }

  /// Returns true if this anime has multiple seasons.
  bool get hasMultipleSeasons => seasons.length > 1;

  /// Returns the main season (usually the first one with the most episodes).
  AnimeSeason? get mainSeason {
    if (seasons.isEmpty) return null;
    return seasons.reduce((a, b) => 
      (a.episodeCount ?? 0) > (b.episodeCount ?? 0) ? a : b);
  }

  @override
  String toString() {
    return 'AnimeInfo(id: ${data.id}, title: ${data.title}, seasons: ${seasons.length})';
  }
}

/// Represents detailed data for an anime.
class AnimeData {
  /// Whether this anime contains adult content.
  final bool adultContent;

  /// The unique identifier for the anime.
  final String id;

  /// The data ID number.
  final int dataId;

  /// The English title of the anime.
  final String title;

  /// The Japanese title of the anime.
  final String japaneseTitle;

  /// The URL to the anime's poster image.
  final String poster;

  /// The type of show (e.g., "TV", "Movie", "OVA").
  final String showType;

  /// Detailed anime information including overview, genres, etc.
  final AnimeDetailedInfo animeInfo;

  /// Creates a new AnimeData instance.
  const AnimeData({
    required this.adultContent,
    required this.id,
    required this.dataId,
    required this.title,
    required this.japaneseTitle,
    required this.poster,
    required this.showType,
    required this.animeInfo,
  });

  /// Creates an AnimeData instance from a JSON map.
  factory AnimeData.fromJson(Map<String, dynamic> json) {
    return AnimeData(
      adultContent: json['adultContent'] as bool? ?? false,
      id: json['id'] as String,
      dataId: _parseInt(json['data_id']),
      title: json['title'] as String,
      japaneseTitle: json['japanese_title'] as String,
      poster: json['poster'] as String,
      showType: json['showType'] as String,
      animeInfo: AnimeDetailedInfo.fromJson(json['animeInfo'] as Map<String, dynamic>),
    );
  }

  /// Helper method to parse integer values that might come as strings.
  static int _parseInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  /// Converts the AnimeData instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'adultContent': adultContent,
      'id': id,
      'data_id': dataId,
      'title': title,
      'japanese_title': japaneseTitle,
      'poster': poster,
      'showType': showType,
      'animeInfo': animeInfo.toJson(),
    };
  }

  /// Returns the display title, preferring English title if available.
  String get displayTitle => title.isNotEmpty ? title : japaneseTitle;

  /// Returns true if this anime has both English and Japanese titles.
  bool get hasBothTitles => title.isNotEmpty && japaneseTitle.isNotEmpty;

  @override
  String toString() {
    return 'AnimeData(id: $id, title: $title, showType: $showType)';
  }
}

/// Represents detailed anime information including overview, genres, etc.
class AnimeDetailedInfo {
  /// The overview/description of the anime.
  final String overview;

  /// The Japanese title.
  final String japanese;

  /// Alternative titles/synonyms.
  final String synonyms;

  /// The aired date range.
  final String aired;

  /// The premiere season and year.
  final String premiered;

  /// The duration of episodes.
  final String duration;

  /// The current status (e.g., "Finished Airing", "Currently Airing").
  final String status;

  /// The MyAnimeList score.
  final String malScore;

  /// The list of genres.
  final List<String> genres;

  /// The production studios.
  final String studios;

  /// The list of producers.
  final List<String> producers;

  /// Creates a new AnimeDetailedInfo instance.
  const AnimeDetailedInfo({
    required this.overview,
    required this.japanese,
    required this.synonyms,
    required this.aired,
    required this.premiered,
    required this.duration,
    required this.status,
    required this.malScore,
    required this.genres,
    required this.studios,
    required this.producers,
  });

  /// Creates an AnimeDetailedInfo instance from a JSON map.
  factory AnimeDetailedInfo.fromJson(Map<String, dynamic> json) {
    return AnimeDetailedInfo(
      overview: json['Overview'] as String? ?? '',
      japanese: json['Japanese'] as String? ?? '',
      synonyms: json['Synonyms'] as String? ?? '',
      aired: json['Aired'] as String? ?? '',
      premiered: json['Premiered'] as String? ?? '',
      duration: json['Duration'] as String? ?? '',
      status: json['Status'] as String? ?? '',
      malScore: json['MAL Score'] as String? ?? '',
      genres: _parseGenres(json['Genres']),
      studios: json['Studios'] as String? ?? '',
      producers: _parseProducers(json['Producers']),
    );
  }

  /// Converts the AnimeDetailedInfo instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'Overview': overview,
      'Japanese': japanese,
      'Synonyms': synonyms,
      'Aired': aired,
      'Premiered': premiered,
      'Duration': duration,
      'Status': status,
      'MAL Score': malScore,
      'Genres': genres,
      'Studios': studios,
      'Producers': producers,
    };
  }

  /// Parses genres from the API response.
  static List<String> _parseGenres(dynamic genresData) {
    if (genresData is List) {
      return genresData.map((genre) => genre.toString()).toList();
    } else if (genresData is String && genresData.isNotEmpty) {
      return genresData.split(',').map((genre) => genre.trim()).toList();
    }
    return [];
  }

  /// Parses producers from the API response.
  static List<String> _parseProducers(dynamic producersData) {
    if (producersData is List) {
      return producersData.map((producer) => producer.toString()).toList();
    } else if (producersData is String && producersData.isNotEmpty) {
      return producersData.split(',').map((producer) => producer.trim()).toList();
    }
    return [];
  }

  /// Returns the MAL score as a double if parseable.
  double? get malScoreAsDouble {
    if (malScore.isEmpty) return null;
    return double.tryParse(malScore);
  }

  /// Returns true if this anime is currently airing.
  bool get isCurrentlyAiring => status.toLowerCase().contains('currently airing');

  /// Returns true if this anime has finished airing.
  bool get isFinished => status.toLowerCase().contains('finished');

  @override
  String toString() {
    return 'AnimeDetailedInfo(status: $status, genres: ${genres.length}, malScore: $malScore)';
  }
}

/// Represents a season of an anime.
class AnimeSeason {
  /// The unique identifier for this season.
  final String id;

  /// The data number for this season.
  final int dataNumber;

  /// The data ID for this season.
  final int dataId;

  /// The season name/number.
  final String season;

  /// The English title of this season.
  final String title;

  /// The Japanese title of this season.
  final String japaneseTitle;

  /// The URL to the season's poster image.
  final String seasonPoster;

  /// The number of episodes in this season (if known).
  final int? episodeCount;

  /// Creates a new AnimeSeason instance.
  const AnimeSeason({
    required this.id,
    required this.dataNumber,
    required this.dataId,
    required this.season,
    required this.title,
    required this.japaneseTitle,
    required this.seasonPoster,
    this.episodeCount,
  });

  /// Creates an AnimeSeason instance from a JSON map.
  factory AnimeSeason.fromJson(Map<String, dynamic> json) {
    return AnimeSeason(
      id: json['id'] as String,
      dataNumber: AnimeData._parseInt(json['data_number']),
      dataId: AnimeData._parseInt(json['data_id']),
      season: json['season'] as String,
      title: json['title'] as String,
      japaneseTitle: json['japanese_title'] as String,
      seasonPoster: json['season_poster'] as String,
      episodeCount: AnimeSeason._parseIntNullable(json['episodeCount']),
    );
  }

  /// Helper method to parse nullable integer values that might come as strings.
  static int? _parseIntNullable(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is String) return int.tryParse(value);
    return null;
  }

  /// Converts the AnimeSeason instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'data_number': dataNumber,
      'data_id': dataId,
      'season': season,
      'title': title,
      'japanese_title': japaneseTitle,
      'season_poster': seasonPoster,
      'episodeCount': episodeCount,
    };
  }

  /// Returns the display title for this season.
  String get displayTitle => title.isNotEmpty ? title : japaneseTitle;

  /// Returns a formatted season name (e.g., "Season 1", "Season 2").
  String get formattedSeasonName {
    final seasonNumber = int.tryParse(season);
    if (seasonNumber != null) {
      return 'Season $seasonNumber';
    }
    return season;
  }

  @override
  String toString() {
    return 'AnimeSeason(id: $id, season: $season, title: $title)';
  }
}
