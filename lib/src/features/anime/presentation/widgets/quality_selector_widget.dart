import 'package:flutter/material.dart';
import 'package:lets_stream/src/features/anime/application/models/quality_option.dart';

/// A widget that displays a list of available video quality options.
///
/// Allows users to select from different video qualities or enable auto-quality mode.
class QualitySelectorWidget extends StatelessWidget {
  /// The list of available quality options.
  final List<QualityOption> qualities;

  /// The currently selected quality option.
  final QualityOption? selectedQuality;

  /// Whether auto-quality mode is enabled.
  final bool isAutoQuality;

  /// Callback when a quality option is selected.
  final Function(QualityOption) onQualitySelected;

  /// Creates a new QualitySelectorWidget instance.
  const QualitySelectorWidget({
    super.key,
    required this.qualities,
    required this.selectedQuality,
    required this.isAutoQuality,
    required this.onQualitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Video Quality',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Auto quality toggle
          ListTile(
            leading: Icon(
              isAutoQuality ? Icons.check_circle : Icons.radio_button_unchecked,
              color: isAutoQuality ? Colors.blue : Colors.grey,
            ),
            title: const Text(
              'Auto',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: const Text(
              'Automatically adjust quality based on network',
              style: TextStyle(color: Colors.grey),
            ),
            onTap: () {
              final autoQuality = qualities.firstWhere(
                (q) => q.isAuto,
                orElse: () => qualities.first,
              );
              onQualitySelected(autoQuality);
            },
          ),

          const Divider(color: Colors.grey),

          // Quality options
          ...qualities.where((q) => !q.isAuto).map((quality) {
            final isSelected = selectedQuality == quality;

            return ListTile(
              leading: Icon(
                isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                color: isSelected ? Colors.blue : Colors.grey,
              ),
              title: Text(
                quality.label,
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              subtitle: Text(
                '${quality.height}p • ${quality.bitrate}kbps',
                style: const TextStyle(color: Colors.grey),
              ),
              trailing: _buildQualityIndicator(quality),
              onTap: () => onQualitySelected(quality),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQualityIndicator(QualityOption quality) {
    Color indicatorColor;
    String indicatorText;

    if (quality.height >= 1080) {
      indicatorColor = Colors.green;
      indicatorText = 'HD';
    } else if (quality.height >= 720) {
      indicatorColor = Colors.blue;
      indicatorText = 'HD';
    } else if (quality.height >= 480) {
      indicatorColor = Colors.orange;
      indicatorText = 'SD';
    } else {
      indicatorColor = Colors.red;
      indicatorText = 'Low';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: indicatorColor.withAlpha(51),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: indicatorColor, width: 1),
      ),
      child: Text(
        indicatorText,
        style: TextStyle(
          color: indicatorColor,
          fontSize: 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

/// Bottom sheet wrapper for quality selector.
class QualitySelectorBottomSheet extends StatelessWidget {
  /// The list of available quality options.
  final List<QualityOption> qualities;

  /// The currently selected quality option.
  final QualityOption? selectedQuality;

  /// Whether auto-quality mode is enabled.
  final bool isAutoQuality;

  /// Callback when a quality option is selected.
  final Function(QualityOption) onQualitySelected;

  const QualitySelectorBottomSheet({
    super.key,
    required this.qualities,
    required this.selectedQuality,
    required this.isAutoQuality,
    required this.onQualitySelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: QualitySelectorWidget(
          qualities: qualities,
          selectedQuality: selectedQuality,
          isAutoQuality: isAutoQuality,
          onQualitySelected: (quality) {
            onQualitySelected(quality);
            Navigator.of(context).pop();
          },
        ),
      ),
    );
  }
}

/// Shows the quality selector as a bottom sheet.
void showQualitySelector({
  required BuildContext context,
  required List<QualityOption> qualities,
  required QualityOption? selectedQuality,
  required bool isAutoQuality,
  required Function(QualityOption) onQualitySelected,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => QualitySelectorBottomSheet(
      qualities: qualities,
      selectedQuality: selectedQuality,
      isAutoQuality: isAutoQuality,
      onQualitySelected: onQualitySelected,
    ),
  );
}
