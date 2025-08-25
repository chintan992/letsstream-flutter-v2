import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  final String message;
  final IconData icon;
  final EdgeInsetsGeometry padding;

  const EmptyState({super.key, this.message = 'Nothing here yet', this.icon = Icons.inbox_outlined, this.padding = const EdgeInsets.all(24)});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: Theme.of(context).hintColor),
            const SizedBox(height: 12),
            Text(message, style: Theme.of(context).textTheme.bodyLarge, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}
