import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../models/bible_book.dart';
import '../providers/bible_reading_provider.dart';

class BookChaptersDialog extends ConsumerWidget {
  final BibleBook book;

  const BookChaptersDialog({super.key, required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the Bible reading state to refresh when it changes
    final booksAsync = ref.watch(bibleReadingProvider);
    
    // Get the updated book data from the current state
    final updatedBook = booksAsync.when(
      data: (books) => books.firstWhere(
        (b) => b.name == book.name,
        orElse: () => book,
      ),
      loading: () => book,
      error: (_, __) => book,
    );

    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.book,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    updatedBook.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            
            const SizedBox(height: 8),
            
            // Progress info
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: updatedBook.testament == 'old' 
                        ? Colors.orange.withValues(alpha: 0.2)
                        : Colors.green.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    updatedBook.testament == 'old' ? 'Old Testament' : 'New Testament',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                      color: updatedBook.testament == 'old' ? Colors.orange[700] : Colors.green[700],
                    ),
                  ),
                ),
                const Spacer(),
                Text(
                  '${updatedBook.completedChapters.length}/${updatedBook.chapters} chapters completed',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            // Progress bar
            LinearProgressIndicator(
              value: updatedBook.progressPercentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(
                updatedBook.progressPercentage == 100 
                    ? AppTheme.successColor 
                    : AppTheme.primaryColor,
              ),
              minHeight: 6,
            ),
            
            const SizedBox(height: 20),
            
            // Chapters grid
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: 1.2,
                ),
                itemCount: updatedBook.chapters,
                itemBuilder: (context, index) {
                  final chapterNumber = index + 1;
                  final isCompleted = updatedBook.isChapterCompleted(chapterNumber);
                  
                  return _ChapterCard(
                    chapterNumber: chapterNumber,
                    isCompleted: isCompleted,
                    onTap: () => _toggleChapter(ref, chapterNumber),
                  );
                },
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _markAllAsRead(ref),
                    child: const Text('Mark All as Read'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _markAllAsUnread(ref),
                    child: const Text('Mark All as Unread'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _toggleChapter(WidgetRef ref, int chapterNumber) {
    final isCompleted = book.isChapterCompleted(chapterNumber);
    
    if (isCompleted) {
      ref.read(bibleReadingProvider.notifier).markChapterAsUnread(
        book.name,
        chapterNumber,
      );
    } else {
      ref.read(bibleReadingProvider.notifier).markChapterAsRead(
        book.name,
        chapterNumber,
      );
    }
  }

  void _markAllAsRead(WidgetRef ref) {
    ref.read(bibleReadingProvider.notifier).markAllChaptersAsRead(book.name);
  }

  void _markAllAsUnread(WidgetRef ref) {
    ref.read(bibleReadingProvider.notifier).markAllChaptersAsUnread(book.name);
  }
}

class _ChapterCard extends StatelessWidget {
  final int chapterNumber;
  final bool isCompleted;
  final VoidCallback onTap;

  const _ChapterCard({
    required this.chapterNumber,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted 
              ? AppTheme.successColor.withValues(alpha: 0.1)
              : Colors.grey[100],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isCompleted 
                ? AppTheme.successColor
                : Colors.grey[300]!,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (isCompleted)
              Icon(
                Icons.check_circle,
                color: AppTheme.successColor,
                size: 20,
              )
            else
              Icon(
                Icons.radio_button_unchecked,
                color: Colors.grey[400],
                size: 20,
              ),
            const SizedBox(height: 4),
            Text(
              chapterNumber.toString(),
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isCompleted 
                    ? AppTheme.successColor
                    : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 