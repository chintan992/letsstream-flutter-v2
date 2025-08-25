class EpisodeSummary {
  final int id;
  final int episodeNumber;
  final String name;
  final String? overview;
  final String? stillPath;
  final DateTime? airDate;
  final double voteAverage;

  EpisodeSummary({
    required this.id,
    required this.episodeNumber,
    required this.name,
    required this.overview,
    required this.stillPath,
    required this.airDate,
    required this.voteAverage,
  });

  factory EpisodeSummary.fromJson(Map<String, dynamic> json) {
    DateTime? ad;
    final adStr = json['air_date'] as String?;
    if (adStr != null && adStr.isNotEmpty) {
      try {
        ad = DateTime.parse(adStr);
      } catch (_) {
        ad = null;
      }
    }
    return EpisodeSummary(
      id: (json['id'] as num?)?.toInt() ?? 0,
      episodeNumber: (json['episode_number'] as num?)?.toInt() ?? 0,
      name: (json['name'] as String?) ?? '',
      overview: json['overview'] as String?,
      stillPath: json['still_path'] as String?,
      airDate: ad,
      voteAverage: (json['vote_average'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'episode_number': episodeNumber,
      'name': name,
      'overview': overview,
      'still_path': stillPath,
      'air_date': airDate?.toIso8601String(),
      'vote_average': voteAverage,
    };
  }
}

