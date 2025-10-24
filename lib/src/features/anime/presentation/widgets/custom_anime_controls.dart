import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:chewie/chewie.dart';
import 'package:lets_stream/src/features/anime/application/anime_player_state.dart';
import 'package:lets_stream/src/features/anime/application/anime_player_notifier.dart';
import 'package:lets_stream/src/features/anime/application/models/gesture_type.dart';
import 'package:lets_stream/src/features/anime/utils/gesture_handler.dart';

/// Custom video controls widget with gesture support for the anime player.
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
  bool _isLongPressing = false;
  Timer? _longPressTimer;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_fadeController);
    _startHideControlsTimer();
  }

  @override
  void dispose() {
    _hideControlsTimer?.cancel();
    _longPressTimer?.cancel();
    _fadeController.dispose();
    super.dispose();
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 5), () {
      if (mounted) {
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

  void _handleTap(TapUpDetails details) {
    final now = DateTime.now();
    final position = details.localPosition;
    final screenSize = MediaQuery.of(context).size;

    // Check for double tap
    if (_lastTapTime != null &&
        _lastTapPosition != null &&
        GestureHandler.isDoubleTap(_lastTapTime!, now)) {
      _handleDoubleTap(position, screenSize);
    } else {
      _handleSingleTap(position, screenSize);
    }

    _lastTapPosition = position;
    _lastTapTime = now;
  }

  void _handleDoubleTap(Offset position, Size screenSize) {
    widget.notifier.handleGesture(
      GestureType.doubleTap,
      position,
      screenSize,
    );
    _showControlsTemporarily();
  }

  void _handleSingleTap(Offset position, Size screenSize) {
    widget.notifier.handleGesture(
      GestureType.singleTap,
      position,
      screenSize,
    );
    _showControlsTemporarily();
  }

  void _handlePanStart(DragStartDetails details) {
    _longPressTimer?.cancel();
    _longPressTimer = Timer(const Duration(milliseconds: 500), () {
      _isLongPressing = true;
      _handleLongPress(details.localPosition, MediaQuery.of(context).size);
    });
  }

  void _handlePanUpdate(DragUpdateDetails details) {
    if (_isLongPressing) return;

    final delta = details.delta;
    final screenSize = MediaQuery.of(context).size;

    // Determine gesture type based on movement
    if (delta.dx.abs() > delta.dy.abs()) {
      // Horizontal swipe
      widget.notifier.handleGesture(
        GestureType.horizontalSwipe,
        details.localPosition,
        screenSize,
      );
    } else {
      // Vertical swipe
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

  void _handleLongPress(Offset position, Size screenSize) {
    widget.notifier.handleGesture(
      GestureType.longPress,
      position,
      screenSize,
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

          // Controls overlay
          if (_showControls && !widget.state.isLocked)
            FadeTransition(
              opacity: _fadeAnimation,
              child: _buildControlsOverlay(),
            ),

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
          color: Colors.black54,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              GestureHandler.getGestureIcon(gestureType),
              color: GestureHandler.getGestureColor(gestureType),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              GestureHandler.getGestureDescription(gestureType),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
              ),
            ),
          ],
        ),
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
            Colors.black.withOpacity(0.7),
            Colors.transparent,
            Colors.transparent,
            Colors.black.withOpacity(0.7),
          ],
        ),
      ),
      child: Column(
        children: [
          _buildTopControls(),
          const Spacer(),
          _buildCenterControls(),
          const Spacer(),
          _buildBottomControls(),
        ],
      ),
    );
  }

  Widget _buildTopControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
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
          if (widget.state.currentEpisode != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                'Episode ${widget.state.currentEpisode!.episodeNo}',
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

          const SizedBox(width: 8),

          // Quality indicator
          if (widget.state.selectedQuality != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                widget.state.selectedQuality!.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),

          const SizedBox(width: 8),

          // Settings button
          IconButton(
            onPressed: widget.notifier.toggleServerSelector,
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

  Widget _buildCenterControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        // Previous episode
        if (widget.state.hasPreviousEpisode)
          IconButton(
            onPressed: widget.notifier.previousEpisode,
            icon: const Icon(Icons.skip_previous, color: Colors.white, size: 32),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              shape: const CircleBorder(),
            ),
          ),

        // Play/Pause
        IconButton(
          onPressed: widget.notifier.togglePlayPause,
          icon: Icon(
            widget.state.isPlaying ? Icons.pause : Icons.play_arrow,
            color: Colors.white,
            size: 48,
          ),
          style: IconButton.styleFrom(
            backgroundColor: Colors.black54,
            shape: const CircleBorder(),
          ),
        ),

        // Next episode
        if (widget.state.hasNextEpisode)
          IconButton(
            onPressed: widget.notifier.nextEpisode,
            icon: const Icon(Icons.skip_next, color: Colors.white, size: 32),
            style: IconButton.styleFrom(
              backgroundColor: Colors.black54,
              shape: const CircleBorder(),
            ),
          ),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Progress bar
          _buildProgressBar(),
          const SizedBox(height: 16),
          
          // Bottom controls row
          Row(
            children: [
              // Current time
              Text(
                _formatDuration(widget.state.currentPosition),
                style: const TextStyle(color: Colors.white, fontSize: 12),
              ),
              
              const Spacer(),
              
              // Playback speed
              IconButton(
                onPressed: () => _showSpeedSelector(),
                icon: Text(
                  '${widget.state.playbackSpeed}x',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              
              // Volume
              IconButton(
                onPressed: () => _showVolumeSlider(),
                icon: Icon(
                  widget.state.volume > 0.5 ? Icons.volume_up : Icons.volume_down,
                  color: Colors.white,
                ),
              ),
              
              // Brightness
              IconButton(
                onPressed: () => _showBrightnessSlider(),
                icon: Icon(
                  widget.state.brightness > 0.5 ? Icons.brightness_high : Icons.brightness_low,
                  color: Colors.white,
                ),
              ),
              
              // Lock button
              IconButton(
                onPressed: widget.notifier.toggleLock,
                icon: Icon(
                  widget.state.isLocked ? Icons.lock : Icons.lock_open,
                  color: Colors.white,
                ),
              ),
              
              // Full screen
              IconButton(
                onPressed: () => _toggleFullScreen(),
                icon: const Icon(Icons.fullscreen, color: Colors.white),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        activeTrackColor: Colors.blue,
        inactiveTrackColor: Colors.grey,
        thumbColor: Colors.blue,
        overlayColor: Colors.blue.withOpacity(0.2),
      ),
      child: Slider(
        value: widget.state.progressPercentage,
        onChanged: (value) {
          final newPosition = Duration(
            milliseconds: (value * widget.state.totalDuration.inMilliseconds).round(),
          );
          widget.notifier.seekTo(newPosition);
        },
      ),
    );
  }

  Widget _buildAutoPlayOverlay() {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Next Episode Starting',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.state.autoPlayCountdown}',
              style: const TextStyle(
                color: Colors.blue,
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: widget.notifier.cancelAutoPlay,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 16),
                OutlinedButton(
                  onPressed: widget.notifier.nextEpisode,
                  child: const Text('Play Now'),
                ),
              ],
            ),
          ],
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

  void _showSpeedSelector() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Playback Speed',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: [0.5, 0.75, 1.0, 1.25, 1.5, 2.0].map((speed) {
                return ChoiceChip(
                  label: Text('${speed}x'),
                  selected: widget.state.playbackSpeed == speed,
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
        title: const Text('Volume'),
        content: Slider(
          value: widget.state.volume,
          onChanged: widget.notifier.setVolume,
        ),
      ),
    );
  }

  void _showBrightnessSlider() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Brightness'),
        content: Slider(
          value: widget.state.brightness,
          onChanged: widget.notifier.setBrightness,
        ),
      ),
    );
  }

  void _toggleFullScreen() {
    // Toggle full screen mode
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
