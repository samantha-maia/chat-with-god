import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_theme.dart';
import '../models/bible_book.dart';
import '../providers/bible_reading_provider.dart';
import 'book_chapters_dialog.dart';

class BookList extends ConsumerWidget {
  final String testament;

  const BookList({super.key, required this.testament});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final booksAsync = testament == 'old' 
        ? ref.watch(oldTestamentProvider)
        : ref.watch(newTestamentProvider);

    return booksAsync.when(
      data: (books) => ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          final book = books[index];
          return _BookListItem(book: book);
        },
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text('Error loading books: $error'),
      ),
    );
  }
}

class _BookListItem extends ConsumerWidget {
  final BibleBook book;

  const _BookListItem({required this.book});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the Bible reading state to get updated book data
    final booksAsync = ref.watch(bibleReadingProvider);
    
    final updatedBook = booksAsync.when(
      data: (books) => books.firstWhere(
        (b) => b.name == book.name,
        orElse: () => book,
      ),
      loading: () => book,
      error: (_, __) => book,
    );

    final completedChapters = updatedBook.completedChapters.length;
    final totalChapters = updatedBook.chapters;
    final progress = updatedBook.progressPercentage;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => BookChaptersDialog(book: updatedBook),
          );
        },
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              // Book icon with progress indicator
              Stack(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Icon(
                      Icons.book,
                      color: AppTheme.primaryColor,
                      size: 24,
                    ),
                  ),
                  // Status indicator for all books
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: _getStatusColor(progress),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        _getStatusIcon(progress),
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              
              // Book details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      updatedBook.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$completedChapters of $totalChapters chapters',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LinearProgressIndicator(
                            value: progress / 100,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(
                              progress == 100 
                                  ? AppTheme.successColor 
                                  : AppTheme.primaryColor,
                            ),
                            minHeight: 4,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${progress.toStringAsFixed(0)}%',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: progress == 100 
                                ? AppTheme.successColor 
                                : AppTheme.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Arrow indicator
              Icon(
                Icons.chevron_right,
                color: Colors.grey[400],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getStatusColor(double progress) {
    if (progress == 0) {
      return Colors.grey[400]!; // Not started - grey
    } else if (progress < 100) {
      return AppTheme.primaryColor; // In progress - primary color
    } else {
      return AppTheme.successColor; // Completed - green
    }
  }

  IconData _getStatusIcon(double progress) {
    if (progress == 0) {
      return Icons.radio_button_unchecked; // Not started - empty circle
    } else if (progress < 100) {
      return Icons.play_arrow; // In progress - play arrow
    } else {
      return Icons.check; // Completed - checkmark
    }
  }
} 