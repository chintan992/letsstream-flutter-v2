import 'dart:math';
import 'package:flutter/material.dart';
import 'package:lets_stream/src/features/anime/application/models/gesture_type.dart';

/// Handles gesture detection and processing for the anime player.
class GestureHandler {
  /// Detects the side of the screen where a gesture occurred.
  static GestureSide detectGestureSide(Offset position, Size screenSize) {
    final x = position.dx;
    final screenWidth = screenSize.width;
    
    if (x < screenWidth / 3) {
      return GestureSide.left;
    } else if (x > screenWidth * 2 / 3) {
      return GestureSide.right;
    } else {
      return GestureSide.center;
    }
  }

  /// Calculates the distance between two points.
  static double calculateDistance(Offset point1, Offset point2) {
    final dx = point1.dx - point2.dx;
    final dy = point1.dy - point2.dy;
    return sqrt(dx * dx + dy * dy);
  }

  /// Calculates the angle of a swipe gesture.
  static double calculateSwipeAngle(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    return atan2(dy, dx) * 180 / pi;
  }

  /// Determines the direction of a swipe gesture.
  static SwipeDirection determineSwipeDirection(Offset start, Offset end) {
    final dx = end.dx - start.dx;
    final dy = end.dy - start.dy;
    
    if (dx.abs() > dy.abs()) {
      return dx > 0 ? SwipeDirection.right : SwipeDirection.left;
    } else {
      return dy > 0 ? SwipeDirection.down : SwipeDirection.up;
    }
  }

  /// Calculates the brightness change based on vertical swipe.
  static double calculateBrightnessChange(
    Offset start,
    Offset end,
    double currentBrightness,
  ) {
    final dy = start.dy - end.dy; // Inverted for intuitive control
    const screenHeight = 800.0; // Approximate screen height
    const sensitivity = 0.01; // Adjust sensitivity
    
    final change = (dy / screenHeight) * sensitivity;
    return (currentBrightness + change).clamp(0.0, 1.0);
  }

  /// Calculates the volume change based on vertical swipe.
  static double calculateVolumeChange(
    Offset start,
    Offset end,
    double currentVolume,
  ) {
    final dy = start.dy - end.dy; // Inverted for intuitive control
    const screenHeight = 800.0; // Approximate screen height
    const sensitivity = 0.01; // Adjust sensitivity
    
    final change = (dy / screenHeight) * sensitivity;
    return (currentVolume + change).clamp(0.0, 1.0);
  }

  /// Calculates the seek position change based on horizontal swipe.
  static Duration calculateSeekChange(
    Offset start,
    Offset end,
    Duration currentPosition,
    Duration totalDuration,
  ) {
    final dx = end.dx - start.dx;
    const screenWidth = 400.0; // Approximate screen width
    const sensitivity = 0.1; // Adjust sensitivity
    
    final changeSeconds = (dx / screenWidth) * sensitivity * totalDuration.inSeconds;
    final newPosition = currentPosition.inSeconds + changeSeconds;
    
    return Duration(seconds: newPosition.round().clamp(0, totalDuration.inSeconds));
  }

  /// Calculates the zoom scale based on pinch gesture.
  static double calculateZoomScale(
    double initialDistance,
    double currentDistance,
    double currentScale,
  ) {
    if (initialDistance == 0) return currentScale;
    
    final scaleChange = currentDistance / initialDistance;
    return (currentScale * scaleChange).clamp(0.5, 3.0);
  }

  /// Determines if a gesture is a double tap.
  static bool isDoubleTap(DateTime lastTap, DateTime currentTap) {
    const doubleTapThreshold = Duration(milliseconds: 300);
    return currentTap.difference(lastTap) < doubleTapThreshold;
  }

  /// Determines if a gesture is a long press.
  static bool isLongPress(DateTime startTime, DateTime currentTime) {
    const longPressThreshold = Duration(milliseconds: 500);
    return currentTime.difference(startTime) > longPressThreshold;
  }

  /// Calculates the seek amount for double tap gestures.
  static Duration calculateDoubleTapSeek(
    Offset position,
    Size screenSize,
    Duration currentPosition,
  ) {
    final screenWidth = screenSize.width;
    final x = position.dx;
    
    // Left side: seek backward, right side: seek forward
    if (x < screenWidth / 2) {
      return Duration(seconds: max(0, currentPosition.inSeconds - 10));
    } else {
      return Duration(seconds: currentPosition.inSeconds + 10);
    }
  }

  /// Gets the appropriate icon for a gesture type.
  static IconData getGestureIcon(GestureType gestureType) {
    switch (gestureType) {
      case GestureType.doubleTap:
        return Icons.fast_forward;
      case GestureType.verticalSwipe:
        return Icons.volume_up;
      case GestureType.horizontalSwipe:
        return Icons.skip_next;
      case GestureType.pinch:
        return Icons.zoom_in;
      case GestureType.longPress:
        return Icons.speed;
      case GestureType.singleTap:
        return Icons.play_arrow;
    }
  }

  /// Gets the appropriate color for a gesture type.
  static Color getGestureColor(GestureType gestureType) {
    switch (gestureType) {
      case GestureType.doubleTap:
        return Colors.blue;
      case GestureType.verticalSwipe:
        return Colors.orange;
      case GestureType.horizontalSwipe:
        return Colors.green;
      case GestureType.pinch:
        return Colors.purple;
      case GestureType.longPress:
        return Colors.red;
      case GestureType.singleTap:
        return Colors.white;
    }
  }

  /// Gets the appropriate description for a gesture type.
  static String getGestureDescription(GestureType gestureType) {
    switch (gestureType) {
      case GestureType.doubleTap:
        return 'Double tap to seek';
      case GestureType.verticalSwipe:
        return 'Swipe vertically for brightness/volume';
      case GestureType.horizontalSwipe:
        return 'Swipe horizontally to seek';
      case GestureType.pinch:
        return 'Pinch to zoom';
      case GestureType.longPress:
        return 'Long press for speed control';
      case GestureType.singleTap:
        return 'Tap to toggle controls';
    }
  }
}
