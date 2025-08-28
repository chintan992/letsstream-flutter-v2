import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  @override
  void initState() {
    super.initState();
    _startHideControlsTimer();
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

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Stack(
          children: [
            if (state.isLoading)
              const Center(child: CircularProgressIndicator())
            else if (state.errorMessage != null)
              Center(child: Text(state.errorMessage!, style: const TextStyle(color: Colors.white)))
            else if (state.videoUrl != null)
              InAppWebView(
                key: ValueKey(state.videoUrl), // Add a key to force rebuild when URL changes
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
                      final isAllowedHost = urlHost.contains(movieHost) || urlHost.contains(tvHost) || 
                                          movieHost.contains(urlHost) || tvHost.contains(urlHost);
                      
                      //print('Checking source: ${source.name}, movieHost: $movieHost, tvHost: $tvHost, urlHost: $urlHost, isAllowed: $isAllowedHost');
                      return isAllowedHost;
                    } catch (e) {
                      //('Error parsing URL for source ${source.name}: $e');
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
            else
              const Center(child: Text('No video URL found', style: TextStyle(color: Colors.white))),
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
                                    icon: const Icon(Icons.skip_previous, color: Colors.white),
                                    onPressed: notifier.previousEpisode,
                                  ),
                                  Text('E${state.episodeNumber}', style: const TextStyle(color: Colors.white)),
                                  IconButton(
                                    icon: const Icon(Icons.skip_next, color: Colors.white),
                                    onPressed: notifier.nextEpisode,
                                  ),
                                ],
                              ),
                            ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.picture_in_picture_alt, color: Colors.white),
                            onPressed: () {
                              // Picture-in-Picture is handled automatically by the WebView
                              // when allowsPictureInPictureMediaPlayback is set to true
                              // No explicit action needed here
                            },
                          ),
                          const SizedBox(width: 10),
                          PopupMenuButton<String>(
                            onSelected: (String newKey) {
                              //print('Selected source with key: $newKey');
                              final newSource = state.sources.firstWhere((s) => s.key == newKey);
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
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                              decoration: BoxDecoration(
                                color: Colors.black.withAlpha(153),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.source, color: Colors.white, size: 18),
                                  const SizedBox(width: 8),
                                  Text(
                                    state.selectedSource?.name ?? 'Select Source',
                                    style: const TextStyle(color: Colors.white, fontSize: 14),
                                  ),
                                  const Icon(Icons.arrow_drop_down, color: Colors.white),
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
