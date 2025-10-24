/// Represents a video quality option for HLS streams.
class QualityOption {
  /// The quality label (e.g., "1080p", "720p", "Auto").
  final String label;
  
  /// The quality height in pixels.
  final int height;
  
  /// The bitrate in kbps.
  final int bitrate;
  
  /// The HLS stream URL for this quality.
  final String url;
  
  /// Whether this is the auto quality option.
  final bool isAuto;
  
  /// Whether this quality is currently selected.
  final bool isSelected;

  const QualityOption({
    required this.label,
    required this.height,
    required this.bitrate,
    required this.url,
    this.isAuto = false,
    this.isSelected = false,
  });

  /// Creates a copy with updated fields.
  QualityOption copyWith({
    String? label,
    int? height,
    int? bitrate,
    String? url,
    bool? isAuto,
    bool? isSelected,
  }) {
    return QualityOption(
      label: label ?? this.label,
      height: height ?? this.height,
      bitrate: bitrate ?? this.bitrate,
      url: url ?? this.url,
      isAuto: isAuto ?? this.isAuto,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  String toString() {
    return 'QualityOption(label: $label, height: ${height}p, bitrate: ${bitrate}kbps)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is QualityOption &&
        other.label == label &&
        other.height == height &&
        other.bitrate == bitrate;
  }

  @override
  int get hashCode => Object.hash(label, height, bitrate);
}
