import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:lets_stream/src/core/api/anime_api.dart';
import 'package:lets_stream/src/features/anime/application/anime_player_notifier.dart';
import 'package:lets_stream/src/features/anime/application/anime_player_state.dart';
import 'package:lets_stream/src/features/anime/presentation/widgets/anime_server_selector.dart';
import 'package:lets_stream/src/features/anime/presentation/widgets/custom_anime_controls.dart';
import 'package:lets_stream/src/features/anime/presentation/widgets/quality_selector_widget.dart';
import 'package:lets_stream/src/features/anime/presentation/widgets/subtitle_selector_widget.dart';

/// Provider for the anime player notifier.
final animePlayerNotifierProvider = StateNotifierProvider.family<
    AnimePlayerNotifier, AnimePlayerState, ({String animeId, String episodeId})>((ref, params) {
  final animeApi = AnimeApi(Dio());
  return AnimePlayerNotifier(animeApi);
});

/// Main anime player screen with Chewie video player.
///
/// This screen provides a full-screen anime playback experience with
/// server selection, episode navigation, and custom controls.
class AnimePlayerScreen extends ConsumerStatefulWidget {
  /// The Anime API ID of the anime to play.
  final String animeId;

  /// The episode ID to start with (optional).
  final String? episodeId;

  /// Creates a new AnimePlayerScreen instance.
  const AnimePlayerScreen({
    super.key,
    required this.animeId,
    this.episodeId,
  });

  @override
  ConsumerState<AnimePlayerScreen> createState() => _AnimePlayerScreenState();
}

class _AnimePlayerScreenState extends ConsumerState<AnimePlayerScreen> {
  @override
  void initState() {
    super.initState();
    
    // Set preferred orientations for video playback
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    // Hide system UI for immersive experience
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    
    // Load the anime
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAnime();
    });
  }

  @override
  void dispose() {
    // Restore system UI
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    
    // Restore preferred orientations
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final params = (animeId: widget.animeId, episodeId: widget.episodeId ?? '');
    final playerState = ref.watch(animePlayerNotifierProvider(params));
    final playerNotifier = ref.read(animePlayerNotifierProvider(params).notifier);

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Main video player with custom controls
            CustomAnimeControls(
              state: playerState,
              notifier: playerNotifier,
            ),
            
            // Server selector
            if (playerState.showServerSelector)
              _buildServerSelectorOverlay(playerState, playerNotifier),
            
            // Quality selector
            if (playerState.availableQualities.isNotEmpty)
              _buildQualitySelector(playerState, playerNotifier),
            
            // Subtitle selector
            if (playerState.streamData?.hasSubtitles == true)
              _buildSubtitleSelector(playerState, playerNotifier),
          ],
        ),
      ),
    );
  }

  /// Builds the quality selector overlay.
  Widget _buildQualitySelector(AnimePlayerState state, AnimePlayerNotifier notifier) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => notifier.toggleServerSelector(), // Close quality selector
        child: Container(
          color: Colors.black54,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping the selector
              child: QualitySelectorWidget(
                qualities: state.availableQualities,
                selectedQuality: state.selectedQuality,
                isAutoQuality: state.isAutoQuality,
                onQualitySelected: notifier.setQuality,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the subtitle selector overlay.
  Widget _buildSubtitleSelector(AnimePlayerState state, AnimePlayerNotifier notifier) {
    return Positioned.fill(
      child: GestureDetector(
        onTap: () => notifier.toggleServerSelector(), // Close subtitle selector
        child: Container(
          color: Colors.black54,
          child: Center(
            child: GestureDetector(
              onTap: () {}, // Prevent closing when tapping the selector
              child: SubtitleSelectorWidget(
                subtitleTracks: state.streamData?.streamingLink.tracks ?? [],
                selectedSubtitle: state.selectedSubtitle,
                subtitlesEnabled: state.subtitlesEnabled,
                onSubtitleSelected: notifier.setSubtitleTrack,
                onSubtitlesToggled: (enabled) => notifier.toggleSubtitles(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Builds the server selector overlay.
  Widget _buildServerSelectorOverlay(
    AnimePlayerState state,
    AnimePlayerNotifier notifier,
  ) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        child: Center(
          child: Container(
            margin: const EdgeInsets.all(32),
            child: AnimeServerSelector(
              servers: state.availableServers,
              selectedServer: state.selectedServer,
              selectedType: state.selectedType,
              onServerSelected: notifier.selectServer,
              onTypeChanged: notifier.switchType,
            ),
          ),
        ),
      ),
    );
  }


  /// Loads the anime and starts playback.
  Future<void> _loadAnime() async {
    final params = (animeId: widget.animeId, episodeId: widget.episodeId ?? '');
    final notifier = ref.read(animePlayerNotifierProvider(params).notifier);
    
    await notifier.loadAnime(widget.animeId);
  }
}
