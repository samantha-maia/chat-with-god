import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/bible_book.dart';
import '../services/bible_reading_service.dart';
import '../../../shared/providers/auth_provider.dart';

class BibleReadingNotifier extends StateNotifier<AsyncValue<List<BibleBook>>> {
  final Ref ref;

  BibleReadingNotifier(this.ref) : super(const AsyncValue.loading()) {
    _loadReadingProgress();
  }

  Future<void> _loadReadingProgress() async {
    try {
      state = const AsyncValue.loading();
      final user = ref.read(authNotifierProvider);
      if (user == null) {
        state = AsyncValue.data(BibleReadingService.allBooks);
        return;
      }

      final books = await BibleReadingService.getUserReadingProgress(user.id);
      state = AsyncValue.data(books);
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }

  Future<void> markChapterAsRead(String bookName, int chapter) async {
    try {
      final user = ref.read(authNotifierProvider);
      if (user == null) return;

      await BibleReadingService.markChapterAsRead(
        userId: user.id,
        bookName: bookName,
        chapter: chapter,
      );

      // Reload progress and update state
      await _loadReadingProgress();
    } catch (e) {
      print('Error marking chapter as read: $e');
      rethrow;
    }
  }

  Future<void> markChapterAsUnread(String bookName, int chapter) async {
    try {
      final user = ref.read(authNotifierProvider);
      if (user == null) return;

      await BibleReadingService.markChapterAsUnread(
        userId: user.id,
        bookName: bookName,
        chapter: chapter,
      );

      // Reload progress and update state
      await _loadReadingProgress();
    } catch (e) {
      print('Error marking chapter as unread: $e');
      rethrow;
    }
  }

  Future<void> markAllChaptersAsRead(String bookName) async {
    try {
      final user = ref.read(authNotifierProvider);
      if (user == null) return;

      await BibleReadingService.markAllChaptersAsRead(
        userId: user.id,
        bookName: bookName,
      );

      // Reload progress and update state
      await _loadReadingProgress();
    } catch (e) {
      print('Error marking all chapters as read: $e');
      rethrow;
    }
  }

  Future<void> markAllChaptersAsUnread(String bookName) async {
    try {
      final user = ref.read(authNotifierProvider);
      if (user == null) return;

      await BibleReadingService.markAllChaptersAsUnread(
        userId: user.id,
        bookName: bookName,
      );

      // Reload progress and update state
      await _loadReadingProgress();
    } catch (e) {
      print('Error marking all chapters as unread: $e');
      rethrow;
    }
  }

  Future<void> refresh() async {
    await _loadReadingProgress();
  }
}

final bibleReadingProvider = StateNotifierProvider<BibleReadingNotifier, AsyncValue<List<BibleBook>>>(
  (ref) => BibleReadingNotifier(ref),
);

// Derived providers
final oldTestamentProvider = Provider<AsyncValue<List<BibleBook>>>((ref) {
  final booksAsync = ref.watch(bibleReadingProvider);
  return booksAsync.when(
    data: (books) => AsyncValue.data(
      books.where((book) => book.testament == 'old').toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

final newTestamentProvider = Provider<AsyncValue<List<BibleBook>>>((ref) {
  final booksAsync = ref.watch(bibleReadingProvider);
  return booksAsync.when(
    data: (books) => AsyncValue.data(
      books.where((book) => book.testament == 'new').toList(),
    ),
    loading: () => const AsyncValue.loading(),
    error: (error, stack) => AsyncValue.error(error, stack),
  );
});

final overallProgressProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final user = ref.read(authNotifierProvider);
  if (user == null) {
    return {
      'totalChapters': BibleReadingService.totalChapters,
      'completedChapters': 0,
      'percentage': 0.0,
      'completedBooks': 0,
      'totalBooks': BibleReadingService.totalBooks,
    };
  }

  return await BibleReadingService.getOverallProgress(user.id);
});

final todaysReadingProvider = Provider<Map<String, dynamic>?>((ref) {
  final booksAsync = ref.watch(bibleReadingProvider);
  return booksAsync.when(
    data: (books) => BibleReadingService.getTodaysReading(books),
    loading: () => null,
    error: (_, __) => null,
  );
}); 