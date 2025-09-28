import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/shared/theme/theme_providers.dart';
import 'package:lets_stream/src/shared/theme/theme_model.dart';
import 'package:lets_stream/src/features/profile/services/profile_service.dart';

class PreferencesSection extends StatelessWidget {
  final ProfileService profileService;
  final WidgetRef ref;

  const PreferencesSection({
    super.key,
    required this.profileService,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.palette_outlined),
          title: const Text('Theme'),
          subtitle: Text(currentTheme.displayName),
          trailing: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: currentTheme.primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          onTap: () => _showThemeSelector(context, currentTheme, themeNotifier),
        ),
        ListTile(
          leading: const Icon(Icons.delete_outline),
          title: const Text('Clear cache'),
          subtitle: const Text('Clear all cached data'),
          onTap: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Clear Cache'),
                content: const Text(
                  'This will clear all cached movie and TV show data. '
                  'The app will need to re-download content from the internet. '
                  'Are you sure you want to continue?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: TextButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.error,
                    ),
                    child: const Text('Clear'),
                  ),
                ],
              ),
            );

            if (confirmed == true && context.mounted) {
              await profileService.clearCache(context);
            }
          },
        ),
      ],
    );
  }

  void _showThemeSelector(
    BuildContext context,
    AppThemeType currentTheme,
    ThemeNotifier themeNotifier,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.8,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Theme',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: AppThemeType.values
                      .map(
                        (themeType) => ListTile(
                          leading: Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: themeType.primaryColor,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Theme.of(context).dividerColor,
                                width: 1,
                              ),
                            ),
                          ),
                          title: Text(themeType.displayName),
                          subtitle: Text(themeType.description),
                          trailing: currentTheme == themeType
                              ? Icon(
                                  Icons.check,
                                  color: Theme.of(context).colorScheme.primary,
                                )
                              : null,
                          onTap: () async {
                            await profileService.setTheme(
                              context,
                              ref,
                              themeType,
                              themeNotifier,
                            );
                          },
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
