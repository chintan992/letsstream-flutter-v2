import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/services/tmdb_repository.dart';

final tmdbRepositoryProvider = Provider<TmdbRepository>((ref) {
  return TmdbRepository();
});