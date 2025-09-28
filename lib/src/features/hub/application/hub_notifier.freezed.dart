// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'hub_notifier.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HubState {
// Standard movie categories
  List<Movie> get trendingMovies => throw _privateConstructorUsedError;
  List<Movie> get nowPlayingMovies => throw _privateConstructorUsedError;
  List<Movie> get popularMovies => throw _privateConstructorUsedError;
  List<Movie> get topRatedMovies =>
      throw _privateConstructorUsedError; // Standard TV show categories
  List<TvShow> get trendingTvShows => throw _privateConstructorUsedError;
  List<TvShow> get airingTodayTvShows => throw _privateConstructorUsedError;
  List<TvShow> get popularTvShows => throw _privateConstructorUsedError;
  List<TvShow> get topRatedTvShows =>
      throw _privateConstructorUsedError; // Genre mappings
  Map<int, String> get movieGenres => throw _privateConstructorUsedError;
  Map<int, String> get tvGenres =>
      throw _privateConstructorUsedError; // Expanded Movie Genres
  List<Movie> get actionMovies => throw _privateConstructorUsedError;
  List<Movie> get comedyMovies => throw _privateConstructorUsedError;
  List<Movie> get horrorMovies => throw _privateConstructorUsedError;
  List<Movie> get dramaMovies => throw _privateConstructorUsedError;
  List<Movie> get sciFiMovies => throw _privateConstructorUsedError;
  List<Movie> get adventureMovies => throw _privateConstructorUsedError;
  List<Movie> get thrillerMovies => throw _privateConstructorUsedError;
  List<Movie> get romanceMovies =>
      throw _privateConstructorUsedError; // Expanded TV Show Genres
  List<TvShow> get dramaTvShows => throw _privateConstructorUsedError;
  List<TvShow> get comedyTvShows => throw _privateConstructorUsedError;
  List<TvShow> get crimeTvShows => throw _privateConstructorUsedError;
  List<TvShow> get sciFiFantasyTvShows => throw _privateConstructorUsedError;
  List<TvShow> get documentaryTvShows =>
      throw _privateConstructorUsedError; // Expanded Streaming Platforms
  List<TvShow> get netflixShows => throw _privateConstructorUsedError;
  List<TvShow> get amazonPrimeShows => throw _privateConstructorUsedError;
  List<TvShow> get disneyPlusShows => throw _privateConstructorUsedError;
  List<TvShow> get huluShows => throw _privateConstructorUsedError;
  List<TvShow> get hboMaxShows => throw _privateConstructorUsedError;
  List<TvShow> get appleTvShows => throw _privateConstructorUsedError;
  List<Movie> get netflixMovies => throw _privateConstructorUsedError;
  List<Movie> get amazonPrimeMovies => throw _privateConstructorUsedError;
  List<Movie> get disneyPlusMovies =>
      throw _privateConstructorUsedError; // Personalized content
  List<Movie> get personalizedMovies => throw _privateConstructorUsedError;
  List<TvShow> get personalizedTvShows => throw _privateConstructorUsedError;
  List<Movie> get recommendedMovies => throw _privateConstructorUsedError;
  List<TvShow> get recommendedTvShows => throw _privateConstructorUsedError;
  List<Movie> get genreBasedMovies => throw _privateConstructorUsedError;
  List<TvShow> get genreBasedTvShows =>
      throw _privateConstructorUsedError; // Personalization settings
  bool get isPersonalizationEnabled => throw _privateConstructorUsedError;
  List<int> get userPreferredGenres => throw _privateConstructorUsedError;
  List<int> get userPreferredPlatforms =>
      throw _privateConstructorUsedError; // Loading and error states
  bool get isLoading => throw _privateConstructorUsedError;
  Object? get error => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $HubStateCopyWith<HubState> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HubStateCopyWith<$Res> {
  factory $HubStateCopyWith(HubState value, $Res Function(HubState) then) =
      _$HubStateCopyWithImpl<$Res, HubState>;
  @useResult
  $Res call(
      {List<Movie> trendingMovies,
      List<Movie> nowPlayingMovies,
      List<Movie> popularMovies,
      List<Movie> topRatedMovies,
      List<TvShow> trendingTvShows,
      List<TvShow> airingTodayTvShows,
      List<TvShow> popularTvShows,
      List<TvShow> topRatedTvShows,
      Map<int, String> movieGenres,
      Map<int, String> tvGenres,
      List<Movie> actionMovies,
      List<Movie> comedyMovies,
      List<Movie> horrorMovies,
      List<Movie> dramaMovies,
      List<Movie> sciFiMovies,
      List<Movie> adventureMovies,
      List<Movie> thrillerMovies,
      List<Movie> romanceMovies,
      List<TvShow> dramaTvShows,
      List<TvShow> comedyTvShows,
      List<TvShow> crimeTvShows,
      List<TvShow> sciFiFantasyTvShows,
      List<TvShow> documentaryTvShows,
      List<TvShow> netflixShows,
      List<TvShow> amazonPrimeShows,
      List<TvShow> disneyPlusShows,
      List<TvShow> huluShows,
      List<TvShow> hboMaxShows,
      List<TvShow> appleTvShows,
      List<Movie> netflixMovies,
      List<Movie> amazonPrimeMovies,
      List<Movie> disneyPlusMovies,
      List<Movie> personalizedMovies,
      List<TvShow> personalizedTvShows,
      List<Movie> recommendedMovies,
      List<TvShow> recommendedTvShows,
      List<Movie> genreBasedMovies,
      List<TvShow> genreBasedTvShows,
      bool isPersonalizationEnabled,
      List<int> userPreferredGenres,
      List<int> userPreferredPlatforms,
      bool isLoading,
      Object? error});
}

/// @nodoc
class _$HubStateCopyWithImpl<$Res, $Val extends HubState>
    implements $HubStateCopyWith<$Res> {
  _$HubStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trendingMovies = null,
    Object? nowPlayingMovies = null,
    Object? popularMovies = null,
    Object? topRatedMovies = null,
    Object? trendingTvShows = null,
    Object? airingTodayTvShows = null,
    Object? popularTvShows = null,
    Object? topRatedTvShows = null,
    Object? movieGenres = null,
    Object? tvGenres = null,
    Object? actionMovies = null,
    Object? comedyMovies = null,
    Object? horrorMovies = null,
    Object? dramaMovies = null,
    Object? sciFiMovies = null,
    Object? adventureMovies = null,
    Object? thrillerMovies = null,
    Object? romanceMovies = null,
    Object? dramaTvShows = null,
    Object? comedyTvShows = null,
    Object? crimeTvShows = null,
    Object? sciFiFantasyTvShows = null,
    Object? documentaryTvShows = null,
    Object? netflixShows = null,
    Object? amazonPrimeShows = null,
    Object? disneyPlusShows = null,
    Object? huluShows = null,
    Object? hboMaxShows = null,
    Object? appleTvShows = null,
    Object? netflixMovies = null,
    Object? amazonPrimeMovies = null,
    Object? disneyPlusMovies = null,
    Object? personalizedMovies = null,
    Object? personalizedTvShows = null,
    Object? recommendedMovies = null,
    Object? recommendedTvShows = null,
    Object? genreBasedMovies = null,
    Object? genreBasedTvShows = null,
    Object? isPersonalizationEnabled = null,
    Object? userPreferredGenres = null,
    Object? userPreferredPlatforms = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_value.copyWith(
      trendingMovies: null == trendingMovies
          ? _value.trendingMovies
          : trendingMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      nowPlayingMovies: null == nowPlayingMovies
          ? _value.nowPlayingMovies
          : nowPlayingMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      popularMovies: null == popularMovies
          ? _value.popularMovies
          : popularMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      topRatedMovies: null == topRatedMovies
          ? _value.topRatedMovies
          : topRatedMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      trendingTvShows: null == trendingTvShows
          ? _value.trendingTvShows
          : trendingTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      airingTodayTvShows: null == airingTodayTvShows
          ? _value.airingTodayTvShows
          : airingTodayTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      popularTvShows: null == popularTvShows
          ? _value.popularTvShows
          : popularTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      topRatedTvShows: null == topRatedTvShows
          ? _value.topRatedTvShows
          : topRatedTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      movieGenres: null == movieGenres
          ? _value.movieGenres
          : movieGenres // ignore: cast_nullable_to_non_nullable
              as Map<int, String>,
      tvGenres: null == tvGenres
          ? _value.tvGenres
          : tvGenres // ignore: cast_nullable_to_non_nullable
              as Map<int, String>,
      actionMovies: null == actionMovies
          ? _value.actionMovies
          : actionMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      comedyMovies: null == comedyMovies
          ? _value.comedyMovies
          : comedyMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      horrorMovies: null == horrorMovies
          ? _value.horrorMovies
          : horrorMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      dramaMovies: null == dramaMovies
          ? _value.dramaMovies
          : dramaMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      sciFiMovies: null == sciFiMovies
          ? _value.sciFiMovies
          : sciFiMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      adventureMovies: null == adventureMovies
          ? _value.adventureMovies
          : adventureMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      thrillerMovies: null == thrillerMovies
          ? _value.thrillerMovies
          : thrillerMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      romanceMovies: null == romanceMovies
          ? _value.romanceMovies
          : romanceMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      dramaTvShows: null == dramaTvShows
          ? _value.dramaTvShows
          : dramaTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      comedyTvShows: null == comedyTvShows
          ? _value.comedyTvShows
          : comedyTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      crimeTvShows: null == crimeTvShows
          ? _value.crimeTvShows
          : crimeTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      sciFiFantasyTvShows: null == sciFiFantasyTvShows
          ? _value.sciFiFantasyTvShows
          : sciFiFantasyTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      documentaryTvShows: null == documentaryTvShows
          ? _value.documentaryTvShows
          : documentaryTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      netflixShows: null == netflixShows
          ? _value.netflixShows
          : netflixShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      amazonPrimeShows: null == amazonPrimeShows
          ? _value.amazonPrimeShows
          : amazonPrimeShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      disneyPlusShows: null == disneyPlusShows
          ? _value.disneyPlusShows
          : disneyPlusShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      huluShows: null == huluShows
          ? _value.huluShows
          : huluShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      hboMaxShows: null == hboMaxShows
          ? _value.hboMaxShows
          : hboMaxShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      appleTvShows: null == appleTvShows
          ? _value.appleTvShows
          : appleTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      netflixMovies: null == netflixMovies
          ? _value.netflixMovies
          : netflixMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      amazonPrimeMovies: null == amazonPrimeMovies
          ? _value.amazonPrimeMovies
          : amazonPrimeMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      disneyPlusMovies: null == disneyPlusMovies
          ? _value.disneyPlusMovies
          : disneyPlusMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      personalizedMovies: null == personalizedMovies
          ? _value.personalizedMovies
          : personalizedMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      personalizedTvShows: null == personalizedTvShows
          ? _value.personalizedTvShows
          : personalizedTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      recommendedMovies: null == recommendedMovies
          ? _value.recommendedMovies
          : recommendedMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      recommendedTvShows: null == recommendedTvShows
          ? _value.recommendedTvShows
          : recommendedTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      genreBasedMovies: null == genreBasedMovies
          ? _value.genreBasedMovies
          : genreBasedMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      genreBasedTvShows: null == genreBasedTvShows
          ? _value.genreBasedTvShows
          : genreBasedTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      isPersonalizationEnabled: null == isPersonalizationEnabled
          ? _value.isPersonalizationEnabled
          : isPersonalizationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      userPreferredGenres: null == userPreferredGenres
          ? _value.userPreferredGenres
          : userPreferredGenres // ignore: cast_nullable_to_non_nullable
              as List<int>,
      userPreferredPlatforms: null == userPreferredPlatforms
          ? _value.userPreferredPlatforms
          : userPreferredPlatforms // ignore: cast_nullable_to_non_nullable
              as List<int>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HubStateImplCopyWith<$Res>
    implements $HubStateCopyWith<$Res> {
  factory _$$HubStateImplCopyWith(
          _$HubStateImpl value, $Res Function(_$HubStateImpl) then) =
      __$$HubStateImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<Movie> trendingMovies,
      List<Movie> nowPlayingMovies,
      List<Movie> popularMovies,
      List<Movie> topRatedMovies,
      List<TvShow> trendingTvShows,
      List<TvShow> airingTodayTvShows,
      List<TvShow> popularTvShows,
      List<TvShow> topRatedTvShows,
      Map<int, String> movieGenres,
      Map<int, String> tvGenres,
      List<Movie> actionMovies,
      List<Movie> comedyMovies,
      List<Movie> horrorMovies,
      List<Movie> dramaMovies,
      List<Movie> sciFiMovies,
      List<Movie> adventureMovies,
      List<Movie> thrillerMovies,
      List<Movie> romanceMovies,
      List<TvShow> dramaTvShows,
      List<TvShow> comedyTvShows,
      List<TvShow> crimeTvShows,
      List<TvShow> sciFiFantasyTvShows,
      List<TvShow> documentaryTvShows,
      List<TvShow> netflixShows,
      List<TvShow> amazonPrimeShows,
      List<TvShow> disneyPlusShows,
      List<TvShow> huluShows,
      List<TvShow> hboMaxShows,
      List<TvShow> appleTvShows,
      List<Movie> netflixMovies,
      List<Movie> amazonPrimeMovies,
      List<Movie> disneyPlusMovies,
      List<Movie> personalizedMovies,
      List<TvShow> personalizedTvShows,
      List<Movie> recommendedMovies,
      List<TvShow> recommendedTvShows,
      List<Movie> genreBasedMovies,
      List<TvShow> genreBasedTvShows,
      bool isPersonalizationEnabled,
      List<int> userPreferredGenres,
      List<int> userPreferredPlatforms,
      bool isLoading,
      Object? error});
}

/// @nodoc
class __$$HubStateImplCopyWithImpl<$Res>
    extends _$HubStateCopyWithImpl<$Res, _$HubStateImpl>
    implements _$$HubStateImplCopyWith<$Res> {
  __$$HubStateImplCopyWithImpl(
      _$HubStateImpl _value, $Res Function(_$HubStateImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? trendingMovies = null,
    Object? nowPlayingMovies = null,
    Object? popularMovies = null,
    Object? topRatedMovies = null,
    Object? trendingTvShows = null,
    Object? airingTodayTvShows = null,
    Object? popularTvShows = null,
    Object? topRatedTvShows = null,
    Object? movieGenres = null,
    Object? tvGenres = null,
    Object? actionMovies = null,
    Object? comedyMovies = null,
    Object? horrorMovies = null,
    Object? dramaMovies = null,
    Object? sciFiMovies = null,
    Object? adventureMovies = null,
    Object? thrillerMovies = null,
    Object? romanceMovies = null,
    Object? dramaTvShows = null,
    Object? comedyTvShows = null,
    Object? crimeTvShows = null,
    Object? sciFiFantasyTvShows = null,
    Object? documentaryTvShows = null,
    Object? netflixShows = null,
    Object? amazonPrimeShows = null,
    Object? disneyPlusShows = null,
    Object? huluShows = null,
    Object? hboMaxShows = null,
    Object? appleTvShows = null,
    Object? netflixMovies = null,
    Object? amazonPrimeMovies = null,
    Object? disneyPlusMovies = null,
    Object? personalizedMovies = null,
    Object? personalizedTvShows = null,
    Object? recommendedMovies = null,
    Object? recommendedTvShows = null,
    Object? genreBasedMovies = null,
    Object? genreBasedTvShows = null,
    Object? isPersonalizationEnabled = null,
    Object? userPreferredGenres = null,
    Object? userPreferredPlatforms = null,
    Object? isLoading = null,
    Object? error = freezed,
  }) {
    return _then(_$HubStateImpl(
      trendingMovies: null == trendingMovies
          ? _value._trendingMovies
          : trendingMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      nowPlayingMovies: null == nowPlayingMovies
          ? _value._nowPlayingMovies
          : nowPlayingMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      popularMovies: null == popularMovies
          ? _value._popularMovies
          : popularMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      topRatedMovies: null == topRatedMovies
          ? _value._topRatedMovies
          : topRatedMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      trendingTvShows: null == trendingTvShows
          ? _value._trendingTvShows
          : trendingTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      airingTodayTvShows: null == airingTodayTvShows
          ? _value._airingTodayTvShows
          : airingTodayTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      popularTvShows: null == popularTvShows
          ? _value._popularTvShows
          : popularTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      topRatedTvShows: null == topRatedTvShows
          ? _value._topRatedTvShows
          : topRatedTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      movieGenres: null == movieGenres
          ? _value._movieGenres
          : movieGenres // ignore: cast_nullable_to_non_nullable
              as Map<int, String>,
      tvGenres: null == tvGenres
          ? _value._tvGenres
          : tvGenres // ignore: cast_nullable_to_non_nullable
              as Map<int, String>,
      actionMovies: null == actionMovies
          ? _value._actionMovies
          : actionMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      comedyMovies: null == comedyMovies
          ? _value._comedyMovies
          : comedyMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      horrorMovies: null == horrorMovies
          ? _value._horrorMovies
          : horrorMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      dramaMovies: null == dramaMovies
          ? _value._dramaMovies
          : dramaMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      sciFiMovies: null == sciFiMovies
          ? _value._sciFiMovies
          : sciFiMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      adventureMovies: null == adventureMovies
          ? _value._adventureMovies
          : adventureMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      thrillerMovies: null == thrillerMovies
          ? _value._thrillerMovies
          : thrillerMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      romanceMovies: null == romanceMovies
          ? _value._romanceMovies
          : romanceMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      dramaTvShows: null == dramaTvShows
          ? _value._dramaTvShows
          : dramaTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      comedyTvShows: null == comedyTvShows
          ? _value._comedyTvShows
          : comedyTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      crimeTvShows: null == crimeTvShows
          ? _value._crimeTvShows
          : crimeTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      sciFiFantasyTvShows: null == sciFiFantasyTvShows
          ? _value._sciFiFantasyTvShows
          : sciFiFantasyTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      documentaryTvShows: null == documentaryTvShows
          ? _value._documentaryTvShows
          : documentaryTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      netflixShows: null == netflixShows
          ? _value._netflixShows
          : netflixShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      amazonPrimeShows: null == amazonPrimeShows
          ? _value._amazonPrimeShows
          : amazonPrimeShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      disneyPlusShows: null == disneyPlusShows
          ? _value._disneyPlusShows
          : disneyPlusShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      huluShows: null == huluShows
          ? _value._huluShows
          : huluShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      hboMaxShows: null == hboMaxShows
          ? _value._hboMaxShows
          : hboMaxShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      appleTvShows: null == appleTvShows
          ? _value._appleTvShows
          : appleTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      netflixMovies: null == netflixMovies
          ? _value._netflixMovies
          : netflixMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      amazonPrimeMovies: null == amazonPrimeMovies
          ? _value._amazonPrimeMovies
          : amazonPrimeMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      disneyPlusMovies: null == disneyPlusMovies
          ? _value._disneyPlusMovies
          : disneyPlusMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      personalizedMovies: null == personalizedMovies
          ? _value._personalizedMovies
          : personalizedMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      personalizedTvShows: null == personalizedTvShows
          ? _value._personalizedTvShows
          : personalizedTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      recommendedMovies: null == recommendedMovies
          ? _value._recommendedMovies
          : recommendedMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      recommendedTvShows: null == recommendedTvShows
          ? _value._recommendedTvShows
          : recommendedTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      genreBasedMovies: null == genreBasedMovies
          ? _value._genreBasedMovies
          : genreBasedMovies // ignore: cast_nullable_to_non_nullable
              as List<Movie>,
      genreBasedTvShows: null == genreBasedTvShows
          ? _value._genreBasedTvShows
          : genreBasedTvShows // ignore: cast_nullable_to_non_nullable
              as List<TvShow>,
      isPersonalizationEnabled: null == isPersonalizationEnabled
          ? _value.isPersonalizationEnabled
          : isPersonalizationEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      userPreferredGenres: null == userPreferredGenres
          ? _value._userPreferredGenres
          : userPreferredGenres // ignore: cast_nullable_to_non_nullable
              as List<int>,
      userPreferredPlatforms: null == userPreferredPlatforms
          ? _value._userPreferredPlatforms
          : userPreferredPlatforms // ignore: cast_nullable_to_non_nullable
              as List<int>,
      isLoading: null == isLoading
          ? _value.isLoading
          : isLoading // ignore: cast_nullable_to_non_nullable
              as bool,
      error: freezed == error ? _value.error : error,
    ));
  }
}

/// @nodoc

class _$HubStateImpl implements _HubState {
  const _$HubStateImpl(
      {final List<Movie> trendingMovies = const [],
      final List<Movie> nowPlayingMovies = const [],
      final List<Movie> popularMovies = const [],
      final List<Movie> topRatedMovies = const [],
      final List<TvShow> trendingTvShows = const [],
      final List<TvShow> airingTodayTvShows = const [],
      final List<TvShow> popularTvShows = const [],
      final List<TvShow> topRatedTvShows = const [],
      final Map<int, String> movieGenres = const {},
      final Map<int, String> tvGenres = const {},
      final List<Movie> actionMovies = const [],
      final List<Movie> comedyMovies = const [],
      final List<Movie> horrorMovies = const [],
      final List<Movie> dramaMovies = const [],
      final List<Movie> sciFiMovies = const [],
      final List<Movie> adventureMovies = const [],
      final List<Movie> thrillerMovies = const [],
      final List<Movie> romanceMovies = const [],
      final List<TvShow> dramaTvShows = const [],
      final List<TvShow> comedyTvShows = const [],
      final List<TvShow> crimeTvShows = const [],
      final List<TvShow> sciFiFantasyTvShows = const [],
      final List<TvShow> documentaryTvShows = const [],
      final List<TvShow> netflixShows = const [],
      final List<TvShow> amazonPrimeShows = const [],
      final List<TvShow> disneyPlusShows = const [],
      final List<TvShow> huluShows = const [],
      final List<TvShow> hboMaxShows = const [],
      final List<TvShow> appleTvShows = const [],
      final List<Movie> netflixMovies = const [],
      final List<Movie> amazonPrimeMovies = const [],
      final List<Movie> disneyPlusMovies = const [],
      final List<Movie> personalizedMovies = const [],
      final List<TvShow> personalizedTvShows = const [],
      final List<Movie> recommendedMovies = const [],
      final List<TvShow> recommendedTvShows = const [],
      final List<Movie> genreBasedMovies = const [],
      final List<TvShow> genreBasedTvShows = const [],
      this.isPersonalizationEnabled = false,
      final List<int> userPreferredGenres = const [],
      final List<int> userPreferredPlatforms = const [],
      this.isLoading = true,
      this.error})
      : _trendingMovies = trendingMovies,
        _nowPlayingMovies = nowPlayingMovies,
        _popularMovies = popularMovies,
        _topRatedMovies = topRatedMovies,
        _trendingTvShows = trendingTvShows,
        _airingTodayTvShows = airingTodayTvShows,
        _popularTvShows = popularTvShows,
        _topRatedTvShows = topRatedTvShows,
        _movieGenres = movieGenres,
        _tvGenres = tvGenres,
        _actionMovies = actionMovies,
        _comedyMovies = comedyMovies,
        _horrorMovies = horrorMovies,
        _dramaMovies = dramaMovies,
        _sciFiMovies = sciFiMovies,
        _adventureMovies = adventureMovies,
        _thrillerMovies = thrillerMovies,
        _romanceMovies = romanceMovies,
        _dramaTvShows = dramaTvShows,
        _comedyTvShows = comedyTvShows,
        _crimeTvShows = crimeTvShows,
        _sciFiFantasyTvShows = sciFiFantasyTvShows,
        _documentaryTvShows = documentaryTvShows,
        _netflixShows = netflixShows,
        _amazonPrimeShows = amazonPrimeShows,
        _disneyPlusShows = disneyPlusShows,
        _huluShows = huluShows,
        _hboMaxShows = hboMaxShows,
        _appleTvShows = appleTvShows,
        _netflixMovies = netflixMovies,
        _amazonPrimeMovies = amazonPrimeMovies,
        _disneyPlusMovies = disneyPlusMovies,
        _personalizedMovies = personalizedMovies,
        _personalizedTvShows = personalizedTvShows,
        _recommendedMovies = recommendedMovies,
        _recommendedTvShows = recommendedTvShows,
        _genreBasedMovies = genreBasedMovies,
        _genreBasedTvShows = genreBasedTvShows,
        _userPreferredGenres = userPreferredGenres,
        _userPreferredPlatforms = userPreferredPlatforms;

// Standard movie categories
  final List<Movie> _trendingMovies;
// Standard movie categories
  @override
  @JsonKey()
  List<Movie> get trendingMovies {
    if (_trendingMovies is EqualUnmodifiableListView) return _trendingMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trendingMovies);
  }

  final List<Movie> _nowPlayingMovies;
  @override
  @JsonKey()
  List<Movie> get nowPlayingMovies {
    if (_nowPlayingMovies is EqualUnmodifiableListView)
      return _nowPlayingMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_nowPlayingMovies);
  }

  final List<Movie> _popularMovies;
  @override
  @JsonKey()
  List<Movie> get popularMovies {
    if (_popularMovies is EqualUnmodifiableListView) return _popularMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularMovies);
  }

  final List<Movie> _topRatedMovies;
  @override
  @JsonKey()
  List<Movie> get topRatedMovies {
    if (_topRatedMovies is EqualUnmodifiableListView) return _topRatedMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topRatedMovies);
  }

// Standard TV show categories
  final List<TvShow> _trendingTvShows;
// Standard TV show categories
  @override
  @JsonKey()
  List<TvShow> get trendingTvShows {
    if (_trendingTvShows is EqualUnmodifiableListView) return _trendingTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_trendingTvShows);
  }

  final List<TvShow> _airingTodayTvShows;
  @override
  @JsonKey()
  List<TvShow> get airingTodayTvShows {
    if (_airingTodayTvShows is EqualUnmodifiableListView)
      return _airingTodayTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_airingTodayTvShows);
  }

  final List<TvShow> _popularTvShows;
  @override
  @JsonKey()
  List<TvShow> get popularTvShows {
    if (_popularTvShows is EqualUnmodifiableListView) return _popularTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_popularTvShows);
  }

  final List<TvShow> _topRatedTvShows;
  @override
  @JsonKey()
  List<TvShow> get topRatedTvShows {
    if (_topRatedTvShows is EqualUnmodifiableListView) return _topRatedTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topRatedTvShows);
  }

// Genre mappings
  final Map<int, String> _movieGenres;
// Genre mappings
  @override
  @JsonKey()
  Map<int, String> get movieGenres {
    if (_movieGenres is EqualUnmodifiableMapView) return _movieGenres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_movieGenres);
  }

  final Map<int, String> _tvGenres;
  @override
  @JsonKey()
  Map<int, String> get tvGenres {
    if (_tvGenres is EqualUnmodifiableMapView) return _tvGenres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableMapView(_tvGenres);
  }

// Expanded Movie Genres
  final List<Movie> _actionMovies;
// Expanded Movie Genres
  @override
  @JsonKey()
  List<Movie> get actionMovies {
    if (_actionMovies is EqualUnmodifiableListView) return _actionMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_actionMovies);
  }

  final List<Movie> _comedyMovies;
  @override
  @JsonKey()
  List<Movie> get comedyMovies {
    if (_comedyMovies is EqualUnmodifiableListView) return _comedyMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comedyMovies);
  }

  final List<Movie> _horrorMovies;
  @override
  @JsonKey()
  List<Movie> get horrorMovies {
    if (_horrorMovies is EqualUnmodifiableListView) return _horrorMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_horrorMovies);
  }

  final List<Movie> _dramaMovies;
  @override
  @JsonKey()
  List<Movie> get dramaMovies {
    if (_dramaMovies is EqualUnmodifiableListView) return _dramaMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dramaMovies);
  }

  final List<Movie> _sciFiMovies;
  @override
  @JsonKey()
  List<Movie> get sciFiMovies {
    if (_sciFiMovies is EqualUnmodifiableListView) return _sciFiMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sciFiMovies);
  }

  final List<Movie> _adventureMovies;
  @override
  @JsonKey()
  List<Movie> get adventureMovies {
    if (_adventureMovies is EqualUnmodifiableListView) return _adventureMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_adventureMovies);
  }

  final List<Movie> _thrillerMovies;
  @override
  @JsonKey()
  List<Movie> get thrillerMovies {
    if (_thrillerMovies is EqualUnmodifiableListView) return _thrillerMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_thrillerMovies);
  }

  final List<Movie> _romanceMovies;
  @override
  @JsonKey()
  List<Movie> get romanceMovies {
    if (_romanceMovies is EqualUnmodifiableListView) return _romanceMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_romanceMovies);
  }

// Expanded TV Show Genres
  final List<TvShow> _dramaTvShows;
// Expanded TV Show Genres
  @override
  @JsonKey()
  List<TvShow> get dramaTvShows {
    if (_dramaTvShows is EqualUnmodifiableListView) return _dramaTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dramaTvShows);
  }

  final List<TvShow> _comedyTvShows;
  @override
  @JsonKey()
  List<TvShow> get comedyTvShows {
    if (_comedyTvShows is EqualUnmodifiableListView) return _comedyTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_comedyTvShows);
  }

  final List<TvShow> _crimeTvShows;
  @override
  @JsonKey()
  List<TvShow> get crimeTvShows {
    if (_crimeTvShows is EqualUnmodifiableListView) return _crimeTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_crimeTvShows);
  }

  final List<TvShow> _sciFiFantasyTvShows;
  @override
  @JsonKey()
  List<TvShow> get sciFiFantasyTvShows {
    if (_sciFiFantasyTvShows is EqualUnmodifiableListView)
      return _sciFiFantasyTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sciFiFantasyTvShows);
  }

  final List<TvShow> _documentaryTvShows;
  @override
  @JsonKey()
  List<TvShow> get documentaryTvShows {
    if (_documentaryTvShows is EqualUnmodifiableListView)
      return _documentaryTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_documentaryTvShows);
  }

// Expanded Streaming Platforms
  final List<TvShow> _netflixShows;
// Expanded Streaming Platforms
  @override
  @JsonKey()
  List<TvShow> get netflixShows {
    if (_netflixShows is EqualUnmodifiableListView) return _netflixShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_netflixShows);
  }

  final List<TvShow> _amazonPrimeShows;
  @override
  @JsonKey()
  List<TvShow> get amazonPrimeShows {
    if (_amazonPrimeShows is EqualUnmodifiableListView)
      return _amazonPrimeShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amazonPrimeShows);
  }

  final List<TvShow> _disneyPlusShows;
  @override
  @JsonKey()
  List<TvShow> get disneyPlusShows {
    if (_disneyPlusShows is EqualUnmodifiableListView) return _disneyPlusShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_disneyPlusShows);
  }

  final List<TvShow> _huluShows;
  @override
  @JsonKey()
  List<TvShow> get huluShows {
    if (_huluShows is EqualUnmodifiableListView) return _huluShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_huluShows);
  }

  final List<TvShow> _hboMaxShows;
  @override
  @JsonKey()
  List<TvShow> get hboMaxShows {
    if (_hboMaxShows is EqualUnmodifiableListView) return _hboMaxShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hboMaxShows);
  }

  final List<TvShow> _appleTvShows;
  @override
  @JsonKey()
  List<TvShow> get appleTvShows {
    if (_appleTvShows is EqualUnmodifiableListView) return _appleTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_appleTvShows);
  }

  final List<Movie> _netflixMovies;
  @override
  @JsonKey()
  List<Movie> get netflixMovies {
    if (_netflixMovies is EqualUnmodifiableListView) return _netflixMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_netflixMovies);
  }

  final List<Movie> _amazonPrimeMovies;
  @override
  @JsonKey()
  List<Movie> get amazonPrimeMovies {
    if (_amazonPrimeMovies is EqualUnmodifiableListView)
      return _amazonPrimeMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_amazonPrimeMovies);
  }

  final List<Movie> _disneyPlusMovies;
  @override
  @JsonKey()
  List<Movie> get disneyPlusMovies {
    if (_disneyPlusMovies is EqualUnmodifiableListView)
      return _disneyPlusMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_disneyPlusMovies);
  }

// Personalized content
  final List<Movie> _personalizedMovies;
// Personalized content
  @override
  @JsonKey()
  List<Movie> get personalizedMovies {
    if (_personalizedMovies is EqualUnmodifiableListView)
      return _personalizedMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_personalizedMovies);
  }

  final List<TvShow> _personalizedTvShows;
  @override
  @JsonKey()
  List<TvShow> get personalizedTvShows {
    if (_personalizedTvShows is EqualUnmodifiableListView)
      return _personalizedTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_personalizedTvShows);
  }

  final List<Movie> _recommendedMovies;
  @override
  @JsonKey()
  List<Movie> get recommendedMovies {
    if (_recommendedMovies is EqualUnmodifiableListView)
      return _recommendedMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedMovies);
  }

  final List<TvShow> _recommendedTvShows;
  @override
  @JsonKey()
  List<TvShow> get recommendedTvShows {
    if (_recommendedTvShows is EqualUnmodifiableListView)
      return _recommendedTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_recommendedTvShows);
  }

  final List<Movie> _genreBasedMovies;
  @override
  @JsonKey()
  List<Movie> get genreBasedMovies {
    if (_genreBasedMovies is EqualUnmodifiableListView)
      return _genreBasedMovies;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genreBasedMovies);
  }

  final List<TvShow> _genreBasedTvShows;
  @override
  @JsonKey()
  List<TvShow> get genreBasedTvShows {
    if (_genreBasedTvShows is EqualUnmodifiableListView)
      return _genreBasedTvShows;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_genreBasedTvShows);
  }

// Personalization settings
  @override
  @JsonKey()
  final bool isPersonalizationEnabled;
  final List<int> _userPreferredGenres;
  @override
  @JsonKey()
  List<int> get userPreferredGenres {
    if (_userPreferredGenres is EqualUnmodifiableListView)
      return _userPreferredGenres;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userPreferredGenres);
  }

  final List<int> _userPreferredPlatforms;
  @override
  @JsonKey()
  List<int> get userPreferredPlatforms {
    if (_userPreferredPlatforms is EqualUnmodifiableListView)
      return _userPreferredPlatforms;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_userPreferredPlatforms);
  }

// Loading and error states
  @override
  @JsonKey()
  final bool isLoading;
  @override
  final Object? error;

  @override
  String toString() {
    return 'HubState(trendingMovies: $trendingMovies, nowPlayingMovies: $nowPlayingMovies, popularMovies: $popularMovies, topRatedMovies: $topRatedMovies, trendingTvShows: $trendingTvShows, airingTodayTvShows: $airingTodayTvShows, popularTvShows: $popularTvShows, topRatedTvShows: $topRatedTvShows, movieGenres: $movieGenres, tvGenres: $tvGenres, actionMovies: $actionMovies, comedyMovies: $comedyMovies, horrorMovies: $horrorMovies, dramaMovies: $dramaMovies, sciFiMovies: $sciFiMovies, adventureMovies: $adventureMovies, thrillerMovies: $thrillerMovies, romanceMovies: $romanceMovies, dramaTvShows: $dramaTvShows, comedyTvShows: $comedyTvShows, crimeTvShows: $crimeTvShows, sciFiFantasyTvShows: $sciFiFantasyTvShows, documentaryTvShows: $documentaryTvShows, netflixShows: $netflixShows, amazonPrimeShows: $amazonPrimeShows, disneyPlusShows: $disneyPlusShows, huluShows: $huluShows, hboMaxShows: $hboMaxShows, appleTvShows: $appleTvShows, netflixMovies: $netflixMovies, amazonPrimeMovies: $amazonPrimeMovies, disneyPlusMovies: $disneyPlusMovies, personalizedMovies: $personalizedMovies, personalizedTvShows: $personalizedTvShows, recommendedMovies: $recommendedMovies, recommendedTvShows: $recommendedTvShows, genreBasedMovies: $genreBasedMovies, genreBasedTvShows: $genreBasedTvShows, isPersonalizationEnabled: $isPersonalizationEnabled, userPreferredGenres: $userPreferredGenres, userPreferredPlatforms: $userPreferredPlatforms, isLoading: $isLoading, error: $error)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HubStateImpl &&
            const DeepCollectionEquality()
                .equals(other._trendingMovies, _trendingMovies) &&
            const DeepCollectionEquality()
                .equals(other._nowPlayingMovies, _nowPlayingMovies) &&
            const DeepCollectionEquality()
                .equals(other._popularMovies, _popularMovies) &&
            const DeepCollectionEquality()
                .equals(other._topRatedMovies, _topRatedMovies) &&
            const DeepCollectionEquality()
                .equals(other._trendingTvShows, _trendingTvShows) &&
            const DeepCollectionEquality()
                .equals(other._airingTodayTvShows, _airingTodayTvShows) &&
            const DeepCollectionEquality()
                .equals(other._popularTvShows, _popularTvShows) &&
            const DeepCollectionEquality()
                .equals(other._topRatedTvShows, _topRatedTvShows) &&
            const DeepCollectionEquality()
                .equals(other._movieGenres, _movieGenres) &&
            const DeepCollectionEquality().equals(other._tvGenres, _tvGenres) &&
            const DeepCollectionEquality()
                .equals(other._actionMovies, _actionMovies) &&
            const DeepCollectionEquality()
                .equals(other._comedyMovies, _comedyMovies) &&
            const DeepCollectionEquality()
                .equals(other._horrorMovies, _horrorMovies) &&
            const DeepCollectionEquality()
                .equals(other._dramaMovies, _dramaMovies) &&
            const DeepCollectionEquality()
                .equals(other._sciFiMovies, _sciFiMovies) &&
            const DeepCollectionEquality()
                .equals(other._adventureMovies, _adventureMovies) &&
            const DeepCollectionEquality()
                .equals(other._thrillerMovies, _thrillerMovies) &&
            const DeepCollectionEquality()
                .equals(other._romanceMovies, _romanceMovies) &&
            const DeepCollectionEquality()
                .equals(other._dramaTvShows, _dramaTvShows) &&
            const DeepCollectionEquality()
                .equals(other._comedyTvShows, _comedyTvShows) &&
            const DeepCollectionEquality()
                .equals(other._crimeTvShows, _crimeTvShows) &&
            const DeepCollectionEquality()
                .equals(other._sciFiFantasyTvShows, _sciFiFantasyTvShows) &&
            const DeepCollectionEquality()
                .equals(other._documentaryTvShows, _documentaryTvShows) &&
            const DeepCollectionEquality()
                .equals(other._netflixShows, _netflixShows) &&
            const DeepCollectionEquality()
                .equals(other._amazonPrimeShows, _amazonPrimeShows) &&
            const DeepCollectionEquality()
                .equals(other._disneyPlusShows, _disneyPlusShows) &&
            const DeepCollectionEquality()
                .equals(other._huluShows, _huluShows) &&
            const DeepCollectionEquality()
                .equals(other._hboMaxShows, _hboMaxShows) &&
            const DeepCollectionEquality()
                .equals(other._appleTvShows, _appleTvShows) &&
            const DeepCollectionEquality()
                .equals(other._netflixMovies, _netflixMovies) &&
            const DeepCollectionEquality()
                .equals(other._amazonPrimeMovies, _amazonPrimeMovies) &&
            const DeepCollectionEquality()
                .equals(other._disneyPlusMovies, _disneyPlusMovies) &&
            const DeepCollectionEquality()
                .equals(other._personalizedMovies, _personalizedMovies) &&
            const DeepCollectionEquality()
                .equals(other._personalizedTvShows, _personalizedTvShows) &&
            const DeepCollectionEquality()
                .equals(other._recommendedMovies, _recommendedMovies) &&
            const DeepCollectionEquality()
                .equals(other._recommendedTvShows, _recommendedTvShows) &&
            const DeepCollectionEquality()
                .equals(other._genreBasedMovies, _genreBasedMovies) &&
            const DeepCollectionEquality()
                .equals(other._genreBasedTvShows, _genreBasedTvShows) &&
            (identical(
                    other.isPersonalizationEnabled, isPersonalizationEnabled) ||
                other.isPersonalizationEnabled == isPersonalizationEnabled) &&
            const DeepCollectionEquality()
                .equals(other._userPreferredGenres, _userPreferredGenres) &&
            const DeepCollectionEquality().equals(
                other._userPreferredPlatforms, _userPreferredPlatforms) &&
            (identical(other.isLoading, isLoading) ||
                other.isLoading == isLoading) &&
            const DeepCollectionEquality().equals(other.error, error));
  }

  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        const DeepCollectionEquality().hash(_trendingMovies),
        const DeepCollectionEquality().hash(_nowPlayingMovies),
        const DeepCollectionEquality().hash(_popularMovies),
        const DeepCollectionEquality().hash(_topRatedMovies),
        const DeepCollectionEquality().hash(_trendingTvShows),
        const DeepCollectionEquality().hash(_airingTodayTvShows),
        const DeepCollectionEquality().hash(_popularTvShows),
        const DeepCollectionEquality().hash(_topRatedTvShows),
        const DeepCollectionEquality().hash(_movieGenres),
        const DeepCollectionEquality().hash(_tvGenres),
        const DeepCollectionEquality().hash(_actionMovies),
        const DeepCollectionEquality().hash(_comedyMovies),
        const DeepCollectionEquality().hash(_horrorMovies),
        const DeepCollectionEquality().hash(_dramaMovies),
        const DeepCollectionEquality().hash(_sciFiMovies),
        const DeepCollectionEquality().hash(_adventureMovies),
        const DeepCollectionEquality().hash(_thrillerMovies),
        const DeepCollectionEquality().hash(_romanceMovies),
        const DeepCollectionEquality().hash(_dramaTvShows),
        const DeepCollectionEquality().hash(_comedyTvShows),
        const DeepCollectionEquality().hash(_crimeTvShows),
        const DeepCollectionEquality().hash(_sciFiFantasyTvShows),
        const DeepCollectionEquality().hash(_documentaryTvShows),
        const DeepCollectionEquality().hash(_netflixShows),
        const DeepCollectionEquality().hash(_amazonPrimeShows),
        const DeepCollectionEquality().hash(_disneyPlusShows),
        const DeepCollectionEquality().hash(_huluShows),
        const DeepCollectionEquality().hash(_hboMaxShows),
        const DeepCollectionEquality().hash(_appleTvShows),
        const DeepCollectionEquality().hash(_netflixMovies),
        const DeepCollectionEquality().hash(_amazonPrimeMovies),
        const DeepCollectionEquality().hash(_disneyPlusMovies),
        const DeepCollectionEquality().hash(_personalizedMovies),
        const DeepCollectionEquality().hash(_personalizedTvShows),
        const DeepCollectionEquality().hash(_recommendedMovies),
        const DeepCollectionEquality().hash(_recommendedTvShows),
        const DeepCollectionEquality().hash(_genreBasedMovies),
        const DeepCollectionEquality().hash(_genreBasedTvShows),
        isPersonalizationEnabled,
        const DeepCollectionEquality().hash(_userPreferredGenres),
        const DeepCollectionEquality().hash(_userPreferredPlatforms),
        isLoading,
        const DeepCollectionEquality().hash(error)
      ]);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$HubStateImplCopyWith<_$HubStateImpl> get copyWith =>
      __$$HubStateImplCopyWithImpl<_$HubStateImpl>(this, _$identity);
}

abstract class _HubState implements HubState {
  const factory _HubState(
      {final List<Movie> trendingMovies,
      final List<Movie> nowPlayingMovies,
      final List<Movie> popularMovies,
      final List<Movie> topRatedMovies,
      final List<TvShow> trendingTvShows,
      final List<TvShow> airingTodayTvShows,
      final List<TvShow> popularTvShows,
      final List<TvShow> topRatedTvShows,
      final Map<int, String> movieGenres,
      final Map<int, String> tvGenres,
      final List<Movie> actionMovies,
      final List<Movie> comedyMovies,
      final List<Movie> horrorMovies,
      final List<Movie> dramaMovies,
      final List<Movie> sciFiMovies,
      final List<Movie> adventureMovies,
      final List<Movie> thrillerMovies,
      final List<Movie> romanceMovies,
      final List<TvShow> dramaTvShows,
      final List<TvShow> comedyTvShows,
      final List<TvShow> crimeTvShows,
      final List<TvShow> sciFiFantasyTvShows,
      final List<TvShow> documentaryTvShows,
      final List<TvShow> netflixShows,
      final List<TvShow> amazonPrimeShows,
      final List<TvShow> disneyPlusShows,
      final List<TvShow> huluShows,
      final List<TvShow> hboMaxShows,
      final List<TvShow> appleTvShows,
      final List<Movie> netflixMovies,
      final List<Movie> amazonPrimeMovies,
      final List<Movie> disneyPlusMovies,
      final List<Movie> personalizedMovies,
      final List<TvShow> personalizedTvShows,
      final List<Movie> recommendedMovies,
      final List<TvShow> recommendedTvShows,
      final List<Movie> genreBasedMovies,
      final List<TvShow> genreBasedTvShows,
      final bool isPersonalizationEnabled,
      final List<int> userPreferredGenres,
      final List<int> userPreferredPlatforms,
      final bool isLoading,
      final Object? error}) = _$HubStateImpl;

  @override // Standard movie categories
  List<Movie> get trendingMovies;
  @override
  List<Movie> get nowPlayingMovies;
  @override
  List<Movie> get popularMovies;
  @override
  List<Movie> get topRatedMovies;
  @override // Standard TV show categories
  List<TvShow> get trendingTvShows;
  @override
  List<TvShow> get airingTodayTvShows;
  @override
  List<TvShow> get popularTvShows;
  @override
  List<TvShow> get topRatedTvShows;
  @override // Genre mappings
  Map<int, String> get movieGenres;
  @override
  Map<int, String> get tvGenres;
  @override // Expanded Movie Genres
  List<Movie> get actionMovies;
  @override
  List<Movie> get comedyMovies;
  @override
  List<Movie> get horrorMovies;
  @override
  List<Movie> get dramaMovies;
  @override
  List<Movie> get sciFiMovies;
  @override
  List<Movie> get adventureMovies;
  @override
  List<Movie> get thrillerMovies;
  @override
  List<Movie> get romanceMovies;
  @override // Expanded TV Show Genres
  List<TvShow> get dramaTvShows;
  @override
  List<TvShow> get comedyTvShows;
  @override
  List<TvShow> get crimeTvShows;
  @override
  List<TvShow> get sciFiFantasyTvShows;
  @override
  List<TvShow> get documentaryTvShows;
  @override // Expanded Streaming Platforms
  List<TvShow> get netflixShows;
  @override
  List<TvShow> get amazonPrimeShows;
  @override
  List<TvShow> get disneyPlusShows;
  @override
  List<TvShow> get huluShows;
  @override
  List<TvShow> get hboMaxShows;
  @override
  List<TvShow> get appleTvShows;
  @override
  List<Movie> get netflixMovies;
  @override
  List<Movie> get amazonPrimeMovies;
  @override
  List<Movie> get disneyPlusMovies;
  @override // Personalized content
  List<Movie> get personalizedMovies;
  @override
  List<TvShow> get personalizedTvShows;
  @override
  List<Movie> get recommendedMovies;
  @override
  List<TvShow> get recommendedTvShows;
  @override
  List<Movie> get genreBasedMovies;
  @override
  List<TvShow> get genreBasedTvShows;
  @override // Personalization settings
  bool get isPersonalizationEnabled;
  @override
  List<int> get userPreferredGenres;
  @override
  List<int> get userPreferredPlatforms;
  @override // Loading and error states
  bool get isLoading;
  @override
  Object? get error;
  @override
  @JsonKey(ignore: true)
  _$$HubStateImplCopyWith<_$HubStateImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
