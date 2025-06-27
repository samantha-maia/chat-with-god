import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'providers/daily_verse_provider.dart';
import '../../shared/providers/chat_provider.dart';
import '../../shared/providers/auth_provider.dart';
import '../chat/chat_screen.dart';
import '../chat/chat_history_screen.dart';
import '../../shared/widgets/main_scaffold.dart';
import 'bible_reading_screen.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../features/subscription/subscription_screen.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: const AssetImage('assets/images/cloud.jpg'),
            fit: BoxFit.cover,
            opacity: isDark ? 0.08 : 0.3,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [theme.colorScheme.background, theme.colorScheme.surface]
                : [theme.colorScheme.primary.withOpacity(0.05), theme.colorScheme.background],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                
                // Welcome Section
                _buildWelcomeSection(context, ref),
                
                const SizedBox(height: 30),
                
                // Daily Verse Card
                _buildDailyVerseCard(context, ref, theme, isDark),
                
                const SizedBox(height: 30),
                
                // Action Buttons
                _buildActionButtons(context, ref, theme, isDark),
                
                const SizedBox(height: 30),
                
                // Quick Stats
                _buildQuickStats(context, ref, theme, isDark),
                
                const SizedBox(height: 30),
                
                // Ad Banner
                _buildAdBanner(context, ref, theme, isDark),
                
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authNotifierProvider);
    final userName = user?.userMetadata?['full_name']?.split(' ').first ?? 'Friend';
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Good ${_getGreeting()}',
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w300,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '$userName!',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.darkPrimaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Ready to connect with God today?',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyVerseCard(BuildContext context, WidgetRef ref, ThemeData theme, bool isDark) {
    return Consumer(
      builder: (context, ref, child) {
        final verseAsync = ref.watch(dailyVerseProvider);
        
        return verseAsync.when(
          data: (verse) => Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : theme.colorScheme.surface.withOpacity(0.98),
                borderRadius: BorderRadius.circular(20),
                border: isDark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
                boxShadow: [
                  BoxShadow(
                    color: isDark ? Colors.black.withOpacity(0.5) : Colors.black.withOpacity(0.08),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryColor.withValues(alpha: 0.05),
                    AppTheme.primaryColor.withValues(alpha: 0.1),
                  ],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.lightbulb,
                        color: theme.colorScheme.primary,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "Today's Verse",
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        verse.translation,
                        style: theme.textTheme.labelMedium?.copyWith(
                          color: theme.colorScheme.primary.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    '"${verse.verse}"',
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.onSurface,
                      fontWeight: FontWeight.w500,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    verse.reference,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary.withOpacity(0.8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (verse.explanation != null) ...[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? theme.colorScheme.background.withOpacity(0.95) : Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: isDark ? Colors.white.withOpacity(0.08) : Colors.grey.withOpacity(0.15)),
                        boxShadow: [
                          if (!isDark)
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                        ],
                      ),
                      child: Text(
                        verse.explanation!,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurface,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          loading: () => Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Padding(
              padding: EdgeInsets.all(24),
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          error: (error, stack) => Card(
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text('Error loading today\'s verse: $error'),
            ),
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, ThemeData theme, bool isDark) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              shadowColor: isDark ? Colors.black.withOpacity(0.3) : theme.colorScheme.primary.withOpacity(0.2),
            ),
            icon: const Icon(Icons.chat_bubble_outline),
            label: Text(
              'Start New Chat',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              ref.read(chatNotifierProvider.notifier).startNewChat();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MainScaffold(child: ChatScreen()),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? theme.colorScheme.primary : theme.colorScheme.primary,
              side: BorderSide(color: theme.colorScheme.primary.withOpacity(isDark ? 0.8 : 1.0), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: isDark ? theme.colorScheme.surface.withOpacity(0.7) : Colors.transparent,
            ),
            icon: Icon(Icons.lightbulb_outline, color: theme.colorScheme.primary),
            label: Text(
              'Understand More of This Verse',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary.withOpacity(isDark ? 0.95 : 1.0),
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              final dailyVerseAsync = ref.read(dailyVerseProvider);
              final dailyVerse = dailyVerseAsync.value;
              if (dailyVerse == null) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Versículo do dia não disponível.')),
                );
                return;
              }
              final promptTr = tr('prompt_understand_verse', namedArgs: {
                'verse': dailyVerse.verse,
                'reference': dailyVerse.reference,
              });
              final prompt = (promptTr == 'prompt_understand_verse')
                ? 'Help me better understand this verse and how to apply it in my life: "${dailyVerse.verse}" (${dailyVerse.reference})'
                : promptTr;
              ref.read(chatNotifierProvider.notifier).startNewChat();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MainScaffold(
                    child: ChatScreen(
                      initialInput: prompt,
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? Colors.orange : Colors.orange,
              side: BorderSide(color: Colors.orange.withOpacity(isDark ? 0.8 : 1.0), width: 1.5),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              backgroundColor: isDark ? Colors.orange.withOpacity(0.1) : Colors.orange.withOpacity(0.05),
            ),
            icon: Icon(Icons.star, color: Colors.orange),
            label: Text(
              tr('subscription.remove_ads_premium'),
              style: theme.textTheme.titleMedium?.copyWith(
                color: Colors.orange.withOpacity(isDark ? 0.95 : 1.0),
                fontWeight: FontWeight.w600,
              ),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => MainScaffold(child: SubscriptionScreen()),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats(BuildContext context, WidgetRef ref, ThemeData theme, bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? theme.colorScheme.surface.withOpacity(0.97) : theme.colorScheme.surface.withOpacity(0.97),
        borderRadius: BorderRadius.circular(20),
        border: isDark ? Border.all(color: Colors.white.withOpacity(0.06)) : null,
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.4) : Colors.black.withOpacity(0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your Spiritual Journey',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainScaffold(child: BibleReadingScreen()),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: theme.colorScheme.primary.withOpacity(isDark ? 0.08 : 0.05),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.menu_book, color: theme.colorScheme.primary, size: 28),
                          const SizedBox(height: 8),
                          Text(
                            'Bible Reading',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'Track Progress',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MainScaffold(child: ChatHistoryScreen()),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: theme.colorScheme.primary.withOpacity(isDark ? 0.08 : 0.05),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.history, color: theme.colorScheme.primary, size: 28),
                          const SizedBox(height: 8),
                          Text(
                            'Chat History',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'View Past',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdBanner(BuildContext context, WidgetRef ref, ThemeData theme, bool isDark) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.orange.withOpacity(0.1),
            Colors.orange.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.orange.withOpacity(0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: isDark ? Colors.black.withOpacity(0.2) : Colors.orange.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            // TODO: Handle ad tap - could open subscription screen or show ad
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Ad clicked!'),
                duration: Duration(seconds: 1),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.orange.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    Icons.star,
                    color: Colors.orange,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tr('subscription.upgrade_to_premium'),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        tr('subscription.remove_ads_unlimited'),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.orange,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Morning';
    if (hour < 17) return 'Afternoon';
    return 'Evening';
  }

  void _startVerseChat(BuildContext context, WidgetRef ref) async {
    // Set loading state
    ref.read(verseChatLoadingProvider.notifier).state = true;
    
    try {
      final versePrompt = ref.read(dailyVersePromptProvider);
      
      // Start a new chat and send the verse message to AI
      await ref.read(chatNotifierProvider.notifier).startNewChatWithMessage(versePrompt);
      
      // Navigate to chat screen after the message is sent and AI responds
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => const MainScaffold(child: ChatScreen()),
          ),
        );
      }
      
    } catch (e) {
      // Show error if something goes wrong
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error starting verse chat: $e'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      // Clear loading state
      ref.read(verseChatLoadingProvider.notifier).state = false;
    }
  }

  void _navigateToBibleReading(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScaffold(child: BibleReadingScreen()),
      ),
    );
  }

  void _navigateToChatHistory(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => const MainScaffold(child: ChatHistoryScreen()),
      ),
    );
  }
} 