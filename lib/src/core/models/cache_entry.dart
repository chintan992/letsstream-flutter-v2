import 'package:hive/hive.dart';

part 'cache_entry.g.dart';

/// A Hive-compatible model for caching API responses and data.
///
/// This class stores cached data with time-to-live (TTL) functionality
/// to automatically expire old cache entries. It's designed to work
/// with the Hive NoSQL database for local data persistence.
///
/// The cache entry includes the data payload, creation timestamp,
/// and TTL duration to determine when the cache should expire.
@HiveType(typeId: 2)
class CacheEntry {
  /// The cached data payload.
  ///
  /// Can contain any serializable data structure that needs to be cached.
  @HiveField(0)
  final List<dynamic> data;

  /// The timestamp when this cache entry was created.
  ///
  /// Used to determine if the cache entry has expired based on TTL.
  @HiveField(1)
  final DateTime createdAt;

  /// Time-to-live duration in milliseconds.
  ///
  /// Determines how long this cache entry should be considered valid.
  @HiveField(2)
  final int ttlMs;

  /// Creates a new cache entry with the specified data and TTL.
  ///
  /// [data] The data to cache.
  /// [createdAt] When the cache entry was created (defaults to now).
  /// [ttlMs] Time-to-live in milliseconds.
  CacheEntry({
    required this.data,
    required this.createdAt,
    required this.ttlMs,
  });

  /// Gets the TTL duration as a [Duration] object.
  ///
  /// Converts the millisecond-based TTL to a [Duration] for easier manipulation.
  Duration get ttl => Duration(milliseconds: ttlMs);

  /// Checks if this cache entry has expired.
  ///
  /// Returns true if the current time is past the creation time plus TTL duration.
  bool get isExpired {
    return DateTime.now().isAfter(createdAt.add(ttl));
  }

  /// Checks if this cache entry is still valid (not expired).
  ///
  /// Returns true if the cache entry has not expired and can be used.
  bool get isValid => !isExpired;
}
