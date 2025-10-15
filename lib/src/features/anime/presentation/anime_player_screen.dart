import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:chewie/chewie.dart';
import 'package:dio/dio.dart';
import 'package:lets_stream/src/core/api/anime_api.dart';
import 'package:lets_stream/src/features/anime/application/anime_player_notifier.dart';
import 'package:lets_stream/src/features/anime/application/anime_player_state.dart';
import 'package:lets_stream/src/features/anime/presentation/widgets/anime_server_selector.dart';

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
            // Main video player
            _buildVideoPlayer(playerState),
            
            // Loading overlay
            if (playerState.isLoading)
              _buildLoadingOverlay(),
            
            // Error overlay
            if (playerState.error != null)
              _buildErrorOverlay(playerState.error!, playerNotifier),
            
            // Custom controls overlay
            if (!playerState.isLoading && playerState.error == null)
              _buildControlsOverlay(playerState, playerNotifier),
            
            // Server selector
            if (playerState.showServerSelector)
              _buildServerSelectorOverlay(playerState, playerNotifier),
            
            // Skip buttons
            _buildSkipButtons(playerState, playerNotifier),
          ],
        ),
      ),
    );
  }

  /// Builds the main video player.
  Widget _buildVideoPlayer(AnimePlayerState state) {
    if (state.chewieController != null) {
      return Center(
        child: AspectRatio(
          aspectRatio: 16 / 9,
          child: Chewie(controller: state.chewieController!),
        ),
      );
    } else {
      return Container(
        color: Colors.black,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.play_circle_outline,
                size: 64,
                color: Colors.white54,
              ),
              SizedBox(height: 16),
              Text(
                'Loading video...',
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  /// Builds the loading overlay.
  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            SizedBox(height: 16),
            Text(
              'Loading...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds the error overlay.
  Widget _buildErrorOverlay(String error, AnimePlayerNotifier notifier) {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              Text(
                'Error',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                error,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => notifier.clearError(),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the custom controls overlay.
  Widget _buildControlsOverlay(
    AnimePlayerState state,
    AnimePlayerNotifier notifier,
  ) {
    return Positioned(
      top: 16,
      left: 16,
      right: 16,
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              shape: const CircleBorder(),
            ),
          ),
          
          const Spacer(),
          
          // Episode info
          if (state.currentEpisode != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Episode ${state.currentEpisode!.episodeNo}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          
          const SizedBox(width: 8),
          
          // Server selector button
          if (state.hasMultipleServers)
            IconButton(
              onPressed: notifier.toggleServerSelector,
              icon: const Icon(Icons.settings, color: Colors.white),
              style: IconButton.styleFrom(
                backgroundColor: Colors.black54,
                shape: const CircleBorder(),
              ),
            ),
        ],
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

  /// Builds the skip buttons (intro/outro).
  Widget _buildSkipButtons(
    AnimePlayerState state,
    AnimePlayerNotifier notifier,
  ) {
    return Positioned(
      bottom: 100,
      right: 16,
      child: Column(
        children: [
          if (state.shouldShowIntroSkip)
            _buildSkipButton(
              'Skip Intro',
              Icons.fast_forward,
              notifier.skipIntro,
            ),
          if (state.shouldShowOutroSkip)
            _buildSkipButton(
              'Skip Outro',
              Icons.fast_forward,
              notifier.skipOutro,
            ),
        ],
      ),
    );
  }

  /// Builds a skip button.
  Widget _buildSkipButton(String label, IconData icon, VoidCallback onPressed) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
