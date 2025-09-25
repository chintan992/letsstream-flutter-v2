import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/shared/widgets/app_logo.dart';
import 'package:lets_stream/src/shared/theme/theme_providers.dart';
import 'package:lets_stream/src/shared/theme/theme_model.dart';
import 'package:lets_stream/src/core/services/cache_service.dart';
import 'package:lets_stream/src/features/simkl_auth/services/simkl_auth_service.dart';
import 'package:lets_stream/src/core/services/simkl/simkl_api_client.dart';
import 'package:lets_stream/src/core/models/simkl/simkl_auth_models.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const _SectionHeader('Account'),
          _buildAccountSection(context, ref),
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
            },
          ),
          const Divider(),
          const _SectionHeader('About'),
          ListTile(
            leading: const AppLogo(size: 24),
            title: const Text("Let's Stream"),
            subtitle: const Text('A media discovery app built with Flutter'),
          ),
          ListTile(
            leading: const Icon(Icons.privacy_tip_outlined),
            title: const Text('Privacy Policy'),
            subtitle: const Text('Learn how we protect your data'),
            onTap: () => _showPrivacyPolicy(context),
          ),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text('Version'),
            subtitle: const Text('1.0.0 (1)'),
          ),
          ListTile(
            leading: const Icon(Icons.gavel_outlined),
            title: const Text('Terms of Service'),
            subtitle: const Text('Read our terms and conditions'),
            onTap: () => _showTermsOfService(context),
          ),
          ListTile(
            leading: const Icon(Icons.warning_amber_outlined),
            title: const Text('DMCA Notice'),
            subtitle: const Text('Copyright and content policy'),
            onTap: () => _showDmcaNotice(context),
          ),
        ],
      ),
    );
  }

  Widget _buildAccountSection(BuildContext context, WidgetRef ref) {
    final simklAuthService = SimklAuthService(
      SimklApiClient(),
      ref as Ref<Object?>,
    );

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
          return _buildAuthenticatedAccountSection(
            context,
            ref,
            simklAuthService,
          );
        } else {
          return _buildUnauthenticatedAccountSection(
            context,
            ref,
            simklAuthService,
          );
        }
      },
    );
  }

  Widget _buildAuthenticatedAccountSection(
    BuildContext context,
    WidgetRef ref,
    SimklAuthService authService,
  ) {
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
                    await _handleLogout(context, ref, authService);
                  } else if (value == 'sync') {
                    await _handleSync(context, ref, authService);
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
                  onPressed: () => _handleSync(context, ref, authService),
                ),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Simkl Settings'),
                subtitle: const Text('Manage your Simkl account'),
                onTap: () => _openSimklSettings(context),
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _buildUnauthenticatedAccountSection(
    BuildContext context,
    WidgetRef ref,
    SimklAuthService authService,
  ) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Simkl Account'),
          subtitle: const Text(
            'Connect your Simkl account to sync watch history',
          ),
          trailing: ElevatedButton(
            onPressed: () => _showAuthOptions(context, ref, authService),
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

  Future<void> _handleLogout(
    BuildContext context,
    WidgetRef ref,
    SimklAuthService authService,
  ) async {
    try {
      await authService.signOut();
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Successfully signed out from Simkl'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to sign out: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  Future<void> _handleSync(
    BuildContext context,
    WidgetRef ref,
    SimklAuthService authService,
  ) async {
    try {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Syncing with Simkl...'),
            duration: Duration(seconds: 1),
          ),
        );
      }

      // TODO: Implement actual sync logic
      await Future.delayed(const Duration(seconds: 2));

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sync completed successfully'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _openSimklSettings(BuildContext context) async {
    const simklUrl = 'https://simkl.com/settings/';
    try {
      final uri = Uri.parse(simklUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Could not open Simkl settings'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error opening Simkl settings: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  void _showAuthOptions(
    BuildContext context,
    WidgetRef ref,
    SimklAuthService authService,
  ) {
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
                try {
                  await authService.authenticateWithOAuth();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Authentication successful!'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Authentication failed: $e'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.smartphone),
              title: const Text('Device Authentication'),
              subtitle: const Text('For TV, console, or limited devices'),
              onTap: () async {
                Navigator.of(context).pop();
                try {
                  await authService.authenticateWithPin();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Device authentication initiated'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Authentication failed: $e'),
                        duration: const Duration(seconds: 3),
                      ),
                    );
                  }
                }
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

  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.privacy_tip, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Privacy Policy',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Last updated: September 4, 2025',
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    SizedBox(height: 16),
                    Text(
                      '1. Information We Collect',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We collect information you provide directly to us, such as when you create an account, '
                      'use our services, or contact us for support. This may include your name, email address, '
                      'and any content you upload or create.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      '2. How We Use Your Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We use the information we collect to provide, maintain, and improve our services, '
                      'process transactions, send you technical notices and support messages, '
                      'and respond to your comments and questions.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      '3. Information Sharing',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We do not sell, trade, or otherwise transfer your personal information to third parties '
                      'without your consent, except as described in this policy.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      '4. Data Security',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We implement appropriate security measures to protect your personal information against '
                      'unauthorized access, alteration, disclosure, or destruction.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      '5. Contact Us',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'If you have any questions about this Privacy Policy, please contact us at: '
                      'privacy@letsstream.com',
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTermsOfService(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.gavel, size: 28),
                const SizedBox(width: 12),
                Text(
                  'Terms of Service',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Educational Demonstration Notice',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This application is strictly an educational demonstration project. We do not host, store, or distribute any media content. All content is fetched from third-party APIs for demonstration purposes only.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      '1. Acceptance of Terms',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'By accessing and using this educational demonstration, you accept and agree to be bound by these Terms of Service. If you do not agree to these terms, please do not use this application.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      '2. Service Description',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This is a frontend demonstration project that interfaces with third-party APIs to showcase programming concepts and techniques. The service may be discontinued at any time without notice.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      '3. Disclaimer of Responsibility',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We are not responsible for any content displayed through third-party APIs. We do not verify, endorse, or take responsibility for any content shown through our demonstration interface.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      '4. Third-Party Content',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'All media content displayed is sourced from third-party APIs. Rights to such content belong to their respective owners. We do not claim ownership of any media content displayed through our interface.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      '5. No Warranties',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This service is provided "as is" without any warranties of any kind. We do not guarantee the availability, accuracy, or continuity of the service as this is purely for educational demonstration.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      '6. Limitation of Liability',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We shall not be liable for any direct, indirect, incidental, special, or consequential damages arising from the use or inability to use this educational demonstration.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      '7. Changes to Terms',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We reserve the right to modify these terms at any time without prior notice. Continued use of the service after any such changes constitutes your acceptance of the new terms.',
                    ),
                    SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDmcaNotice(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning_amber, size: 28),
                const SizedBox(width: 12),
                Text(
                  'DMCA Notice',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Important Notice',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This is an educational demonstration project that does not host any content. All content is fetched from third-party APIs. DMCA notices should be directed to the respective content owners or hosting services.',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Our Role',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'This application is a demonstration that:\n\n'
                      '• Does not host or store any media content\n'
                      '• Uses third-party APIs for educational purposes only\n'
                      '• Has no control over the content provided by these APIs\n'
                      '• May be discontinued at any time',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Third-Party Content',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'For any copyright concerns:\n\n'
                      '• Identify the specific content in question\n'
                      '• Contact the actual hosting service or content owner\n'
                      '• Submit DMCA notices to the appropriate content provider',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Contact Information',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'While we do not host content, if you have questions about our educational demonstration, contact us at:\n\n'
                      'Email: demo@example.com (for demonstration purposes only)',
                    ),
                    SizedBox(height: 16),
                    Text(
                      'Disclaimer',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      'We are not responsible for any content displayed through third-party APIs. This is purely an educational demonstration of frontend development techniques.',
                    ),
                    SizedBox(height: 24),
                  ],
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
