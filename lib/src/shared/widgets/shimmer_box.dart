import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../theme/netflix_colors.dart';

/// A Netflix-style shimmer loading box.
///
/// Uses Netflix dark colors for the shimmer effect:
/// - Base color: #2F2F2F (surfaceMedium)
/// - Highlight color: #3F3F3F (surfaceLight)
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: NetflixColors.surfaceMedium,
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
    );
    return Shimmer.fromColors(
      baseColor: NetflixColors.surfaceMedium,
      highlightColor: NetflixColors.surfaceLight,
      period: const Duration(milliseconds: 1200),
      child: child,
    );
  }
}
