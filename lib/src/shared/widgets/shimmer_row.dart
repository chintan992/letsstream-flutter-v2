import 'package:flutter/material.dart';
import 'package:lets_stream/src/shared/widgets/shimmer_box.dart';
import 'package:lets_stream/src/shared/theme/tokens.dart';

class ShimmerRow extends StatelessWidget {
  final double itemWidth;
  final double itemHeight;
  final int count;
  final EdgeInsetsGeometry padding;
  final double spacing;

  const ShimmerRow({
    super.key,
    this.itemWidth = Tokens.posterCardWidth,
    this.itemHeight = 180,
    this.count = 6,
    this.padding = const EdgeInsets.symmetric(horizontal: Tokens.spaceL),
    this.spacing = Tokens.spaceM,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: padding,
        itemCount: count,
        separatorBuilder: (context, index) => SizedBox(width: spacing),
        itemBuilder: (context, index) => ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: ShimmerBox(width: itemWidth, height: itemHeight),
        ),
      ),
    );
  }
}
