import 'dart:async';
import 'package:flutter/material.dart';

/// Netflix-style video player controls widget.
/// 
/// Features:
/// - Dark control bar with red progress indicator (#E50914)
/// - White icons and text
/// - Large play/pause button
/// - Tap to show/hide controls with fade animation
/// - Double-tap to seek (forward/backward 10 seconds)
/// - Next episode countdown for TV shows
class NetflixVideoControls extends StatefulWidget {
  final bool isPlaying;
  final Duration currentPosition;
  final Duration totalDuration;
  final Duration bufferedPosition;
  final bool isLoading;
  final String? errorMessage;
  final bool isMovie;
  final int? currentEpisode;
  final int? totalEpisodes;
  final int? autoPlayCountdown;
  final VoidCallback onPlayPause;
  final VoidCallback onSeekBackward;
  final VoidCallback onSeekForward;
  final VoidCallback onNextEpisode;
  final VoidCallback onPreviousEpisode;
  final VoidCallback? onCancelAutoPlay;
  final Function(Duration) onSeek;
  final VoidCallback onToggleFullscreen;
  final VoidCallback? onToggleSettings;
  final VoidCallback? onToggleSubtitles;
  final VoidCallback onBack;

  const NetflixVideoControls({
    super.key,
    required this.isPlaying,
    required this.currentPosition,
    required this.totalDuration,
    this.bufferedPosition = Duration.zero,
    this.isLoading = false,
    this.errorMessage,
    this.isMovie = true,
    this.currentEpisode,
    this.totalEpisodes,
    this.autoPlayCountdown,
    required this.onPlayPause,
    required this.onSeekBackward,
    required this.onSeekForward,
    required this.onNextEpisode,
    required this.onPreviousEpisode,
    this.onCancelAutoPlay,
    required this.onSeek,
    required this.onToggleFullscreen,
    this.onToggleSettings,
    this.onToggleSubtitles,
    required this.onBack,
  });

  @override
  State<NetflixVideoControls> createState() => _NetflixVideoControlsState();
}

class _NetflixVideoControlsState extends State<NetflixVideoControls>
    with TickerProviderStateMixin {
  bool _showControls = true;
  Timer? _hideControlsTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  
  // Double tap tracking
  DateTime? _lastTapTime;
  // ignore: unused_field
  Offset? _lastTapPosition;
  Timer? _singleTapTimer;

  // Netflix colors
  static const Color netflixRed = Color(0xFFE50914);
  static const Color netflixDark = Color(0xFF141414);
  static const Color netflixGray = Color(0xFF2F2F2F);
  static const Color netflixLightGray = Color(0xFF808080);

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _fadeController.forward();
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _singleTapTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && widget.isPlaying) {
        setState(() {
          _showControls = false;
        });
        _fadeController.reverse();
      }
    });
  }

  void _showControlsTemporarily() {
    setState(() {
      _showControls = true;
    });
    _fadeController.forward();
    _startHideControlsTimer();
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _fadeController.forward();
      _startHideControlsTimer();
    } else {
      _fadeController.reverse();
    }
  }

  void _handleTap(TapUpDetails details) {
    final now = DateTime.now();
    final position = details.localPosition;
    final screenWidth = MediaQuery.of(context).size.width;
    
    // Check for double tap (within 300ms)
    if (_lastTapTime != null && 
        now.difference(_lastTapTime!) < const Duration(milliseconds: 300)) {
      _singleTapTimer?.cancel();
      _handleDoubleTap(position, screenWidth);
    } else {
      // Delay single tap to check for double tap
      _singleTapTimer = Timer(const Duration(milliseconds: 300), () {
        _toggleControls();
      });
    }
    
    _lastTapTime = now;
    _lastTapPosition = position;
  }

  void _handleDoubleTap(Offset position, double screenWidth) {
    // Determine if tap is on left or right side
    if (position.dx < screenWidth * 0.3) {
      // Left side - seek backward
      widget.onSeekBackward();
      _showSeekFeedback('backward');
    } else if (position.dx > screenWidth * 0.7) {
      // Right side - seek forward
      widget.onSeekForward();
      _showSeekFeedback('forward');
    } else {
      // Center - toggle play/pause
      widget.onPlayPause();
    }
    _showControlsTemporarily();
  }

  void _showSeekFeedback(String direction) {
    // Feedback is shown via the seek overlay
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _handleTap,
      child: Stack(
        children: [
          // Main content area (transparent to allow video underneath)
          Container(color: Colors.transparent),
          
          // Loading indicator
          if (widget.isLoading)
            Container(
              color: Colors.black54,
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(netflixRed),
                ),
              ),
            ),
          
          // Error display
          if (widget.errorMessage != null && !widget.isLoading)
            Container(
              color: Colors.black87,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      color: netflixRed,
                      size: 64,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.errorMessage!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          
          // Controls overlay
          FadeTransition(
            opacity: _fadeAnimation,
            child: Visibility(
              visible: _showControls,
              child: _buildControlsOverlay(),
            ),
          ),
          
          // Double tap seek indicators
          _buildSeekIndicators(),
          
          // Auto-play countdown overlay
          if (widget.autoPlayCountdown != null && widget.autoPlayCountdown! > 0)
            _buildAutoPlayOverlay(),
        ],
      ),
    );
  }

  Widget _buildControlsOverlay() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.black.withValues(alpha: 0.8),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withValues(alpha: 0.9),
          ],
          stops: const [0.0, 0.25, 0.75, 1.0],
        ),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Top controls
            _buildTopControls(),
            
            const Spacer(),
            
            // Center play/pause button (large)
            if (!widget.isLoading && widget.errorMessage == null)
              _buildCenterPlayButton(),
            
            const Spacer(),
            
            // Bottom controls with progress bar
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          // Back button
          IconButton(
            onPressed: () {
              widget.onBack();
            },
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),
          
          const Spacer(),
          
          // Episode info for TV shows
          if (!widget.isMovie && widget.currentEpisode != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: netflixDark.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Episode ${widget.currentEpisode}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCenterPlayButton() {
    return GestureDetector(
      onTap: widget.onPlayPause,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: netflixRed.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.isPlaying ? Icons.pause : Icons.play_arrow,
          color: Colors.white,
          size: 48,
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Container(
      color: netflixDark.withValues(alpha: 0.7),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Progress bar
          _buildNetflixProgressBar(),
          
          const SizedBox(height: 12),
          
          // Control buttons row
          Row(
            children: [
              // Play/Pause button (left)
              IconButton(
                onPressed: () {
                  widget.onPlayPause();
                  _showControlsTemporarily();
                },
                icon: Icon(
                  widget.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Previous episode (for TV shows)
              if (!widget.isMovie)
                IconButton(
                  onPressed: () {
                    widget.onPreviousEpisode();
                    _showControlsTemporarily();
                  },
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              
              // Next episode (for TV shows)
              if (!widget.isMovie)
                IconButton(
                  onPressed: () {
                    widget.onNextEpisode();
                    _showControlsTemporarily();
                  },
                  icon: const Icon(
                    Icons.skip_next,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              
              const SizedBox(width: 16),
              
              // Current time
              Text(
                _formatDuration(widget.currentPosition),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Expanded progress bar area
              Expanded(
                child: _buildProgressSlider(),
              ),
              
              const SizedBox(width: 8),
              
              // Total time
              Text(
                _formatDuration(widget.totalDuration),
                style: const TextStyle(
                  color: netflixLightGray,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Far right buttons
              // Subtitles
              if (widget.onToggleSubtitles != null)
                IconButton(
                  onPressed: () {
                    widget.onToggleSubtitles!();
                    _showControlsTemporarily();
                  },
                  icon: const Icon(
                    Icons.subtitles,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              
              // Settings
              if (widget.onToggleSettings != null)
                IconButton(
                  onPressed: () {
                    widget.onToggleSettings!();
                    _showControlsTemporarily();
                  },
                  icon: const Icon(
                    Icons.settings,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
              
              // Fullscreen
              IconButton(
                onPressed: () {
                  widget.onToggleFullscreen();
                  _showControlsTemporarily();
                },
                icon: const Icon(
                  Icons.fullscreen,
                  color: Colors.white,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetflixProgressBar() {
    if (widget.totalDuration.inMilliseconds == 0) {
      return const SizedBox(height: 4);
    }
    
    final progress = widget.currentPosition.inMilliseconds / 
                     widget.totalDuration.inMilliseconds;
    final buffered = widget.bufferedPosition.inMilliseconds / 
                     widget.totalDuration.inMilliseconds;
    
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        
        return Container(
          height: 4,
          decoration: BoxDecoration(
            color: netflixGray,
            borderRadius: BorderRadius.circular(2),
          ),
          child: Stack(
            children: [
              // Buffered indicator (white/gray)
              Container(
                width: width * buffered.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Progress indicator (Netflix red)
              Container(
                width: width * progress.clamp(0.0, 1.0),
                decoration: BoxDecoration(
                  color: netflixRed,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildProgressSlider() {
    if (widget.totalDuration.inMilliseconds == 0) {
      return const SizedBox.shrink();
    }
    
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: netflixRed,
        inactiveTrackColor: netflixGray,
        thumbColor: netflixRed,
        overlayColor: netflixRed.withValues(alpha: 0.3),
        trackHeight: 4,
        thumbShape: const RoundSliderThumbShape(
          enabledThumbRadius: 6,
          pressedElevation: 8,
        ),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
      ),
      child: Slider(
        value: widget.currentPosition.inMilliseconds.toDouble(),
        min: 0,
        max: widget.totalDuration.inMilliseconds.toDouble(),
        onChanged: (value) {
          final newPosition = Duration(milliseconds: value.round());
          widget.onSeek(newPosition);
        },
        onChangeStart: (_) {
          _hideControlsTimer?.cancel();
        },
        onChangeEnd: (_) {
          _startHideControlsTimer();
        },
      ),
    );
  }

  Widget _buildSeekIndicators() {
    return Stack(
      children: [
        // Left seek indicator (backward)
        Positioned(
          left: 0,
          top: 0,
          bottom: 0,
          width: MediaQuery.of(context).size.width * 0.25,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        
        // Right seek indicator (forward)
        Positioned(
          right: 0,
          top: 0,
          bottom: 0,
          width: MediaQuery.of(context).size.width * 0.25,
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.centerRight,
                end: Alignment.centerLeft,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAutoPlayOverlay() {
    return Container(
      color: Colors.black87,
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(32),
          decoration: BoxDecoration(
            color: netflixDark,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Up Next',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              if (!widget.isMovie && widget.currentEpisode != null)
                Text(
                  'Episode ${widget.currentEpisode! + 1}',
                  style: const TextStyle(
                    color: netflixLightGray,
                    fontSize: 16,
                  ),
                ),
              const SizedBox(height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80,
                    height: 80,
                    child: CircularProgressIndicator(
                      value: widget.autoPlayCountdown! / 10,
                      strokeWidth: 4,
                      valueColor: const AlwaysStoppedAnimation<Color>(netflixRed),
                      backgroundColor: netflixGray,
                    ),
                  ),
                  Text(
                    '${widget.autoPlayCountdown}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: widget.onCancelAutoPlay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: netflixGray,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: widget.onNextEpisode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: netflixRed,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                    ),
                    child: const Text('Play Now'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);
    
    if (hours > 0) {
      return '${hours.toString().padLeft(2, '0')}:'
             '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}';
    } else {
      return '${minutes.toString().padLeft(2, '0')}:'
             '${seconds.toString().padLeft(2, '0')}';
    }
  }
}
