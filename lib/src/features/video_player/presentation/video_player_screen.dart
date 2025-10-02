import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/core/services/native_pip_service.dart';
import 'package:lets_stream/src/features/video_player/application/video_player_notifier.dart';

// Comprehensive ad blocker content blockers
final List<ContentBlocker> adBlockers = [
  // Google Ad Services
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*googlesyndication\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*doubleclick\\.net.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*googleadservices\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*googletagmanager\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*googletagservices\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*google-analytics\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Amazon Ad Services
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*adsystem\\.amazonads\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*amazon-adsystem\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Facebook/Meta Ad Services
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*connect\\.facebook\\.net.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*facebook\\.com/tr.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Major Ad Networks
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*pubmatic\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*openx\\.net.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*appnexus\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*rubiconproject\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*casalemedia\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*smartadserver\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Content Recommendation Networks
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*outbrain\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*taboola\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*revcontent\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Video Ad Networks
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*vast\\.videoadex\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*adroll\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*criteo\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Tracking and Analytics
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*quantserve\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*scorecardresearch\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*doubleverify\\.com.*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.BLOCK,
    ),
  ),

  // Block common ad elements by CSS selector
  ContentBlocker(
    trigger: ContentBlockerTrigger(
      urlFilter: ".*",
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
      urlFilter: ".*",
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
      urlFilter: ".*",
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
      urlFilter: ".*",
    ),
    action: ContentBlockerAction(
      type: ContentBlockerActionType.CSS_DISPLAY_NONE,
      selector:
          "img[src*='pixel'], img[src*='beacon'], img[src*='track'], img[alt*='pixel'], img[alt*='beacon'], script[src*='analytics'], script[src*='tracking'], script[src*='pixel']",
    ),
  ),
];

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

        print(
            '🔄 PIP mode changed in UI: $_isInPipMode, provider updated: $isInPip');
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

  Future<void> _injectAdBlockingJavaScript(
      InAppWebViewController controller) async {
    const adBlockingScript = '''
      (function() {
        'use strict';

        // Function to remove elements by selector
        function removeElements(selectors) {
          selectors.forEach(function(selector) {
            const elements = document.querySelectorAll(selector);
            elements.forEach(function(element) {
              element.remove();
            });
          });
        }

        // Function to block XMLHttpRequest for ad domains
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

        // Function to disable ad-related scripts
        function disableAdScripts() {
          const scripts = document.getElementsByTagName('script');
          for (let i = 0; i < scripts.length; i++) {
            const script = scripts[i];
            const src = script.src || '';

            const adScriptPatterns = [
              /googlesyndication\.com/,
              /doubleclick\.net/,
              /googleadservices\.com/,
              /googletagmanager\.com/,
              /googletagservices\.com/,
              /amazon-adsystem\.com/,
              /adsystem\.amazonads\.com/,
              /connect\.facebook\.net/,
              /pubmatic\.com/,
              /openx\.net/,
              /appnexus\.com/,
              /rubiconproject\.com/,
              /casalemedia\.com/,
              /smartadserver\.com/,
              /outbrain\.com/,
              /taboola\.com/,
              /vast\.videoadex\.com/,
              /adroll\.com/,
              /criteo\.com/
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

        // Function to hide ad elements
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

        // Function to block video ad overlays
        function blockVideoAds() {
          // Override video ad functions if they exist
          if (window.google && window.google.ima) {
            window.google.ima = null;
          }

          // Block common video ad libraries
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

        // Execute ad blocking functions
        try {
          blockAdRequests();
          disableAdScripts();
          hideAdElements();
          blockVideoAds();

          // Set up a mutation observer to handle dynamically added ad elements
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
      print('Ad blocking JavaScript injected successfully');
    } catch (e) {
      print('Error injecting ad blocking JavaScript: $e');
    }
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
    print(
        '🖥️ VideoPlayerScreen build - isPipActive: ${state.isPipActive}, videoUrl: ${state.videoUrl != null ? "present" : "null"}');

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
                  contentBlockers: adBlockers,
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
                      final isAllowedHost = urlHost.contains(movieHost) ||
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
                onLoadStop: (controller, url) async {
                  // Inject JavaScript to block ads and remove ad elements
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
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                  final success =
                                      await _pipService.togglePipMode(
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
