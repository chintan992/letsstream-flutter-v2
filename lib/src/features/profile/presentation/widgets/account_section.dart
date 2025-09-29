import 'package:flutter/material.dart';
import 'package:lets_stream/src/features/profile/services/profile_service.dart';

class AccountSection extends StatelessWidget {
  final ProfileService profileService;

  const AccountSection({
    super.key,
    required this.profileService,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.person_outline),
          title: const Text('Account'),
          subtitle: const Text(
            'Profile and account management',
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Account features will be available in a future update',
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
