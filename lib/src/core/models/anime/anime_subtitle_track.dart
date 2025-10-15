/// Represents a subtitle track for an anime stream.
///
/// This model encapsulates subtitle track information including the file URL,
/// language label, track kind, and whether it's the default track.
class AnimeSubtitleTrack {
  /// The URL to the subtitle file (usually a .vtt file).
  final String file;

  /// The human-readable label for the subtitle language.
  final String label;

  /// The kind of track (typically "captions").
  final String kind;

  /// Whether this is the default subtitle track.
  final bool isDefault;

  /// Creates a new AnimeSubtitleTrack instance.
  const AnimeSubtitleTrack({
    required this.file,
    required this.label,
    required this.kind,
    this.isDefault = false,
  });

  /// Creates an AnimeSubtitleTrack instance from a JSON map.
  ///
  /// [json] A map containing subtitle track data from the Anime API.
  factory AnimeSubtitleTrack.fromJson(Map<String, dynamic> json) {
    return AnimeSubtitleTrack(
      file: json['file'] as String,
      label: json['label'] as String,
      kind: json['kind'] as String,
      isDefault: json['default'] as bool? ?? false,
    );
  }

  /// Converts the AnimeSubtitleTrack instance to a JSON-serializable map.
  Map<String, dynamic> toJson() {
    return {
      'file': file,
      'label': label,
      'kind': kind,
      'default': isDefault,
    };
  }

  /// Extracts the language code from the label if available.
  /// Returns null if no language code can be determined.
  String? get languageCode {
    // Try to extract language from common patterns
    final patterns = [
      RegExp(r'^(\w+)'), // First word (e.g., "English", "Spanish")
      RegExp(r'(\w+)\s*\('), // Word before parenthesis (e.g., "Spanish (España)")
      RegExp(r'-\s*(\w+)'), // Word after dash (e.g., "Spanish - Español")
    ];

    for (final pattern in patterns) {
      final match = pattern.firstMatch(label);
      if (match != null) {
        return match.group(1)?.toLowerCase();
      }
    }
    return null;
  }

  /// Returns a simplified language name for display.
  String get displayName {
    // Remove common suffixes and parentheses
    return label
        .replaceAll(RegExp(r'\s*\([^)]*\)'), '') // Remove (Spanish)
        .replaceAll(RegExp(r'-\s*[^-]*$'), '') // Remove - Español
        .trim();
  }

  @override
  String toString() {
    return 'AnimeSubtitleTrack(file: $file, label: $label, isDefault: $isDefault)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AnimeSubtitleTrack &&
        other.file == file &&
        other.label == label;
  }

  @override
  int get hashCode => Object.hash(file, label);
}
