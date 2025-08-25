import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/application/auth_providers.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final actions = ref.read(authActionsProvider);

    Widget accountSection() {
      return authState.when(
        data: (user) {
          if (user == null) {
            return ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Sign in'),
              subtitle: const Text('Sign in to sync your watchlist and favorites'),
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
                child: (user.photoURL == null) ? const Icon(Icons.person) : null,
              ),
              title: Text(user.displayName ?? 'Signed in'),
              subtitle: Text(user.email ?? user.uid),
              trailing: OutlinedButton.icon(
                icon: const Icon(Icons.logout),
                label: const Text('Sign out'),
                onPressed: () async {
                  await actions.signOut();
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Signed out')),
                  );
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
          const ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Theme'),
            subtitle: Text('System default'),
          ),
          const ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Clear cache'),
          ),
          const Divider(),
          const _SectionHeader('About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("Let's Stream"),
            subtitle: Text('A media discovery app built with Flutter'),
          ),
        ],
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
