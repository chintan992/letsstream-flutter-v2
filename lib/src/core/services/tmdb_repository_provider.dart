import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'simple_cached_repository.dart';

final tmdbRepositoryProvider = Provider<SimpleCachedRepository>((ref) {
  return SimpleCachedRepository();
});
