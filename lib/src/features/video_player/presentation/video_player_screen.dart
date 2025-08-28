
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/features/video_player/application/video_player_notifier.dart';
import 'package:webview_flutter/webview_flutter.dart' as webview_flutter;

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
  late final webview_flutter.WebViewController _controller;

  @override
  void initState() {
    super.initState();
    _controller = webview_flutter.WebViewController()
      ..setJavaScriptMode(webview_flutter.JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        webview_flutter.NavigationDelegate(
          onNavigationRequest: (webview_flutter.NavigationRequest request) {
            final state = ref.read(videoPlayerNotifierProvider((
              mediaId: widget.tmdbId,
              mediaType: widget.isMovie ? 'movie' : 'tv',
              seasonNumber: widget.season,
              episodeNumber: widget.episode,
            )));

            if (state.sources.any((s) => Uri.parse(request.url).host.contains(Uri.parse(s.movieUrlPattern).host))) {
              return webview_flutter.NavigationDecision.navigate;
            }
            return webview_flutter.NavigationDecision.prevent;
          },
        ),
      );
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

    if (state.videoUrl != null) {
      _controller.loadRequest(Uri.parse(state.videoUrl!));
    }

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
              AnimatedOpacity(
                opacity: state.isSwitchingSource ? 0.5 : 1.0,
                duration: const Duration(milliseconds: 300),
                child: webview_flutter.WebViewWidget(controller: _controller),
              )
            else
              const Center(child: Text('No video URL found', style: TextStyle(color: Colors.white))),
            AnimatedOpacity(
              opacity: _showControls ? 1.0 : 0.2,
              duration: const Duration(milliseconds: 300),
              child: Stack(
                children: [
                  if (!state.isLoading && state.errorMessage == null)
                    Positioned(
                      top: 40,
                      right: 20,
                      child: PopupMenuButton<String>(
                        onSelected: (String newKey) {
                          final newSource = state.sources.firstWhere((s) => s.key == newKey);
                          ref.read(provider.notifier).selectSource(newSource);
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
