/// Represents a streaming server for an anime episode.
///
/// This model encapsulates server information including the server type (sub/dub),
/// server identification, and display name.
class AnimeServer {
  /// The type of server (e.g., "sub" for subtitled, "dub" for dubbed).
  final String type;

  /// The data ID associated with this server.
  final String dataId;

  /// The server ID for this specific server instance.
  final String serverId;

  /// The display name of the server (e.g., "HD-1", "HD-2").
  final String serverName;

  /// Creates a new AnimeServer instance.
  const AnimeServer({
    required this.type,
    required this.dataId,
    required this.serverId,
    required this.serverName,
  });

  /// Creates an AnimeServer instance from a JSON map.
  ///
  /// [json] A map containing server data from the Anime API.
  factory AnimeServer.fromJson(Map<String, dynamic> json) {
    return AnimeServer(
      type: json['type'] as String,
      dataId: json['data_id'].toString(),
      serverId: json['server_id'].toString(),
      serverName: json['serverName'] as String,
    );
  }

  /// Converts the AnimeServer instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'data_id': dataId,
      'server_id': serverId,
      'serverName': serverName,
    };
  }

  /// Returns true if this is a subtitled server.
  bool get isSub => type.toLowerCase() == 'sub';

  /// Returns true if this is a dubbed server.
  bool get isDub => type.toLowerCase() == 'dub';

  /// Returns a user-friendly display name with type indication.
  String get displayName {
    final typeLabel = isSub ? 'Sub' : 'Dub';
    return '$typeLabel - $serverName';
  }

  /// Returns a short display name for UI components.
  String get shortDisplayName => serverName;

  @override
  String toString() {
    return 'AnimeServer(type: $type, serverId: $serverId, serverName: $serverName)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimeServer &&
        other.type == type &&
        other.serverId == serverId;
  }

  @override
  int get hashCode => Object.hash(type, serverId);
}
