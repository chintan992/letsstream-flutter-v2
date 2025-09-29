import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lets_stream/src/features/profile/services/profile_service.dart';
import 'package:lets_stream/src/features/profile/presentation/widgets/profile_header.dart';
import 'package:lets_stream/src/features/profile/presentation/widgets/account_section.dart';
import 'package:lets_stream/src/features/profile/presentation/widgets/preferences_section.dart';
import 'package:lets_stream/src/features/profile/presentation/widgets/about_section.dart';
import 'package:lets_stream/src/features/profile/presentation/widgets/section_header.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileService = ProfileService();

    return Scaffold(
      appBar: const ProfileHeader(),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SectionHeader('Account'),
          AccountSection(profileService: profileService),
          const Divider(),
          const SectionHeader('Preferences'),
          PreferencesSection(profileService: profileService, ref: ref),
          const Divider(),
          const SectionHeader('About'),
          const AboutSection(),
        ],
      ),
    );
  }
}
