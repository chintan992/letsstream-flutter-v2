import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/core/services/native_pip_service.dart';
import 'package:lets_stream/src/features/video_player/application/video_player_notifier.dart';
import 'package:lets_stream/src/shared/presentation/widgets/netflix_video_controls.dart';

// Comprehensive ad blocker content blockers
final List<ContentBlocker> adBlockers = [
  // Google Ad Services
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*googlesyndication\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*doubleclick\\.net.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*googleadservices\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*googletagmanager\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*googletagservices\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*google-analytics\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Amazon Ad Services
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*adsystem\\.amazonads\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*amazon-adsystem\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Facebook/Meta Ad Services
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*connect\\.facebook\\.net.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*facebook\\.com/tr.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Major Ad Networks
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*pubmatic\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*openx\\.net.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*appnexus\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*rubiconproject\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*casalemedia\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*smartadserver\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Content Recommendation Networks
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*outbrain\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*taboola\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*revcontent\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Video Ad Networks
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*vast\\.videoadex\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*adroll\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*criteo\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Tracking and Analytics
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*quantserve\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*scorecardresearch\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*doubleverify\\.com.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Block common ad elements by CSS selector
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.CSS_DISPLAY_NONE,
      selector:
          ".ad, .ads, .advertisement, .banner-ad, .sidebar-ad, .popup-ad, .interstitial-ad, .overlay-ad, .floating-ad, [class*='ad-'], [id*='ad-'], [class*='ads'], [id*='ads'], [class*='advert'], [id*='advert'], .sponsored, .promoted, .commercial",
    ),
  ),

  // Block video ads and overlays
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.CSS_DISPLAY_NONE,
      selector:
          ".video-ad, .preroll-ad, .midroll-ad, .postroll-ad, .skippable-ad, .non-skippable-ad, [class*='video-ad'], [id*='video-ad'], .vast-ad, .ima-ad, .jwplayer-ad, .flowplayer-ad, .videojs-ad",
    ),
  ),

  // Block ad containers and iframes
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.CSS_DISPLAY_NONE,
      selector:
          "[data-ad], [data-ad-unit], [data-ad-slot], [data-ad-type], iframe[src*='ads'], iframe[src*='doubleclick'], iframe[src*='googlesyndication'], iframe[src*='amazon-adsystem']",
    ),
  ),

  // Block tracking pixels and scripts
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: '.*',
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.CSS_DISPLAY_NONE,
      selector:
          "img[src*='pixel'], img[src*='beacon'], img[src*='track'], img[alt*='pixel'], img[alt*='beacon'], script[src*='analytics'], script[src*='tracking'], script[src*='pixel']",
    ),
  ),
];

/// Video player screen with Netflix-style controls.
///
/// Features:
/// - Dark control bar with red progress indicator
/// - White icons and text
/// - Large play/pause button
/// - Tap to show/hide controls
/// - Double-tap to seek
/// - Episode navigation for TV shows
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
  // ignore: unused_field
  bool _showControls = true;
  Timer? _hideControlsTimer;
  late final NativePipService _pipService;
  StreamSubscription<bool>? _pipModeSubscription;
  // ignore: unused_field
  bool _isInPipMode = false;
  
  // Simulated playback state (for Netflix UI)
  bool _isPlaying = false;
  Duration _currentPosition = Duration.zero;
  final Duration _totalDuration = const Duration(minutes: 45);
  Duration _bufferedPosition = Duration.zero;
  int? _autoPlayCountdown;
  Timer? _countdownTimer;

  @override
  void initState() {
    super.initState();
    _startHideControlsTimer();
    _initializePip();
    _startSimulatedPlayback();
  }

  void _initializePip() {
    _pipService = NativePipService();
    _pipService.initialize();

    _pipModeSubscription = _pipService.pipModeStream.listen((isInPip) {
      if (mounted) {
        setState(() {
          _isInPipMode = isInPip;
          if (isInPip) {
            _showControls = false;
            _hideControlsTimer?.cancel();
          }
        });

        final provider = videoPlayerNotifierProvider((
          mediaId: widget.tmdbId,
          mediaType: widget.isMovie ? 'movie' : 'tv',
          seasonNumber: widget.season,
          episodeNumber: widget.episode,
        ),);
        final notifier = ref.read(provider.notifier);
        notifier.setPipActive(isInPip);
      }
    });

    Future(() async {
      final provider = videoPlayerNotifierProvider((
        mediaId: widget.tmdbId,
        mediaType: widget.isMovie ? 'movie' : 'tv',
        seasonNumber: widget.season,
        episodeNumber: widget.episode,
      ),);
      final notifier = ref.read(provider.notifier);
      await notifier.initializePip();
    });
  }

  void _startSimulatedPlayback() {
    // Simulate video playback for UI demonstration
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && _isPlaying) {
        setState(() {
          _currentPosition += const Duration(seconds: 1);
          _bufferedPosition = _currentPosition + const Duration(seconds: 30);
          if (_currentPosition >= _totalDuration) {
            _isPlaying = false;
            _startAutoPlayCountdown();
          }
        });
      }
    });
  }

  void _startAutoPlayCountdown() {
    if (widget.isMovie) return;
    
    setState(() {
      _autoPlayCountdown = 10;
    });
    
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_autoPlayCountdown! > 1) {
            _autoPlayCountdown = _autoPlayCountdown! - 1;
          } else {
            _autoPlayCountdown = null;
            timer.cancel();
            _nextEpisode();
          }
        });
      }
    });
  }

  void _cancelAutoPlay() {
    _countdownTimer?.cancel();
    setState(() {
      _autoPlayCountdown = null;
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

  void _togglePlayPause() {
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void _seekBackward() {
    setState(() {
      _currentPosition = Duration(
        milliseconds: (_currentPosition.inMilliseconds - 10000).clamp(0, _totalDuration.inMilliseconds),
      );
    });
  }

  void _seekForward() {
    setState(() {
      _currentPosition = Duration(
        milliseconds: (_currentPosition.inMilliseconds + 10000).clamp(0, _totalDuration.inMilliseconds),
      );
    });
  }

  void _seekTo(Duration position) {
    setState(() {
      _currentPosition = position;
    });
  }

  void _nextEpisode() {
    final provider = videoPlayerNotifierProvider((
      mediaId: widget.tmdbId,
      mediaType: widget.isMovie ? 'movie' : 'tv',
      seasonNumber: widget.season,
      episodeNumber: widget.episode,
    ),);
    final notifier = ref.read(provider.notifier);
    notifier.nextEpisode();
    
    setState(() {
      _currentPosition = Duration.zero;
      _autoPlayCountdown = null;
    });
  }

  void _previousEpisode() {
    final provider = videoPlayerNotifierProvider((
      mediaId: widget.tmdbId,
      mediaType: widget.isMovie ? 'movie' : 'tv',
      seasonNumber: widget.season,
      episodeNumber: widget.episode,
    ),);
    final notifier = ref.read(provider.notifier);
    notifier.previousEpisode();
    
    setState(() {
      _currentPosition = Duration.zero;
    });
  }

  void _toggleFullscreen() {
    // Toggle fullscreen mode
  }

  void _toggleSettings() {
    _showSourceSelector();
  }

  void _showSourceSelector() {
    final provider = videoPlayerNotifierProvider((
      mediaId: widget.tmdbId,
      mediaType: widget.isMovie ? 'movie' : 'tv',
      seasonNumber: widget.season,
      episodeNumber: widget.episode,
    ),);
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF141414),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Source',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            ...state.sources.map((source) => ListTile(
              title: Text(
                source.name,
                style: const TextStyle(color: Colors.white),
              ),
              trailing: state.selectedSource?.key == source.key
                  ? const Icon(Icons.check, color: Color(0xFFE50914))
                  : null,
              onTap: () {
                notifier.selectSource(source);
                Navigator.pop(context);
              },
            )),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _pipModeSubscription?.cancel();
    _countdownTimer?.cancel();
    super.dispose();
  }

  Future<void> _injectAdBlockingJavaScript(
      InAppWebViewController controller,) async {
    const adBlockingScript = '''
      (function() {
        'use strict';

        function removeElements(selectors) {
          selectors.forEach(function(selector) {
            const elements = document.querySelectorAll(selector);
            elements.forEach(function(element) {
              element.remove();
            });
          });
        }

        function blockAdRequests() {
          const originalOpen = XMLHttpRequest.prototype.open;
          XMLHttpRequest.prototype.open = function(method, url) {
            const adDomains = [
              'googlesyndication.com',
              'doubleclick.net',
              'googleadservices.com',
              'googletagmanager.com',
              'googletagservices.com',
              'google-analytics.com',
              'adsystem.amazonads.com',
              'amazon-adsystem.com',
              'connect.facebook.net',
              'pubmatic.com',
              'openx.net',
              'appnexus.com',
              'rubiconproject.com',
              'casalemedia.com',
              'smartadserver.com',
              'outbrain.com',
              'taboola.com',
              'revcontent.com',
              'vast.videoadex.com',
              'adroll.com',
              'criteo.com',
              'quantserve.com',
              'scorecardresearch.com',
              'doubleverify.com'
            ];

            const isAdRequest = adDomains.some(function(domain) {
              return url.includes(domain);
            });

            if (isAdRequest) {
              console.log('Blocked ad request:', url);
              return;
            }

            return originalOpen.apply(this, arguments);
          };
        }

        function disableAdScripts() {
          const scripts = document.getElementsByTagName('script');
          for (let i = 0; i < scripts.length; i++) {
            const script = scripts[i];
            const src = script.src || '';

            const adScriptPatterns = [
              /googlesyndication.com/,
              /doubleclick.net/,
              /googleadservices.com/,
              /googletagmanager.com/,
              /googletagservices.com/,
              /amazon-adsystem.com/,
              /adsystem.amazonads.com/,
              /connect.facebook.net/,
              /pubmatic.com/,
              /openx.net/,
              /appnexus.com/,
              /rubiconproject.com/,
              /casalemedia.com/,
              /smartadserver.com/,
              /outbrain.com/,
              /taboola.com/,
              /vast.videoadex.com/,
              /adroll.com/,
              /criteo.com/
            ];

            const isAdScript = adScriptPatterns.some(function(pattern) {
              return pattern.test(src);
            });

            if (isAdScript) {
              script.remove();
              console.log('Removed ad script:', src);
            }
          }
        }

        function hideAdElements() {
          const adSelectors = [
            '.ad',
            '.ads',
            '.advertisement',
            '.banner-ad',
            '.sidebar-ad',
            '.popup-ad',
            '.interstitial-ad',
            '.overlay-ad',
            '.floating-ad',
            '[class*="ad-"]',
            '[id*="ad-"]',
            '[class*="ads"]',
            '[id*="ads"]',
            '[class*="advert"]',
            '[id*="advert"]',
            '.sponsored',
            '.promoted',
            '.commercial',
            '.video-ad',
            '.preroll-ad',
            '.midroll-ad',
            '.postroll-ad',
            '.skippable-ad',
            '.non-skippable-ad',
            '[class*="video-ad"]',
            '[id*="video-ad"]',
            '.vast-ad',
            '.ima-ad',
            '.jwplayer-ad',
            '.flowplayer-ad',
            '.videojs-ad',
            '[data-ad]',
            '[data-ad-unit]',
            '[data-ad-slot]',
            '[data-ad-type]',
            'iframe[src*="ads"]',
            'iframe[src*="doubleclick"]',
            'iframe[src*="googlesyndication"]',
            'iframe[src*="amazon-adsystem"]',
            'img[src*="pixel"]',
            'img[src*="beacon"]',
            'img[src*="track"]',
            'img[alt*="pixel"]',
            'img[alt*="beacon"]'
          ];

          removeElements(adSelectors);
        }

        function blockVideoAds() {
          if (window.google && window.google.ima) {
            window.google.ima = null;
          }

          const videoAdLibraries = [
            'googletag',
            'gpt',
            'ima3',
            'vast',
            'vpaid'
          ];

          videoAdLibraries.forEach(function(lib) {
            if (window[lib]) {
              window[lib] = null;
            }
          });
        }

        try {
          blockAdRequests();
          disableAdScripts();
          hideAdElements();
          blockVideoAds();

          const observer = new MutationObserver(function(mutations) {
            mutations.forEach(function(mutation) {
              if (mutation.type === 'childList') {
                hideAdElements();
              }
            });
          });

          observer.observe(document.body, {
            childList: true,
            subtree: true
          });

          console.log('Ad blocking JavaScript injected successfully');
        } catch (error) {
          console.error('Error in ad blocking script:', error);
        }
      })();
    ''';

    try {
      await controller.evaluateJavascript(source: adBlockingScript);
      debugPrint('Ad blocking JavaScript injected successfully');
    } catch (e) {
      debugPrint('Error injecting ad blocking JavaScript: \$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = videoPlayerNotifierProvider((
      mediaId: widget.tmdbId,
      mediaType: widget.isMovie ? 'movie' : 'tv',
      seasonNumber: widget.season,
      episodeNumber: widget.episode,
    ),);
    final state = ref.watch(provider);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Video content
          if (state.isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE50914)),
              ),
            )
          else if (state.errorMessage != null)
            Center(
              child: Text(
                state.errorMessage!,
                style: const TextStyle(color: Colors.white),
              ),
            )
          else if (state.videoUrl != null && !state.isPipActive)
            InAppWebView(
              key: ValueKey(state.videoUrl),
              initialUrlRequest: URLRequest(url: WebUri(state.videoUrl!)),
              initialSettings: InAppWebViewSettings(
                allowsPictureInPictureMediaPlayback: true,
                useShouldOverrideUrlLoading: true,
                domStorageEnabled: true,
                javaScriptEnabled: true,
                useWideViewPort: true,
                loadWithOverviewMode: true,
                contentBlockers: adBlockers,
              ),
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                final url = navigationAction.request.url.toString();
                final isAllowed = state.sources.any((source) {
                  try {
                    final movieHost = Uri.parse(source.movieUrlPattern).host;
                    final tvHost = Uri.parse(source.tvUrlPattern).host;
                    final urlUri = Uri.parse(url);
                    final urlHost = urlUri.host;

                    final isAllowedHost = urlHost.contains(movieHost) ||
                        urlHost.contains(tvHost) ||
                        movieHost.contains(urlHost) ||
                        tvHost.contains(urlHost);

                    return isAllowedHost;
                  } catch (e) {
                    return false;
                  }
                });

                return isAllowed
                    ? NavigationActionPolicy.ALLOW
                    : NavigationActionPolicy.CANCEL;
              },
              onLoadStop: (controller, url) async {
                await _injectAdBlockingJavaScript(controller);
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
          
          // Netflix-style controls overlay
          if (!state.isPipActive && !state.isLoading)
            NetflixVideoControls(
              isPlaying: _isPlaying,
              currentPosition: _currentPosition,
              totalDuration: _totalDuration,
              bufferedPosition: _bufferedPosition,
              isLoading: state.isSwitchingSource,
              errorMessage: state.errorMessage,
              isMovie: widget.isMovie,
              currentEpisode: state.episodeNumber,
              totalEpisodes: state.totalEpisodes,
              autoPlayCountdown: _autoPlayCountdown,
              onPlayPause: _togglePlayPause,
              onSeekBackward: _seekBackward,
              onSeekForward: _seekForward,
              onNextEpisode: _nextEpisode,
              onPreviousEpisode: _previousEpisode,
              onCancelAutoPlay: _cancelAutoPlay,
              onSeek: _seekTo,
              onToggleFullscreen: _toggleFullscreen,
              onToggleSettings: _toggleSettings,
              onBack: () => GoRouter.of(context).pop(),
            ),
        ],
      ),
    );
  }
}
