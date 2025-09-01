import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_providers.dart';
import 'package:lets_stream/src/shared/widgets/app_logo.dart';
import 'package:lets_stream/src/shared/theme/theme_providers.dart';
import 'package:lets_stream/src/shared/theme/theme_model.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final actions = ref.read(authActionsProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    Widget accountSection() {
      return authState.when(
        data: (user) {
          if (user == null) {
            return ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Sign in'),
              subtitle: const Text(
                'Sign in to sync your watchlist and favorites',
              ),
              trailing: ElevatedButton.icon(
                icon: const Icon(Icons.login),
                label: const Text('Sign in with Google'),
                onPressed: () async {
                  try {
                    await actions.signInWithGoogle();
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Signed in successfully')),
                    );
                  } catch (e) {
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Sign-in failed: $e')),
                    );
                  }
                },
              ),
            );
          } else {
            return ListTile(
              leading: CircleAvatar(
                backgroundImage: (user.photoURL != null)
                    ? NetworkImage(user.photoURL!)
                    : null,
                child: (user.photoURL == null)
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(user.displayName ?? 'Signed in'),
              subtitle: Text(user.email ?? user.uid),
              trailing: OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
                onPressed: () async {
                  await actions.signOut();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(const SnackBar(content: Text('Signed out')));
                },
              ),
            );
          }
        },
        loading: () => const ListTile(
          leading: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          title: Text('Loading account...'),
        ),
        error: (err, _) => ListTile(
          leading: const Icon(Icons.error_outline),
          title: const Text('Error loading account'),
          subtitle: Text('$err'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader('Account'),
          accountSection(),
          const Divider(),
          const _SectionHeader('Preferences'),
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
            onTap: () =>
                _showThemeSelector(context, ref, currentTheme, themeNotifier),
          ),
          const ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Clear cache'),
          ),
          const Divider(),
          const _SectionHeader('About'),
          ListTile(
            leading: const AppLogo(size: 24),
            title: const Text("Let's Stream"),
            subtitle: const Text('A media discovery app built with Flutter'),
          ),
        ],
      ),
    );
  }

  void _showThemeSelector(
    BuildContext context,
    WidgetRef ref,
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
                            await themeNotifier.setTheme(themeType);
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
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

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(text, style: Theme.of(context).textTheme.titleLarge),
    );
  }
}
