import 'package:hive/hive.dart';

part 'cache_entry.g.dart';

@HiveType(typeId: 2)
class CacheEntry {
  @HiveField(0)
  final List<dynamic> data;

  @HiveField(1)
  final DateTime createdAt;

  @HiveField(2)
  final int ttlMs;

  CacheEntry({
    required this.data,
    required this.createdAt,
    required this.ttlMs,
  });

  Duration get ttl => Duration(milliseconds: ttlMs);

  bool get isExpired {
    return DateTime.now().isAfter(createdAt.add(ttl));
  }

  bool get isValid => !isExpired;
}
