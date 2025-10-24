/// Represents different types of gestures in the video player.
enum GestureType {
  /// Double tap gesture for seeking.
  doubleTap,
  
  /// Vertical swipe for brightness/volume control.
  verticalSwipe,
  
  /// Horizontal swipe for seeking.
  horizontalSwipe,
  
  /// Pinch gesture for zooming.
  pinch,
  
  /// Long press for speed control.
  longPress,
  
  /// Single tap for toggling controls.
  singleTap,
}

/// Represents the direction of a swipe gesture.
enum SwipeDirection {
  up,
  down,
  left,
  right,
}

/// Represents the side of the screen for gesture detection.
enum GestureSide {
  left,
  right,
  center,
}
