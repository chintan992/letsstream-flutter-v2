class TvShow {
  final int id;
  final String name;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? firstAirDate;
  final double voteAverage;
  final int voteCount;

  TvShow({
    required this.id,
    required this.name,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.backdropPath,
    required this.firstAirDate,
    required this.voteAverage,
    required this.voteCount,
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    final name = (json['name'] ?? json['title'] ?? '') as String;
    final overview = (json['overview'] ?? '') as String;
    final popularity = (json['popularity'] as num?)?.toDouble() ?? 0.0;
    final voteAverage = (json['vote_average'] as num?)?.toDouble() ?? 0.0;
    final voteCount = (json['vote_count'] as int?) ?? 0;

    DateTime? parsedDate;
    final fd = json['first_air_date'] as String?;
    if (fd != null && fd.isNotEmpty) {
      try {
        parsedDate = DateTime.parse(fd);
      } catch (_) {
        parsedDate = null;
      }
    }

    return TvShow(
      id: (json['id'] as num).toInt(),
      name: name,
      overview: overview,
      popularity: popularity,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: parsedDate,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'first_air_date': firstAirDate?.toIso8601String(),
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }
}
