import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/theme/app_theme.dart';
import 'providers/bible_reading_provider.dart';
import 'widgets/progress_card.dart';
import 'widgets/book_list.dart';
import 'widgets/todays_reading_card.dart';

class BibleReadingScreen extends ConsumerWidget {
  const BibleReadingScreen({super.key});

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
            opacity: isDark ? 0.07 : 0.15,
          ),
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [theme.colorScheme.background, theme.colorScheme.surface]
                : [Colors.white.withOpacity(0.9), Colors.white.withOpacity(0.95)],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: () => ref.read(bibleReadingProvider.notifier).refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Overall Progress Card
                Consumer(
                  builder: (context, ref, child) {
                    final progressAsync = ref.watch(overallProgressProvider);
                    return progressAsync.when(
                      data: (progress) => ProgressCard(progress: progress),
                      loading: () => const ProgressCard(progress: null),
                      error: (error, stack) => Card(
                        color: theme.colorScheme.surface.withOpacity(isDark ? 0.98 : 1.0),
                        elevation: 4,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text('Error loading progress: $error', style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurface)),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                // Today's Reading Suggestion
                Consumer(
                  builder: (context, ref, child) {
                    final todaysReading = ref.watch(todaysReadingProvider);
                    if (todaysReading != null) {
                      return TodaysReadingCard(reading: todaysReading);
                    }
                    return const SizedBox.shrink();
                  },
                ),
                const SizedBox(height: 24),
                // Testament Tabs
                DefaultTabController(
                  length: 2,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: isDark ? theme.colorScheme.surface.withOpacity(0.85) : Colors.grey[200],
                          borderRadius: BorderRadius.circular(10),
                          border: isDark ? Border.all(color: Colors.white.withOpacity(0.07)) : null,
                        ),
                        child: TabBar(
                          labelColor: theme.colorScheme.primary,
                          unselectedLabelColor: isDark ? theme.colorScheme.onSurface.withOpacity(0.6) : theme.colorScheme.primary,
                          indicator: BoxDecoration(
                            color: isDark ? theme.colorScheme.surface.withOpacity(0.98) : Colors.white,
                            borderRadius: const BorderRadius.all(Radius.circular(8)),
                            boxShadow: [
                              if (isDark)
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.18),
                                  blurRadius: 8,
                                  offset: Offset(0, 2),
                                ),
                            ],
                          ),
                          tabs: const [
                            Tab(text: 'Old Testament (39 Books)'),
                            Tab(text: 'New Testament (27 Books)'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: const TabBarView(
                          children: [
                            BookList(testament: 'old'),
                            BookList(testament: 'new'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 