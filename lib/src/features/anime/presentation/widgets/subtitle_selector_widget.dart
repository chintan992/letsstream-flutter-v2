import 'package:flutter/material.dart';
import 'package:lets_stream/src/core/models/anime/anime_subtitle_track.dart';

/// Widget for selecting subtitle tracks.
/// A widget that displays a list of available subtitle tracks.
///
/// Allows users to enable/disable subtitles and select from different subtitle tracks.
class SubtitleSelectorWidget extends StatelessWidget {
  /// The list of available subtitle tracks.
  final List<AnimeSubtitleTrack> subtitleTracks;

  /// The currently selected subtitle track.
  final AnimeSubtitleTrack? selectedSubtitle;

  /// Whether subtitles are enabled.
  final bool subtitlesEnabled;

  /// Callback when a subtitle track is selected.
  final Function(AnimeSubtitleTrack?) onSubtitleSelected;

  /// Callback when subtitles are toggled on/off.
  final Function(bool) onSubtitlesToggled;

  const SubtitleSelectorWidget({
    super.key,
    required this.subtitleTracks,
    required this.selectedSubtitle,
    required this.subtitlesEnabled,
    required this.onSubtitleSelected,
    required this.onSubtitlesToggled,
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
          Row(
            children: [
              const Text(
                'Subtitles',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Switch(
                value: subtitlesEnabled,
                onChanged: onSubtitlesToggled,
                activeThumbColor: Colors.blue,
              ),
            ],
          ),
          if (subtitlesEnabled) ...[
            const SizedBox(height: 20),

            // Off option
            ListTile(
              leading: Icon(
                selectedSubtitle == null
                    ? Icons.check_circle
                    : Icons.radio_button_unchecked,
                color: selectedSubtitle == null ? Colors.blue : Colors.grey,
              ),
              title: const Text(
                'Off',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () => onSubtitleSelected(null),
            ),

            const Divider(color: Colors.grey),

            // Subtitle tracks
            ...subtitleTracks.map((track) {
              final isSelected = selectedSubtitle == track;

              return ListTile(
                leading: Icon(
                  isSelected
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: isSelected ? Colors.blue : Colors.grey,
                ),
                title: Text(
                  track.displayName,
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                subtitle: Text(
                  track.label,
                  style: const TextStyle(color: Colors.grey),
                ),
                trailing: track.isDefault
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2,),
                        decoration: BoxDecoration(
                          color: Colors.blue.withAlpha(51),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'Default',
                          style: TextStyle(
                            color: Colors.blue,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    : null,
                onTap: () => onSubtitleSelected(track),
              );
            }),
          ],
        ],
      ),
    );
  }
}

/// Bottom sheet wrapper for subtitle selector.
class SubtitleSelectorBottomSheet extends StatelessWidget {
  /// The list of available subtitle tracks.
  final List<AnimeSubtitleTrack> subtitleTracks;

  /// The currently selected subtitle track.
  final AnimeSubtitleTrack? selectedSubtitle;

  /// Whether subtitles are enabled.
  final bool subtitlesEnabled;

  /// Callback when a subtitle track is selected.
  final Function(AnimeSubtitleTrack?) onSubtitleSelected;

  /// Callback when subtitles are toggled on/off.
  final Function(bool) onSubtitlesToggled;

  const SubtitleSelectorBottomSheet({
    super.key,
    required this.subtitleTracks,
    required this.selectedSubtitle,
    required this.subtitlesEnabled,
    required this.onSubtitleSelected,
    required this.onSubtitlesToggled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SafeArea(
        child: SubtitleSelectorWidget(
          subtitleTracks: subtitleTracks,
          selectedSubtitle: selectedSubtitle,
          subtitlesEnabled: subtitlesEnabled,
          onSubtitleSelected: (subtitle) {
            onSubtitleSelected(subtitle);
            Navigator.of(context).pop();
          },
          onSubtitlesToggled: (enabled) {
            onSubtitlesToggled(enabled);
          },
        ),
      ),
    );
  }
}

/// Shows the subtitle selector as a bottom sheet.
void showSubtitleSelector({
  required BuildContext context,
  required List<AnimeSubtitleTrack> subtitleTracks,
  required AnimeSubtitleTrack? selectedSubtitle,
  required bool subtitlesEnabled,
  required Function(AnimeSubtitleTrack?) onSubtitleSelected,
  required Function(bool) onSubtitlesToggled,
}) {
  showModalBottomSheet(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (context) => SubtitleSelectorBottomSheet(
      subtitleTracks: subtitleTracks,
      selectedSubtitle: selectedSubtitle,
      subtitlesEnabled: subtitlesEnabled,
      onSubtitleSelected: onSubtitleSelected,
      onSubtitlesToggled: onSubtitlesToggled,
    ),
  );
}
