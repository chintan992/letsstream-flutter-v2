
import 'package:lets_stream/src/core/models/episode.dart';

class SeasonDetail {
  final int id;
  final String name;
  final String overview;
  final int seasonNumber;
  final List<EpisodeSummary> episodes;

  SeasonDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.seasonNumber,
    required this.episodes,
  });

  factory SeasonDetail.fromJson(Map<String, dynamic> json) {
    return SeasonDetail(
      id: json['id'],
      name: json['name'],
      overview: json['overview'],
      seasonNumber: json['season_number'],
      episodes: (json['episodes'] as List)
          .map((e) => EpisodeSummary.fromJson(e))
          .toList(),
    );
  }
}
