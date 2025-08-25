import 'package:lets_stream/src/core/models/movie.dart';
import 'package:lets_stream/src/core/models/tv_show.dart';

class HomeState {
  final List<Movie> trendingMovies;
  final List<Movie> nowPlayingMovies;
  final List<Movie> popularMovies;
  final List<Movie> topRatedMovies;
  final List<TvShow> trendingTvShows;
  final List<TvShow> airingTodayTvShows;
  final List<TvShow> popularTvShows;
  final List<TvShow> topRatedTvShows;

  HomeState({
    this.trendingMovies = const [],
    this.nowPlayingMovies = const [],
    this.popularMovies = const [],
    this.topRatedMovies = const [],
    this.trendingTvShows = const [],
    this.airingTodayTvShows = const [],
    this.popularTvShows = const [],
    this.topRatedTvShows = const [],
  });

  HomeState copyWith({
    List<Movie>? trendingMovies,
    List<Movie>? nowPlayingMovies,
    List<Movie>? popularMovies,
    List<Movie>? topRatedMovies,
    List<TvShow>? trendingTvShows,
    List<TvShow>? airingTodayTvShows,
    List<TvShow>? popularTvShows,
    List<TvShow>? topRatedTvShows,
  }) {
    return HomeState(
      trendingMovies: trendingMovies ?? this.trendingMovies,
      nowPlayingMovies: nowPlayingMovies ?? this.nowPlayingMovies,
      popularMovies: popularMovies ?? this.popularMovies,
      topRatedMovies: topRatedMovies ?? this.topRatedMovies,
      trendingTvShows: trendingTvShows ?? this.trendingTvShows,
      airingTodayTvShows: airingTodayTvShows ?? this.airingTodayTvShows,
      popularTvShows: popularTvShows ?? this.popularTvShows,
      topRatedTvShows: topRatedTvShows ?? this.topRatedTvShows,
    );
  }
}