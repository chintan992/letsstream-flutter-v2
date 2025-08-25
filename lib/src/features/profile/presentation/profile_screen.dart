import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile'), centerTitle: true),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: const [
          _SectionHeader('Account'),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Sign in'),
            subtitle: Text('Sign in to sync your watchlist and favorites'),
          ),
          Divider(),
          _SectionHeader('Preferences'),
          ListTile(
            leading: Icon(Icons.palette_outlined),
            title: Text('Theme'),
            subtitle: Text('System default'),
          ),
          ListTile(
            leading: Icon(Icons.delete_outline),
            title: Text('Clear cache'),
          ),
          Divider(),
          _SectionHeader('About'),
          ListTile(
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

