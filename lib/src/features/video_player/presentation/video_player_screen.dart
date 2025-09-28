import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/core/services/native_pip_service.dart';
import 'package:lets_stream/src/features/video_player/application/video_player_notifier.dart';

class VideoPlayerScreen extends ConsumerStatefulWidget {
  final int tmdbId;
  final bool isMovie;
  final int? season;
  final int? episode;

  const VideoPlayerScreen({
    super.key,
    required this.tmdbId,
    required this.isMovie,
    this.season,
    this.episode,
  });

  @override
  VideoPlayerScreenState createState() => VideoPlayerScreenState();
}

class VideoPlayerScreenState extends ConsumerState<VideoPlayerScreen> {
  bool _showControls = true;
  Timer? _hideControlsTimer;
  late final NativePipService _pipService;
  StreamSubscription<bool>? _pipModeSubscription;
  bool _isInPipMode = false;

  @override
  void initState() {
    super.initState();
    _startHideControlsTimer();
    _initializePip();
  }

  void _initializePip() {
    // Initialize PIP service
    _pipService = NativePipService();
    _pipService.initialize();
    
    // Listen to PIP mode changes
    _pipModeSubscription = _pipService.pipModeStream.listen((isInPip) {
      if (mounted) {
        setState(() {
          _isInPipMode = isInPip;
          // Hide controls when entering PIP mode
          if (isInPip) {
            _showControls = false;
            _hideControlsTimer?.cancel();
          }
        });
        
        // Update provider state to match PIP mode
        final provider = videoPlayerNotifierProvider((
          mediaId: widget.tmdbId,
          mediaType: widget.isMovie ? 'movie' : 'tv',
          seasonNumber: widget.season,
          episodeNumber: widget.episode,
        ));
        final notifier = ref.read(provider.notifier);
        notifier.setPipActive(isInPip);
        
        print('🔄 PIP mode changed in UI: $_isInPipMode, provider updated: $isInPip');
      }
    });

    // Delay the provider PIP initialization to avoid modifying provider during build
    Future(() async {
      final provider = videoPlayerNotifierProvider((
        mediaId: widget.tmdbId,
        mediaType: widget.isMovie ? 'movie' : 'tv',
        seasonNumber: widget.season,
        episodeNumber: widget.episode,
      ));
      final notifier = ref.read(provider.notifier);
      await notifier.initializePip();
    });
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    // Get current provider state to check PIP status
    final provider = videoPlayerNotifierProvider((
      mediaId: widget.tmdbId,
      mediaType: widget.isMovie ? 'movie' : 'tv',
      seasonNumber: widget.season,
      episodeNumber: widget.episode,
    ));
    final state = ref.read(provider);
    
    // Don't allow control toggle when in PIP mode
    if (state.isPipActive) return;
    
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _pipModeSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = videoPlayerNotifierProvider((
      mediaId: widget.tmdbId,
      mediaType: widget.isMovie ? 'movie' : 'tv',
      seasonNumber: widget.season,
      episodeNumber: widget.episode,
    ));
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    // Debug UI state
    print('🖥️ VideoPlayerScreen build - isPipActive: ${state.isPipActive}, videoUrl: ${state.videoUrl != null ? "present" : "null"}');

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (state.errorMessage != null)
              Center(
                child: Text(
                  state.errorMessage!,
                  style: const TextStyle(color: Colors.white),
                ),
              )
            else if (state.videoUrl != null && !state.isPipActive)
              InAppWebView(
                key: ValueKey(
                  state.videoUrl,
                ), // Add a key to force rebuild when URL changes
                initialUrlRequest: URLRequest(url: WebUri(state.videoUrl!)),
                initialSettings: InAppWebViewSettings(
                  allowsPictureInPictureMediaPlayback: true,
                  useShouldOverrideUrlLoading: true,
                  domStorageEnabled: true,
                  javaScriptEnabled: true,
                  useWideViewPort: true,
                  loadWithOverviewMode: true,
                ),
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  final url = navigationAction.request.url.toString();
                  //print('Navigation attempt to: $url');

                  // Check if the URL is from any of our video sources
                  final isAllowed = state.sources.any((source) {
                    try {
                      final movieHost = Uri.parse(source.movieUrlPattern).host;
                      final tvHost = Uri.parse(source.tvUrlPattern).host;
                      final urlUri = Uri.parse(url);
                      final urlHost = urlUri.host;

                      // Check if the URL host matches either the movie or TV host from the source
                      final isAllowedHost =
                          urlHost.contains(movieHost) ||
                          urlHost.contains(tvHost) ||
                          movieHost.contains(urlHost) ||
                          tvHost.contains(urlHost);

                      //print('Checking source: ${source.name}, movieHost: $movieHost, tvHost: $tvHost, urlHost: $urlHost, isAllowed: $isAllowedHost');
                      return isAllowedHost;
                    } catch (e) {
                      //print('Error parsing URL for source ${source.name}: $e');
                      return false;
                    }
                  });

                  if (isAllowed) {
                    //print('Allowing navigation to: $url');
                    return NavigationActionPolicy.ALLOW;
                  } else {
                    //print('Blocking navigation to: $url');
                    return NavigationActionPolicy.CANCEL;
                  }
                },
                onLoadStart: (controller, url) {
                  // Handle loading start if needed
                },
                onLoadStop: (controller, url) {
                  // Handle loading stop if needed
                },
              )
            else if (state.videoUrl != null && state.isPipActive)
              const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.picture_in_picture_alt,
                      color: Colors.white54,
                      size: 80,
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Video playing in PIP mode',
                      style: TextStyle(
                        color: Colors.white54,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Tap PIP button to return to fullscreen',
                      style: TextStyle(
                        color: Colors.white38,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              )
            else
              const Center(
                child: Text(
                  'No video URL found',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            // Only show overlay controls when NOT in PIP mode
            if (!state.isPipActive)
              AnimatedOpacity(
                opacity: _showControls ? 1.0 : 0.2,
                duration: const Duration(milliseconds: 300),
              child: Stack(
                children: [
                  Positioned(
                    top: 40,
                    left: 20,
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => GoRouter.of(context).pop(),
                    ),
                  ),
                  if (!state.isLoading && state.errorMessage == null)
                    Positioned(
                      top: 40,
                      right: 20,
                      child: Row(
                        children: [
                          if (!widget.isMovie)
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(153),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.skip_previous,
                                      color: Colors.white,
                                    ),
                                    onPressed: notifier.previousEpisode,
                                  ),
                                  Text(
                                    'E${state.episodeNumber}',
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.skip_next,
                                      color: Colors.white,
                                    ),
                                    onPressed: notifier.nextEpisode,
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: Icon(
                              Icons.picture_in_picture_alt,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              print('🎯 PIP button pressed');
                              try {
                                // Use the class instance instead of creating new one
                                await _pipService.initialize();
                                
                                print('🔄 Calling togglePipMode...');
                                final success = await _pipService.togglePipMode(
                                  aspectRatio: 16 / 9,
                                );
                                
                                print('📱 PIP toggle result: $success');
                                _startHideControlsTimer();
                              } catch (e, stackTrace) {
                                print('❌ PIP Error: $e');
                                print('📍 Stack trace: $stackTrace');
                              }
                            },
                          ),
                          const SizedBox(width: 10),
                          PopupMenuButton<String>(
                            onSelected: (String newKey) {
                              //print('Selected source with key: $newKey');
                              final newSource = state.sources.firstWhere(
                                (s) => s.key == newKey,
                              );
                              //('Found source: ${newSource.name}');
                              notifier.selectSource(newSource);
                              _startHideControlsTimer();
                            },
                            itemBuilder: (BuildContext context) {
                              return state.sources.map((source) {
                                return PopupMenuItem<String>(
                                  value: source.key,
                                  child: Text(source.name),
                                );
                              }).toList();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(153),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(
                                    Icons.source,
                                    color: Colors.white,
                                    size: 18,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.selectedSource?.name ??
                                        'Select Source',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
