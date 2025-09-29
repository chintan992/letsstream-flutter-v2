import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/core/services/cache_service.dart';
import 'package:lets_stream/src/shared/theme/theme_providers.dart';
import 'package:lets_stream/src/shared/theme/theme_model.dart';

class ProfileService {
  Future<void> clearCache(BuildContext context) async {
    try {
      await CacheService.instance.clearAllCache();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Cache cleared successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to clear cache: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> setTheme(
    BuildContext context,
    WidgetRef ref,
    AppThemeType themeType,
    ThemeNotifier themeNotifier,
  ) async {
    await themeNotifier.setTheme(themeType);
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
