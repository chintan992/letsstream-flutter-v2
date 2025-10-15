/// Represents an anime search result from the Anime API.
///
/// This model encapsulates basic information about an anime found in search results,
/// including identification, titles, poster, and basic TV info.
class AnimeSearchResult {
  /// The unique identifier for the anime from the Anime API.
  final String id;

  /// The English title of the anime.
  final String title;

  /// The Japanese title of the anime.
  final String japaneseTitle;

  /// The URL to the anime's poster image.
  final String poster;

  /// The duration of episodes (e.g., "24m", "115m").
  final String duration;

  /// Basic TV information including show type and availability.
  final AnimeTvInfo tvInfo;

  /// Creates a new AnimeSearchResult instance.
  const AnimeSearchResult({
    required this.id,
    required this.title,
    required this.japaneseTitle,
    required this.poster,
    required this.duration,
    required this.tvInfo,
  });

  /// Creates an AnimeSearchResult instance from a JSON map.
  ///
  /// [json] A map containing anime search result data from the Anime API.
  factory AnimeSearchResult.fromJson(Map<String, dynamic> json) {
    return AnimeSearchResult(
      id: json['id'] as String,
      title: json['title'] as String,
      japaneseTitle: json['japanese_title'] as String,
      poster: json['poster'] as String,
      duration: json['duration'] as String,
      tvInfo: AnimeTvInfo.fromJson(json['tvInfo'] as Map<String, dynamic>),
    );
  }

  /// Converts the AnimeSearchResult instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'japanese_title': japaneseTitle,
      'poster': poster,
      'duration': duration,
      'tvInfo': tvInfo.toJson(),
    };
  }

  @override
  String toString() {
    return 'AnimeSearchResult(id: $id, title: $title, japaneseTitle: $japaneseTitle)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimeSearchResult && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}

/// Represents basic TV information for an anime.
class AnimeTvInfo {
  /// The type of show (e.g., "TV", "Movie", "OVA", "Special").
  final String showType;

  /// The rating of the anime (e.g., "18+", null for general audiences).
  final String? rating;

  /// The number of subbed episodes available.
  final int? sub;

  /// The number of dubbed episodes available.
  final int? dub;

  /// The total number of episodes.
  final int? eps;

  /// Creates a new AnimeTvInfo instance.
  const AnimeTvInfo({
    required this.showType,
    this.rating,
    this.sub,
    this.dub,
    this.eps,
  });

  /// Creates an AnimeTvInfo instance from a JSON map.
  factory AnimeTvInfo.fromJson(Map<String, dynamic> json) {
    return AnimeTvInfo(
      showType: json['showType'] as String,
      rating: json['rating'] as String?,
      sub: json['sub'] as int?,
      dub: json['dub'] as int?,
      eps: json['eps'] as int?,
    );
  }

  /// Converts the AnimeTvInfo instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'showType': showType,
      'rating': rating,
      'sub': sub,
      'dub': dub,
      'eps': eps,
    };
  }

  /// Returns true if the anime has both sub and dub available.
  bool get hasBothSubAndDub => (sub ?? 0) > 0 && (dub ?? 0) > 0;

  /// Returns true if the anime has subbed episodes.
  bool get hasSub => (sub ?? 0) > 0;

  /// Returns true if the anime has dubbed episodes.
  bool get hasDub => (dub ?? 0) > 0;

  @override
  String toString() {
    return 'AnimeTvInfo(showType: $showType, sub: $sub, dub: $dub, eps: $eps)';
  }
}
