import 'package:flutter/material.dart';

class AppLogo extends StatelessWidget {
  final double size;
  final bool showText;
  final Color? color;

  const AppLogo({super.key, this.size = 48, this.showText = false, this.color});

  @override
  Widget build(BuildContext context) {
    final logoColor = color ?? Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Use PNG for the logo mark
        SizedBox(
          width: size,
          height: size,
          child: Image.asset(
            'assets/images/icon-512x512.png',
            fit: BoxFit.contain,
          ),
        ),
        if (showText) ...[
          const SizedBox(width: 12),
          Text(
            'Let\'s Stream',
            style: TextStyle(
              fontSize: size * 0.5,
              fontWeight: FontWeight.bold,
              color: logoColor,
            ),
          ),
        ],
      ],
    );
  }
}
