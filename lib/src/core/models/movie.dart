class Movie {
  final int id;
  final String title;
  final String overview;
  final double popularity;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? releaseDate;
  final double voteAverage;
  final int voteCount;

  Movie({
    required this.id,
    required this.title,
    required this.overview,
    required this.popularity,
    required this.posterPath,
    required this.backdropPath,
    required this.releaseDate,
    required this.voteAverage,
    required this.voteCount,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] ?? json['name'] ?? '') as String;
    final overview = (json['overview'] ?? '') as String;
    final popularity = (json['popularity'] as num?)?.toDouble() ?? 0.0;
    final voteAverage = (json['vote_average'] as num?)?.toDouble() ?? 0.0;
    final voteCount = (json['vote_count'] as int?) ?? 0;

    DateTime? parsedDate;
    final rd = json['release_date'] as String?;
    if (rd != null && rd.isNotEmpty) {
      try {
        parsedDate = DateTime.parse(rd);
      } catch (_) {
        parsedDate = null;
      }
    }

    return Movie(
      id: (json['id'] as num).toInt(),
      title: title,
      overview: overview,
      popularity: popularity,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      releaseDate: parsedDate,
      voteAverage: voteAverage,
      voteCount: voteCount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'overview': overview,
      'popularity': popularity,
      'poster_path': posterPath,
      'backdrop_path': backdropPath,
      'release_date': releaseDate?.toIso8601String(),
      'vote_average': voteAverage,
      'vote_count': voteCount,
    };
  }
}
