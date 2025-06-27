import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/daily_verse_service.dart';

final dailyVerseProvider = FutureProvider<DailyVerse>((ref) async {
  return await DailyVerseService.getTodaysVerseFromDatabase();
});

final dailyVersePromptProvider = Provider<String>((ref) {
  final verseAsync = ref.watch(dailyVerseProvider);
  return verseAsync.when(
    data: (verse) => DailyVerseService.getVersePrompt(verse),
    loading: () => 'Loading today\'s verse...',
    error: (_, __) => 'Error loading today\'s verse.',
  );
});

// Loading state for verse chat
final verseChatLoadingProvider = StateProvider<bool>((ref) => false); 