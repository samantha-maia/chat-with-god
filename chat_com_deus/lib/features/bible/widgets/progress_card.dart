import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

class ProgressCard extends StatelessWidget {
  final Map<String, dynamic>? progress;

  const ProgressCard({super.key, this.progress});

  @override
  Widget build(BuildContext context) {
    if (progress == null) {
      return Card(
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    }

    final totalChapters = progress!['totalChapters'] as int;
    final completedChapters = progress!['completedChapters'] as int;
    final percentage = progress!['percentage'] as double;
    final completedBooks = progress!['completedBooks'] as int;
    final totalBooks = progress!['totalBooks'] as int;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.book,
                  color: AppTheme.primaryColor,
                  size: 24,
                ),
                const SizedBox(width: 8),
                const Text(
                  'Overall Progress',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _ProgressItem(
                    label: 'Chapters',
                    value: '$completedChapters/$totalChapters',
                    percentage: percentage,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ProgressItem(
                    label: 'Books',
                    value: '$completedBooks/$totalBooks',
                    percentage: (completedBooks / totalBooks) * 100,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: percentage / 100,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
              minHeight: 8,
            ),
            const SizedBox(height: 8),
            Text(
              '${percentage.toStringAsFixed(1)}% Complete',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProgressItem extends StatelessWidget {
  final String label;
  final String value;
  final double percentage;

  const _ProgressItem({
    required this.label,
    required this.value,
    required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${percentage.toStringAsFixed(1)}%',
          style: TextStyle(
            color: AppTheme.primaryColor,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
} 