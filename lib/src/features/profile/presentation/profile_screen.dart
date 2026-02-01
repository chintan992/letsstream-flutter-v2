import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lets_stream/src/features/profile/services/profile_service.dart';
import 'package:lets_stream/src/shared/theme/netflix_colors.dart';
import 'package:lets_stream/src/shared/theme/theme_providers.dart';
import 'package:lets_stream/src/shared/theme/theme_model.dart';

/// Netflix-style profile screen with menu layout.
/// Features profile avatar at top and menu items with chevrons.
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileService = ProfileService();

    return Scaffold(
      backgroundColor: NetflixColors.backgroundBlack,
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 16),
          children: [
            // Profile Header
            _buildProfileHeader(ref),
            
            const SizedBox(height: 24),
            
            // Menu Items
            _buildMenuSection(
              'Account',
              [
                _MenuItem(
                  icon: Icons.notifications_outlined,
                  title: 'Notifications',
                  onTap: () => _showNotifications(context),
                ),
                _MenuItem(
                  icon: Icons.bookmark_outline,
                  title: 'My List',
                  onTap: () => context.push('/watchlist'),
                ),
              ],
            ),
            
            _buildMenuSection(
              'Settings',
              [
                _MenuItem(
                  icon: Icons.settings_outlined,
                  title: 'App Settings',
                  onTap: () => _showAppSettings(context, ref, profileService),
                ),
                _MenuItem(
                  icon: Icons.person_outline,
                  title: 'Account',
                  onTap: () => _showAccount(context),
                ),
                _MenuItem(
                  icon: Icons.help_outline,
                  title: 'Help',
                  onTap: () => _showHelp(context),
                ),
              ],
            ),
            
            _buildMenuSection(
              'Legal',
              [
                _MenuItem(
                  icon: Icons.privacy_tip_outlined,
                  title: 'Privacy Policy',
                  onTap: () => _showPrivacyPolicy(context),
                ),
                _MenuItem(
                  icon: Icons.gavel_outlined,
                  title: 'Terms of Service',
                  onTap: () => _showTermsOfService(context),
                ),
              ],
            ),
            
            const SizedBox(height: 24),
            
            // Sign Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: ElevatedButton(
                onPressed: () => _showSignOutDialog(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: NetflixColors.surfaceMedium,
                  foregroundColor: NetflixColors.textPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                child: const Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 32),
            
            // Version info
            Center(
              child: Text(
                'Version 1.0.0',
                style: TextStyle(
                  color: NetflixColors.textTertiary,
                  fontSize: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(WidgetRef ref) {
    return Column(
      children: [
        // Avatar
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            color: NetflixColors.surfaceMedium,
            shape: BoxShape.circle,
            border: Border.all(
              color: NetflixColors.surfaceLight,
              width: 2,
            ),
          ),
          child: const Icon(
            Icons.person,
            size: 60,
            color: NetflixColors.textSecondary,
          ),
        ),
        const SizedBox(height: 16),
        
        // User Name
        const Text(
          'Guest User',
          style: TextStyle(
            color: NetflixColors.textPrimary,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        
        // Email or subtitle
        Text(
          'Sign in to access all features',
          style: TextStyle(
            color: NetflixColors.textSecondary,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildMenuSection(String title, List<_MenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Title
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            title,
            style: const TextStyle(
              color: NetflixColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // Menu Items
        Container(
          color: NetflixColors.surfaceDark,
          child: Column(
            children: items.asMap().entries.map((entry) {
              final index = entry.key;
              final item = entry.value;
              final isLast = index == items.length - 1;
              
              return Column(
                children: [
                  ListTile(
                    leading: Icon(
                      item.icon,
                      color: NetflixColors.textPrimary,
                      size: 24,
                    ),
                    title: Text(
                      item.title,
                      style: const TextStyle(
                        color: NetflixColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    trailing: const Icon(
                      Icons.chevron_right,
                      color: NetflixColors.textSecondary,
                      size: 24,
                    ),
                    onTap: item.onTap,
                  ),
                  if (!isLast)
                    Divider(
                      height: 1,
                      indent: 56,
                      endIndent: 16,
                      color: NetflixColors.surfaceLight,
                    ),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  void _showNotifications(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NetflixColors.backgroundBlack,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notifications_none,
              color: NetflixColors.textSecondary,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'No new notifications',
              style: TextStyle(
                color: NetflixColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Notifications will appear here when available',
              style: TextStyle(
                color: NetflixColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: NetflixColors.textPrimary,
                foregroundColor: NetflixColors.backgroundBlack,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAppSettings(
    BuildContext context,
    WidgetRef ref,
    ProfileService profileService,
  ) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final themeNotifier = ref.read(themeNotifierProvider.notifier);

    showModalBottomSheet(
      context: context,
      backgroundColor: NetflixColors.backgroundBlack,
      isScrollControlled: true,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'App Settings',
                  style: TextStyle(
                    color: NetflixColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(
                    Icons.close,
                    color: NetflixColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            
            // Theme Section
            const Text(
              'Theme',
              style: TextStyle(
                color: NetflixColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              decoration: BoxDecoration(
                color: NetflixColors.surfaceDark,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                children: AppThemeType.values.map((themeType) {
                  final isSelected = currentTheme == themeType;
                  return ListTile(
                    leading: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: themeType.primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    title: Text(
                      themeType.displayName,
                      style: const TextStyle(
                        color: NetflixColors.textPrimary,
                        fontSize: 16,
                      ),
                    ),
                    subtitle: Text(
                      themeType.description,
                      style: const TextStyle(
                        color: NetflixColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check,
                            color: NetflixColors.primaryRed,
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
                  );
                }).toList(),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Cache Section
            const Text(
              'Data',
              style: TextStyle(
                color: NetflixColors.textSecondary,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            
            Container(
              decoration: BoxDecoration(
                color: NetflixColors.surfaceDark,
                borderRadius: BorderRadius.circular(4),
              ),
              child: ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: NetflixColors.textPrimary,
                ),
                title: const Text(
                  'Clear Cache',
                  style: TextStyle(
                    color: NetflixColors.textPrimary,
                    fontSize: 16,
                  ),
                ),
                subtitle: const Text(
                  'Remove all cached data',
                  style: TextStyle(
                    color: NetflixColors.textSecondary,
                    fontSize: 12,
                  ),
                ),
                onTap: () async {
                  final confirmed = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      backgroundColor: NetflixColors.surfaceDark,
                      title: const Text(
                        'Clear Cache',
                        style: TextStyle(color: NetflixColors.textPrimary),
                      ),
                      content: const Text(
                        'This will clear all cached data. Continue?',
                        style: TextStyle(color: NetflixColors.textSecondary),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text(
                            'Cancel',
                            style: TextStyle(color: NetflixColors.textSecondary),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: NetflixColors.primaryRed),
                          ),
                        ),
                      ],
                    ),
                  );
                  
                  if (confirmed == true && context.mounted) {
                    await profileService.clearCache(context);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAccount(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NetflixColors.backgroundBlack,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_outline,
              color: NetflixColors.textSecondary,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Account',
              style: TextStyle(
                color: NetflixColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Account features will be available in a future update',
              style: TextStyle(
                color: NetflixColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: NetflixColors.textPrimary,
                foregroundColor: NetflixColors.backgroundBlack,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showHelp(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NetflixColors.backgroundBlack,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.help_outline,
              color: NetflixColors.textSecondary,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Help Center',
              style: TextStyle(
                color: NetflixColors.textPrimary,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'For support, please contact us at:\nsupport@letsstream.app',
              style: TextStyle(
                color: NetflixColors.textSecondary,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: NetflixColors.textPrimary,
                foregroundColor: NetflixColors.backgroundBlack,
                padding: const EdgeInsets.symmetric(
                  horizontal: 32,
                  vertical: 12,
                ),
              ),
              child: const Text('OK'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSignOutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: NetflixColors.surfaceDark,
        title: const Text(
          'Sign Out',
          style: TextStyle(color: NetflixColors.textPrimary),
        ),
        content: const Text(
          'Are you sure you want to sign out?',
          style: TextStyle(color: NetflixColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: NetflixColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Sign out logic here
            },
            child: const Text(
              'Sign Out',
              style: TextStyle(color: NetflixColors.primaryRed),
            ),
          ),
        ],
      ),
    );
  }

  void _showPrivacyPolicy(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: NetflixColors.backgroundBlack,
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
                const Icon(
                  Icons.privacy_tip,
                  size: 28,
                  color: NetflixColors.textPrimary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Privacy Policy',
                  style: TextStyle(
                    color: NetflixColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: NetflixColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Last updated: September 4, 2025',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        color: NetflixColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildPolicySection(
                      '1. Information We Collect',
                      'We collect information you provide directly to us, such as when you create an account, use our services, or contact us for support.',
                    ),
                    _buildPolicySection(
                      '2. How We Use Your Information',
                      'We use the information we collect to provide, maintain, and improve our services, process transactions, and respond to your questions.',
                    ),
                    _buildPolicySection(
                      '3. Information Sharing',
                      'We do not sell, trade, or otherwise transfer your personal information to third parties without your consent.',
                    ),
                    const SizedBox(height: 24),
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
      backgroundColor: NetflixColors.backgroundBlack,
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
                const Icon(
                  Icons.gavel,
                  size: 28,
                  color: NetflixColors.textPrimary,
                ),
                const SizedBox(width: 12),
                const Text(
                  'Terms of Service',
                  style: TextStyle(
                    color: NetflixColors.textPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(
                    Icons.close,
                    color: NetflixColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Educational Demonstration Notice',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: NetflixColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'This application is strictly an educational demonstration project. We do not host, store, or distribute any media content.',
                      style: TextStyle(color: NetflixColors.textSecondary),
                    ),
                    const SizedBox(height: 16),
                    _buildPolicySection(
                      '1. Acceptance of Terms',
                      'By accessing and using this educational demonstration, you accept and agree to be bound by these Terms of Service.',
                    ),
                    _buildPolicySection(
                      '2. Service Description',
                      'This is a frontend demonstration project that interfaces with third-party APIs to showcase programming concepts.',
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildPolicySection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: NetflixColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content,
          style: const TextStyle(
            color: NetflixColors.textSecondary,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
