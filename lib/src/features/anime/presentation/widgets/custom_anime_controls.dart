import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:lets_stream/src/features/anime/application/anime_player_state.dart';
import 'package:lets_stream/src/features/anime/application/anime_player_notifier.dart';
import 'package:lets_stream/src/features/anime/application/models/gesture_type.dart';
import 'package:lets_stream/src/features/anime/utils/gesture_handler.dart';

/// Netflix-style custom video controls for anime player.
/// 
/// Features:
/// - Dark control bar (#141414)
/// - Red progress bar (#E50914)
/// - White icons and text
/// - Large center play/pause button
/// - Double-tap to seek
/// - Auto-play countdown
class CustomAnimeControls extends StatefulWidget {
  final AnimePlayerState state;
  final AnimePlayerNotifier notifier;

  const CustomAnimeControls({
    super.key,
    required this.state,
    required this.notifier,
  });

  @override
  State<CustomAnimeControls> createState() => _CustomAnimeControlsState();
}

class _CustomAnimeControlsState extends State<CustomAnimeControls>
    with TickerProviderStateMixin {
  bool _showControls = true;
  Timer? _hideControlsTimer;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  // Gesture tracking
  Offset? _lastTapPosition;
  DateTime? _lastTapTime;
  Timer? _singleTapTimer;
  bool _isLongPressing = false;
  Timer? _longPressTimer;

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
    _longPressTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted && widget.state.isPlaying && !widget.state.isLocked) {
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
        if (widget.state.isLocked) {
          // Just show controls briefly if locked
          _showControlsTemporarily();
        } else {
          _toggleControls();
        }
      });
    }

    _lastTapTime = now;
    _lastTapPosition = position;
  }

  void _handleDoubleTap(Offset position, double screenWidth) {
    // Determine if tap is on left or right side
    if (position.dx < screenWidth * 0.3) {
      // Left side - seek backward 10 seconds
      _seekBackward();
    } else if (position.dx > screenWidth * 0.7) {
      // Right side - seek forward 10 seconds
      _seekForward();
    } else {
      // Center - toggle play/pause
      widget.notifier.togglePlayPause();
    }
    _showControlsTemporarily();
  }

  void _seekBackward() {
    final currentPosition = widget.state.currentPosition;
    final newPosition = Duration(
      milliseconds: (currentPosition.inMilliseconds - 10000).clamp(0, double.infinity).toInt(),
    );
    widget.notifier.seekTo(newPosition);
  }

  void _seekForward() {
    final currentPosition = widget.state.currentPosition;
    final totalDuration = widget.state.totalDuration;
    final newPosition = Duration(
      milliseconds: (currentPosition.inMilliseconds + 10000).clamp(0, totalDuration.inMilliseconds),
    );
    widget.notifier.seekTo(newPosition);
  }

  void _handlePanStart(DragStartDetails details) {
    _longPressTimer?.cancel();
    _longPressTimer = Timer(const Duration(milliseconds: 500), () {
      _isLongPressing = true;
      _handleLongPress();
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_isLongPressing) return;

    final delta = details.delta;
    final screenSize = MediaQuery.of(context).size;

    if (delta.dx.abs() > delta.dy.abs()) {
      widget.notifier.handleGesture(
        GestureType.horizontalSwipe,
        details.localPosition,
        screenSize,
      );
    } else {
      widget.notifier.handleGesture(
        GestureType.verticalSwipe,
        details.localPosition,
        screenSize,
      );
    }
  }

  void _handlePanEnd(DragEndDetails details) {
    _longPressTimer?.cancel();
    _isLongPressing = false;
  }

  void _handleLongPress() {
    widget.notifier.handleGesture(
      GestureType.longPress,
      _lastTapPosition ?? Offset.zero,
      MediaQuery.of(context).size,
    );
    _showControlsTemporarily();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapUp: _handleTap,
      onPanStart: _handlePanStart,
      onPanUpdate: _handlePanUpdate,
      onPanEnd: _handlePanEnd,
      child: Stack(
        children: [
          // Main video area
          Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: _buildVideoPlayer(),
          ),

          // Gesture indicators
          if (widget.state.showGestureIndicator)
            _buildGestureIndicator(),

          // Netflix-style controls overlay
          if (_showControls && !widget.state.isLocked)
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildNetflixControlsOverlay(),
            ),

          // Locked indicator
          if (widget.state.isLocked)
            _buildLockedIndicator(),

          // Auto-play countdown
          if (widget.state.autoPlayCountdown > 0)
            _buildAutoPlayOverlay(),

          // Loading overlay
          if (widget.state.isLoading)
            _buildLoadingOverlay(),

          // Error overlay
          if (widget.state.error != null)
            _buildErrorOverlay(),
        ],
      ),
    );
  }

  Widget _buildVideoPlayer() {
    if (widget.state.chewieController != null) {
      return Center(
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.width * (9 / 16),
          child: Chewie(controller: widget.state.chewieController!),
        ),
      );
    } else {
      return const Center(
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
      );
    }
  }

  Widget _buildGestureIndicator() {
    final gestureType = widget.state.activeGesture;
    if (gestureType == null) return const SizedBox.shrink();

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: netflixDark.withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              GestureHandler.getGestureIcon(gestureType),
              color: GestureHandler.getGestureColor(gestureType) == Colors.blue
                  ? netflixRed
                  : GestureHandler.getGestureColor(gestureType),
              size: 24,
            ),
            const SizedBox(width: 8),
            Text(
              GestureHandler.getGestureDescription(gestureType),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNetflixControlsOverlay() {
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
      child: Column(
        children: [
          // Top controls
          _buildTopControls(),
          
          const Spacer(),
          
          // Center play button (Netflix style)
          _buildCenterPlayButton(),
          
          const Spacer(),
          
          // Bottom controls with Netflix-style progress bar
          _buildBottomControls(),
        ],
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
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white, size: 28),
          ),

          const Spacer(),

          // Episode info
          if (widget.state.currentEpisode != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: netflixDark.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Episode ${widget.state.currentEpisode!.episodeNo}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(width: 8),

          // Quality indicator
          if (widget.state.selectedQuality != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: netflixDark.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                widget.state.selectedQuality!.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

          const SizedBox(width: 8),

          // Settings button
          IconButton(
            onPressed: widget.notifier.toggleServerSelector,
            icon: const Icon(Icons.settings, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }

  Widget _buildCenterPlayButton() {
    return GestureDetector(
      onTap: widget.notifier.togglePlayPause,
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: netflixRed.withValues(alpha: 0.9),
          shape: BoxShape.circle,
        ),
        child: Icon(
          widget.state.isPlaying ? Icons.pause : Icons.play_arrow,
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
          // Netflix-style progress bar
          _buildNetflixProgressBar(),
          
          const SizedBox(height: 12),
          
          // Control buttons row
          Row(
            children: [
              // Play/Pause button
              IconButton(
                onPressed: () {
                  widget.notifier.togglePlayPause();
                  _showControlsTemporarily();
                },
                icon: Icon(
                  widget.state.isPlaying ? Icons.pause : Icons.play_arrow,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Previous episode
              if (widget.state.hasPreviousEpisode)
                IconButton(
                  onPressed: () {
                    widget.notifier.previousEpisode();
                    _showControlsTemporarily();
                  },
                  icon: const Icon(
                    Icons.skip_previous,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              
              // Next episode
              if (widget.state.hasNextEpisode)
                IconButton(
                  onPressed: () {
                    widget.notifier.nextEpisode();
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
                _formatDuration(widget.state.currentPosition),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(width: 8),
              
              // Progress slider (expanded)
              Expanded(
                child: _buildNetflixSlider(),
              ),
              
              const SizedBox(width: 8),
              
              // Total time
              Text(
                _formatDuration(widget.state.totalDuration),
                style: const TextStyle(
                  color: netflixLightGray,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
              const SizedBox(width: 16),
              
              // Playback speed
              IconButton(
                onPressed: () => _showSpeedSelector(),
                icon: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 1.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    '${widget.state.playbackSpeed}x',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              
              // Volume
              IconButton(
                onPressed: () => _showVolumeSlider(),
                icon: Icon(
                  widget.state.volume > 0.5 
                      ? Icons.volume_up 
                      : widget.state.volume > 0 
                          ? Icons.volume_down 
                          : Icons.volume_off,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              // Lock button
              IconButton(
                onPressed: widget.notifier.toggleLock,
                icon: Icon(
                  widget.state.isLocked ? Icons.lock : Icons.lock_open,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              
              // Fullscreen
              IconButton(
                onPressed: () => _toggleFullScreen(),
                icon: const Icon(Icons.fullscreen, color: Colors.white, size: 28),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNetflixProgressBar() {
    final progress = widget.state.progressPercentage;
    final buffered = widget.state.bufferedPercentage;

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

  Widget _buildNetflixSlider() {
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
        value: widget.state.currentPosition.inMilliseconds.toDouble(),
        min: 0,
        max: widget.state.totalDuration.inMilliseconds.toDouble(),
        onChanged: (value) {
          final newPosition = Duration(milliseconds: value.round());
          widget.notifier.seekTo(newPosition);
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

  Widget _buildLockedIndicator() {
    return Positioned(
      top: 40,
      right: 20,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: netflixDark.withValues(alpha: 0.8),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.lock,
          color: Colors.white,
          size: 24,
        ),
      ),
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
              if (widget.state.currentEpisode != null)
                Text(
                  'Episode ${widget.state.currentEpisode!.episodeNo + 1}',
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
                      value: widget.state.autoPlayCountdown / 10,
                      strokeWidth: 4,
                      valueColor: const AlwaysStoppedAnimation<Color>(netflixRed),
                      backgroundColor: netflixGray,
                    ),
                  ),
                  Text(
                    '${widget.state.autoPlayCountdown}',
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
                    onPressed: widget.notifier.cancelAutoPlay,
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
                    onPressed: widget.notifier.nextEpisode,
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

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black54,
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(netflixRed),
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

  Widget _buildErrorOverlay() {
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
                color: netflixRed,
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
                widget.state.error!,
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
                    onPressed: () => widget.notifier.clearError(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: netflixRed,
                      foregroundColor: Colors.white,
                    ),
                    icon: const Icon(Icons.refresh),
                    label: const Text('Retry'),
                  ),
                  const SizedBox(width: 16),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.white,
                    ),
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

  void _showSpeedSelector() {
    showModalBottomSheet(
      context: context,
      backgroundColor: netflixDark,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Playback Speed',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
                return ChoiceChip(
                  label: Text('${speed}x'),
                  selected: widget.state.playbackSpeed == speed,
                  selectedColor: netflixRed,
                  labelStyle: TextStyle(
                    color: widget.state.playbackSpeed == speed
                        ? Colors.white
                        : Colors.white70,
                  ),
                  backgroundColor: netflixGray,
                  onSelected: (selected) {
                    widget.notifier.setPlaybackSpeed(speed);
                    Navigator.pop(context);
                  },
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showVolumeSlider() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: netflixDark,
        title: const Text('Volume', style: TextStyle(color: Colors.white)),
        content: Slider(
          value: widget.state.volume,
          onChanged: widget.notifier.setVolume,
          activeColor: netflixRed,
          inactiveColor: netflixGray,
        ),
      ),
    );
  }

  void _toggleFullScreen() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
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
