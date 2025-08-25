class SeasonSummary {
  final int id;
  final int seasonNumber;
  final String name;
  final String? overview;
  final String? posterPath;
  final DateTime? airDate;
  final int episodeCount;

  SeasonSummary({
    required this.id,
    required this.seasonNumber,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.airDate,
    required this.episodeCount,
  });

  factory SeasonSummary.fromJson(Map<String, dynamic> json) {
    DateTime? ad;
    final adStr = json['air_date'] as String?;
    if (adStr != null && adStr.isNotEmpty) {
      try {
        ad = DateTime.parse(adStr);
      } catch (_) {
        ad = null;
      }
    }
    return SeasonSummary(
      id: (json['id'] as num?)?.toInt() ?? 0,
      seasonNumber: (json['season_number'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      airDate: ad,
      episodeCount: (json['episode_count'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'season_number': seasonNumber,
      'name': name,
      'overview': overview,
      'poster_path': posterPath,
      'air_date': airDate?.toIso8601String(),
      'episode_count': episodeCount,
    };
  }
}

