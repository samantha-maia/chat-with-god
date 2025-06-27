import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/providers/auth_provider.dart';

class MainScaffold extends ConsumerWidget {
  final Widget child;
  const MainScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    return Scaffold(
      drawer: SideMenu(user: user),
      body: child,
    );
  }
}

class SideMenu extends ConsumerWidget {
  final dynamic user;
  const SideMenu({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(user?.userMetadata?['full_name'] ?? ''),
            accountEmail: Text(user?.email ?? ''),
            currentAccountPicture: CircleAvatar(
              child: Text(
                (user?.userMetadata?['full_name'] ?? 'U').substring(0, 1),
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.chat),
            title: const Text('New Chat'),
            onTap: () {
              // TODO: Create new conversation and navigate to chat
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Chat History'),
            onTap: () {
              // TODO: Navigate to chat history page
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book),
            title: const Text('Bible Reading Plan'),
            onTap: () {
              // TODO: Navigate to Bible Reading Plan
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.calendar_today),
            title: const Text('Daily Verse'),
            onTap: () {
              // TODO: Navigate to Daily Verse
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // TODO: Navigate to Settings
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.star),
            title: const Text('Subscription'),
            onTap: () {
              // TODO: Navigate to Subscription/Upgrade
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Sign Out'),
            onTap: () async {
              await ref.read(authNotifierProvider.notifier).signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
} 