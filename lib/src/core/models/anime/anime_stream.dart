import 'anime_server.dart';
import 'anime_subtitle_track.dart';

/// Represents streaming data for an anime episode.
///
/// This model encapsulates all streaming-related information including the
/// streaming link, subtitle tracks, intro/outro timestamps, and available servers.
class AnimeStream {
  /// The streaming link information.
  final AnimeStreamingLink streamingLink;

  /// The list of available servers for this episode.
  final List<AnimeServer> servers;

  /// Creates a new AnimeStream instance.
  const AnimeStream({
    required this.streamingLink,
    required this.servers,
  });

  /// Creates an AnimeStream instance from a JSON map.
  ///
  /// [json] A map containing streaming data from the Anime API.
  factory AnimeStream.fromJson(Map<String, dynamic> json) {
    return AnimeStream(
      streamingLink: AnimeStreamingLink.fromJson(
        json['streamingLink'] as Map<String, dynamic>,
      ),
      servers: (json['servers'] as List<dynamic>)
          .map((serverJson) => AnimeServer.fromJson(serverJson as Map<String, dynamic>))
          .toList(),
    );
  }

  /// Converts the AnimeStream instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'streamingLink': streamingLink.toJson(),
      'servers': servers.map((server) => server.toJson()).toList(),
    };
  }

  /// Returns the HLS stream URL for video playback.
  String? get streamUrl => streamingLink.link.file;

  /// Returns true if this stream has subtitles available.
  bool get hasSubtitles => streamingLink.tracks.isNotEmpty;

  /// Returns the default subtitle track if available.
  AnimeSubtitleTrack? get defaultSubtitle {
    try {
      return streamingLink.tracks.firstWhere((track) => track.isDefault);
    } catch (_) {
      return streamingLink.tracks.isNotEmpty ? streamingLink.tracks.first : null;
    }
  }

  /// Returns subtitle tracks grouped by language.
  Map<String, List<AnimeSubtitleTrack>> get subtitlesByLanguage {
    final Map<String, List<AnimeSubtitleTrack>> grouped = {};
    for (final track in streamingLink.tracks) {
      final language = track.languageCode ?? 'unknown';
      grouped.putIfAbsent(language, () => []).add(track);
    }
    return grouped;
  }

  /// Returns true if intro skip is available.
  bool get hasIntro => streamingLink.intro != null;

  /// Returns true if outro skip is available.
  bool get hasOutro => streamingLink.outro != null;

  @override
  String toString() {
    return 'AnimeStream(streamUrl: $streamUrl, hasSubtitles: $hasSubtitles, servers: ${servers.length})';
  }
}

/// Represents streaming link information for an anime episode.
class AnimeStreamingLink {
  /// The unique identifier for this streaming link.
  final String id;

  /// The type of stream (e.g., "sub", "dub").
  final String type;

  /// The streaming link details.
  final AnimeStreamLink link;

  /// The list of subtitle tracks.
  final List<AnimeSubtitleTrack> tracks;

  /// The intro timestamp information.
  final AnimeTimestamp? intro;

  /// The outro timestamp information.
  final AnimeTimestamp? outro;

  /// The iframe URL for fallback playback.
  final String? iframe;

  /// The server name.
  final String server;

  /// Creates a new AnimeStreamingLink instance.
  const AnimeStreamingLink({
    required this.id,
    required this.type,
    required this.link,
    required this.tracks,
    this.intro,
    this.outro,
    this.iframe,
    required this.server,
  });

  /// Creates an AnimeStreamingLink instance from a JSON map.
  factory AnimeStreamingLink.fromJson(Map<String, dynamic> json) {
    return AnimeStreamingLink(
      id: json['id'].toString(),
      type: json['type'] as String,
      link: AnimeStreamLink.fromJson(json['link'] as Map<String, dynamic>),
      tracks: (json['tracks'] as List<dynamic>)
          .map((trackJson) => AnimeSubtitleTrack.fromJson(trackJson as Map<String, dynamic>))
          .toList(),
      intro: json['intro'] != null
          ? AnimeTimestamp.fromJson(json['intro'] as Map<String, dynamic>)
          : null,
      outro: json['outro'] != null
          ? AnimeTimestamp.fromJson(json['outro'] as Map<String, dynamic>)
          : null,
      iframe: json['iframe'] as String?,
      server: json['server'] as String,
    );
  }

  /// Converts the AnimeStreamingLink instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'link': link.toJson(),
      'tracks': tracks.map((track) => track.toJson()).toList(),
      'intro': intro?.toJson(),
      'outro': outro?.toJson(),
      'iframe': iframe,
      'server': server,
    };
  }
}

/// Represents a streaming link with file URL and type.
class AnimeStreamLink {
  /// The URL to the streaming file (usually HLS .m3u8).
  final String file;

  /// The type of stream file (e.g., "hls").
  final String type;

  /// Creates a new AnimeStreamLink instance.
  const AnimeStreamLink({
    required this.file,
    required this.type,
  });

  /// Creates an AnimeStreamLink instance from a JSON map.
  factory AnimeStreamLink.fromJson(Map<String, dynamic> json) {
    return AnimeStreamLink(
      file: json['file'] as String,
      type: json['type'] as String,
    );
  }

  /// Converts the AnimeStreamLink instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'type': type,
    };
  }
}

/// Represents timestamp information for intro/outro segments.
class AnimeTimestamp {
  /// The start time in seconds.
  final int start;

  /// The end time in seconds.
  final int end;

  /// Creates a new AnimeTimestamp instance.
  const AnimeTimestamp({
    required this.start,
    required this.end,
  });

  /// Creates an AnimeTimestamp instance from a JSON map.
  factory AnimeTimestamp.fromJson(Map<String, dynamic> json) {
    return AnimeTimestamp(
      start: json['start'] as int,
      end: json['end'] as int,
    );
  }

  /// Converts the AnimeTimestamp instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }

  /// Returns the duration of the segment in seconds.
  int get duration => end - start;

  /// Returns a formatted duration string (e.g., "2m 30s").
  String get formattedDuration {
    final minutes = duration ~/ 60;
    final seconds = duration % 60;
    if (minutes > 0) {
      return '${minutes}m ${seconds}s';
    }
    return '${seconds}s';
  }
}
