import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/features/simkl_auth/services/simkl_auth_service.dart';
import 'package:lets_stream/src/core/services/simkl/simkl_api_client.dart';
import 'package:lets_stream/src/core/models/simkl/simkl_auth_models.dart';
import 'package:lets_stream/src/features/profile/services/profile_service.dart';

class AccountSection extends StatelessWidget {
  final ProfileService profileService;
  final WidgetRef ref;

  const AccountSection({
    super.key,
    required this.profileService,
    required this.ref,
  });

  @override
  Widget build(BuildContext context) {
    final simklAuthService = SimklAuthService(SimklApiClient(), ref);

    return FutureBuilder<bool>(
      future: simklAuthService.isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const ListTile(
            leading: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            title: Text('Simkl Account'),
            subtitle: Text('Checking authentication...'),
          );
        }

        final authenticated = snapshot.data ?? false;

        if (authenticated) {
          return _AuthenticatedAccountSection(
            profileService: profileService,
            authService: simklAuthService,
          );
        } else {
          return _UnauthenticatedAccountSection(
            profileService: profileService,
            authService: simklAuthService,
          );
        }
      },
    );
  }
}

class _AuthenticatedAccountSection extends StatelessWidget {
  final ProfileService profileService;
  final SimklAuthService authService;

  const _AuthenticatedAccountSection({
    required this.profileService,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SimklUserSettings?>(
      future: authService.getUserSettings(),
      builder: (context, snapshot) {
        final userSettings = snapshot.data;

        return Column(
          children: [
            ListTile(
              leading: CircleAvatar(
                backgroundImage: userSettings?.user.avatar != null
                    ? NetworkImage(userSettings!.user.avatar!)
                    : null,
                child: userSettings?.user.avatar == null
                    ? const Icon(Icons.person)
                    : null,
              ),
              title: Text(userSettings?.user.name ?? 'Simkl User'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Connected to Simkl'),
                  if (userSettings != null)
                    Text(
                      'Joined ${userSettings.user.joinedAt.substring(0, 10)}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                ],
              ),
              trailing: PopupMenuButton<String>(
                onSelected: (value) async {
                  if (value == 'logout') {
                    await profileService.handleLogout(context);
                  } else if (value == 'sync') {
                    await profileService.handleSync(context);
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'sync',
                    child: ListTile(
                      leading: Icon(Icons.sync),
                      title: Text('Sync Data'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  const PopupMenuItem(
                    value: 'logout',
                    child: ListTile(
                      leading: Icon(Icons.logout),
                      title: Text('Sign Out'),
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ),
            if (userSettings != null) ...[
              const Divider(),
              ListTile(
                leading: const Icon(Icons.sync),
                title: const Text('Sync Status'),
                subtitle: const Text('Last sync: Never'),
                trailing: IconButton(
                  icon: const Icon(Icons.sync_problem),
                  onPressed: () => profileService.handleSync(context),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Simkl Settings'),
                subtitle: const Text('Manage your Simkl account'),
                onTap: () => profileService.openSimklSettings(context),
              ),
            ],
          ],
        );
      },
    );
  }
}

class _UnauthenticatedAccountSection extends StatelessWidget {
  final ProfileService profileService;
  final SimklAuthService authService;

  const _UnauthenticatedAccountSection({
    required this.profileService,
    required this.authService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Simkl Account'),
          subtitle: const Text(
            'Connect your Simkl account to sync watch history',
          ),
          trailing: ElevatedButton(
            onPressed: () => _showAuthOptions(context),
            child: const Text('Connect'),
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Simkl lets you track movies, TV shows, and anime across all your devices',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  void _showAuthOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Connect to Simkl',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.web),
              title: const Text('Web Authentication'),
              subtitle: const Text('Open browser to authenticate'),
              onTap: () async {
                Navigator.of(context).pop();
                await profileService.authenticateWithOAuth(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.smartphone),
              title: const Text('Device Authentication'),
              subtitle: const Text('For TV, console, or limited devices'),
              onTap: () async {
                Navigator.of(context).pop();
                await profileService.authenticateWithPin(context);
              },
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
