import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final BorderRadius? borderRadius;

  const ShimmerBox({super.key, required this.width, required this.height, this.borderRadius});

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    final highlight = Theme.of(context).colorScheme.surface;
    final child = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: base,
        borderRadius: borderRadius ?? BorderRadius.circular(8),
      ),
    );
    return Shimmer.fromColors(
      baseColor: base.withValues(alpha: 0.6),
      highlightColor: highlight.withValues(alpha: 0.9),
      period: const Duration(milliseconds: 1200),
      child: child,
    );
  }
}
