import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import '../providers/auth_provider.dart';
import '../providers/chat_provider.dart';
import '../providers/theme_provider.dart';
import '../../core/services/supabase_service.dart';
import '../../core/theme/app_theme.dart';
import '../../features/chat/chat_screen.dart';
import '../../features/chat/chat_history_screen.dart';
import '../../features/bible/bible_reading_screen.dart';
import '../../features/bible/home_screen.dart';
import '../../features/favorites/favorites_screen.dart';
import '../../features/subscription/subscription_screen.dart';

class MainScaffold extends ConsumerWidget {
  final Widget child;
  const MainScaffold({required this.child, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: _buildTitle(context),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const MainScaffold(child: HomeScreen()),
                ),
              );
            },
            tooltip: 'Go to Home',
          ),
        ],
      ),
      drawer: SideMenu(user: user),
      body: child,
    );
  }

  Widget _buildTitle(BuildContext context) {
    if (child is ChatScreen) {
      // For chat screen, we'll show a simple title since we can't access the conversation title here
      return const Text('Chat');
    } else if (child is HomeScreen) {
      return const Text('Chat with God');
    } else if (child is ChatHistoryScreen) {
      return const Text('Chat History');
    } else if (child is BibleReadingScreen) {
      return const Text('Bible Reading Plan');
    } else if (child is FavoritesScreen) {
      return const Text('Favorites & Notes');
    }
    return const Text('Chat with God');
  }
}

class SideMenu extends ConsumerWidget {
  final dynamic user;
  const SideMenu({required this.user, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final theme = Theme.of(context);
    
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          image: const DecorationImage(
            image: AssetImage('assets/images/cloud.jpg'),
            fit: BoxFit.cover,
            opacity: 0.2, // Very subtle background
          ),
          color: theme.colorScheme.surface,
        ),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.1),
                theme.colorScheme.surface.withValues(alpha: 0.95),
              ],
            ),
          ),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              // Enhanced Header with Cloud Background
              Container(
                height: 200,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      theme.colorScheme.primary.withValues(alpha: 0.8),
                      theme.colorScheme.secondary.withValues(alpha: 0.6),
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    // Cloud background overlay
                    Positioned.fill(
                      child: Container(
                        decoration: const BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/images/cloud.jpg'),
                            fit: BoxFit.cover,
                            opacity: 0.3,
                          ),
                        ),
                      ),
                    ),
                    // User info overlay
                    Positioned.fill(
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircleAvatar(
                              radius: 40,
                              backgroundColor: theme.colorScheme.onPrimary.withValues(alpha: 0.2),
                              child: Text(
                                (user?.userMetadata?['full_name'] ?? 'U').substring(0, 1),
                                style: TextStyle(
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                  color: theme.colorScheme.onPrimary,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              user?.userMetadata?['full_name'] ?? 'User',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onPrimary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user?.email ?? '',
                              style: TextStyle(
                                fontSize: 14,
                                color: theme.colorScheme.onPrimary.withValues(alpha: 0.8),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Menu Items
              Container(
                color: theme.colorScheme.surface.withValues(alpha: 0.9),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context: context,
                      icon: Icons.home,
                      title: 'Home',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainScaffold(child: HomeScreen()),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.chat,
                      title: 'New Chat',
                      onTap: () {
                        ref.read(chatNotifierProvider.notifier).startNewChat();
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainScaffold(child: ChatScreen()),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.history,
                      title: 'Chat History',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainScaffold(child: ChatHistoryScreen()),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.favorite,
                      title: 'Favorites & Notes',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainScaffold(child: FavoritesScreen()),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.book,
                      title: 'Bible Reading Plan',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const MainScaffold(child: BibleReadingScreen()),
                          ),
                        );
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.calendar_today,
                      title: 'Daily Verse',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    // Theme Toggle
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.transparent,
                      ),
                      child: ListTile(
                        leading: Icon(
                          isDarkMode ? Icons.light_mode : Icons.dark_mode,
                          color: theme.colorScheme.primary,
                          size: 24,
                        ),
                        title: Text(
                          isDarkMode ? 'Light Mode' : 'Dark Mode',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                        trailing: Switch(
                          value: isDarkMode,
                          onChanged: (value) {
                            ref.read(themeProvider.notifier).toggleTheme();
                          },
                          activeColor: theme.colorScheme.primary,
                        ),
                        onTap: () {
                          ref.read(themeProvider.notifier).toggleTheme();
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.settings,
                      title: 'Settings',
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.star,
                      title: 'Subscription',
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MainScaffold(child: SubscriptionScreen()),
                          ),
                        );
                      },
                    ),
                    const Divider(height: 32, thickness: 1),
                    _buildMenuItem(
                      context: context,
                      icon: Icons.logout,
                      title: 'Sign Out',
                      onTap: () async {
                        await ref.read(authNotifierProvider.notifier).signOut();
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.transparent,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: theme.colorScheme.primary,
          size: 24,
        ),
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: theme.colorScheme.onSurface,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
    );
  }
} 