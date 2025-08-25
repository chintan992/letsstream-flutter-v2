import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'shimmer_box.dart';

class EnhancedShimmerRow extends StatelessWidget {
  final int itemCount;
  final double itemWidth;
  final double itemHeight;
  final double spacing;
  final bool showTitles;
  
  const EnhancedShimmerRow({
    super.key,
    this.itemCount = 5,
    this.itemWidth = 120,
    this.itemHeight = 180,
    this.spacing = 12,
    this.showTitles = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: itemHeight + (showTitles ? 40 : 0),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(
              right: index == itemCount - 1 ? 0 : spacing,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerBox(
                  width: itemWidth,
                  height: itemHeight,
                  borderRadius: BorderRadius.circular(12),
                )
                    .animate(delay: Duration(milliseconds: 100 * index))
                    .slideX(begin: 0.2, duration: 300.ms)
                    .fadeIn(),
                if (showTitles) ...[
                  const SizedBox(height: 8),
                  ShimmerBox(
                    width: itemWidth * 0.8,
                    height: 16,
                    borderRadius: BorderRadius.circular(4),
                  )
                      .animate(delay: Duration(milliseconds: 200 + (100 * index)))
                      .fadeIn(duration: 200.ms),
                  const SizedBox(height: 4),
                  ShimmerBox(
                    width: itemWidth * 0.6,
                    height: 12,
                    borderRadius: BorderRadius.circular(4),
                  )
                      .animate(delay: Duration(milliseconds: 300 + (100 * index)))
                      .fadeIn(duration: 200.ms),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

class EnhancedShimmerGrid extends StatelessWidget {
  final int itemCount;
  final double itemWidth;
  final double itemHeight;
  final int crossAxisCount;
  final double mainAxisSpacing;
  final double crossAxisSpacing;
  final bool showTitles;
  
  const EnhancedShimmerGrid({
    super.key,
    this.itemCount = 10,
    this.itemWidth = 120,
    this.itemHeight = 180,
    this.crossAxisCount = 2,
    this.mainAxisSpacing = 16,
    this.crossAxisSpacing = 12,
    this.showTitles = true,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: itemWidth / (itemHeight + (showTitles ? 40 : 0)),
        mainAxisSpacing: mainAxisSpacing,
        crossAxisSpacing: crossAxisSpacing,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ShimmerBox(
                width: double.infinity,
                height: double.infinity,
                borderRadius: BorderRadius.circular(12),
              )
                  .animate(delay: Duration(milliseconds: 100 * index))
                  .scale(begin: const Offset(0.8, 0.8), duration: 300.ms)
                  .fadeIn(),
            ),
            if (showTitles) ...[
              const SizedBox(height: 8),
              ShimmerBox(
                width: double.infinity,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              )
                  .animate(delay: Duration(milliseconds: 200 + (50 * index)))
                  .fadeIn(duration: 200.ms),
              const SizedBox(height: 4),
              ShimmerBox(
                width: itemWidth * 0.6,
                height: 12,
                borderRadius: BorderRadius.circular(4),
              )
                  .animate(delay: Duration(milliseconds: 300 + (50 * index)))
                  .fadeIn(duration: 200.ms),
            ],
          ],
        );
      },
    );
  }
}

class AnimatedCounterWidget extends StatefulWidget {
  final int count;
  final String label;
  final IconData icon;
  final Duration animationDuration;

  const AnimatedCounterWidget({
    super.key,
    required this.count,
    required this.label,
    required this.icon,
    this.animationDuration = const Duration(milliseconds: 1500),
  });

  @override
  State<AnimatedCounterWidget> createState() => _AnimatedCounterWidgetState();
}

class _AnimatedCounterWidgetState extends State<AnimatedCounterWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _countAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    
    _countAnimation = Tween<double>(
      begin: 0,
      end: widget.count.toDouble(),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));
    
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.icon,
            size: 32,
            color: Theme.of(context).colorScheme.primary,
          )
              .animate()
              .scale(begin: const Offset(0, 0), duration: 500.ms)
              .then()
              .shake(duration: 200.ms),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _countAnimation,
            builder: (context, child) {
              return Text(
                _countAnimation.value.toInt().toString(),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.primary,
                ),
              );
            },
          ),
          const SizedBox(height: 4),
          Text(
            widget.label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
