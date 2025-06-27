import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/bible_book.dart';
import '../../../core/constants/supabase_config.dart';

class BibleReadingService {
  static final SupabaseClient _supabase = Supabase.instance.client;
  
  // Complete Bible structure with all books and chapters
  static final List<BibleBook> _bibleBooks = [
    // Old Testament (39 books)
    BibleBook(name: 'Genesis', abbreviation: 'Gen', chapters: 50, testament: 'old'),
    BibleBook(name: 'Exodus', abbreviation: 'Exo', chapters: 40, testament: 'old'),
    BibleBook(name: 'Leviticus', abbreviation: 'Lev', chapters: 27, testament: 'old'),
    BibleBook(name: 'Numbers', abbreviation: 'Num', chapters: 36, testament: 'old'),
    BibleBook(name: 'Deuteronomy', abbreviation: 'Deu', chapters: 34, testament: 'old'),
    BibleBook(name: 'Joshua', abbreviation: 'Jos', chapters: 24, testament: 'old'),
    BibleBook(name: 'Judges', abbreviation: 'Jdg', chapters: 21, testament: 'old'),
    BibleBook(name: 'Ruth', abbreviation: 'Rut', chapters: 4, testament: 'old'),
    BibleBook(name: '1 Samuel', abbreviation: '1Sa', chapters: 31, testament: 'old'),
    BibleBook(name: '2 Samuel', abbreviation: '2Sa', chapters: 24, testament: 'old'),
    BibleBook(name: '1 Kings', abbreviation: '1Ki', chapters: 22, testament: 'old'),
    BibleBook(name: '2 Kings', abbreviation: '2Ki', chapters: 25, testament: 'old'),
    BibleBook(name: '1 Chronicles', abbreviation: '1Ch', chapters: 29, testament: 'old'),
    BibleBook(name: '2 Chronicles', abbreviation: '2Ch', chapters: 36, testament: 'old'),
    BibleBook(name: 'Ezra', abbreviation: 'Ezr', chapters: 10, testament: 'old'),
    BibleBook(name: 'Nehemiah', abbreviation: 'Neh', chapters: 13, testament: 'old'),
    BibleBook(name: 'Esther', abbreviation: 'Est', chapters: 10, testament: 'old'),
    BibleBook(name: 'Job', abbreviation: 'Job', chapters: 42, testament: 'old'),
    BibleBook(name: 'Psalms', abbreviation: 'Psa', chapters: 150, testament: 'old'),
    BibleBook(name: 'Proverbs', abbreviation: 'Pro', chapters: 31, testament: 'old'),
    BibleBook(name: 'Ecclesiastes', abbreviation: 'Ecc', chapters: 12, testament: 'old'),
    BibleBook(name: 'Song of Solomon', abbreviation: 'Sng', chapters: 8, testament: 'old'),
    BibleBook(name: 'Isaiah', abbreviation: 'Isa', chapters: 66, testament: 'old'),
    BibleBook(name: 'Jeremiah', abbreviation: 'Jer', chapters: 52, testament: 'old'),
    BibleBook(name: 'Lamentations', abbreviation: 'Lam', chapters: 5, testament: 'old'),
    BibleBook(name: 'Ezekiel', abbreviation: 'Ezk', chapters: 48, testament: 'old'),
    BibleBook(name: 'Daniel', abbreviation: 'Dan', chapters: 12, testament: 'old'),
    BibleBook(name: 'Hosea', abbreviation: 'Hos', chapters: 14, testament: 'old'),
    BibleBook(name: 'Joel', abbreviation: 'Jol', chapters: 3, testament: 'old'),
    BibleBook(name: 'Amos', abbreviation: 'Amo', chapters: 9, testament: 'old'),
    BibleBook(name: 'Obadiah', abbreviation: 'Oba', chapters: 1, testament: 'old'),
    BibleBook(name: 'Jonah', abbreviation: 'Jon', chapters: 4, testament: 'old'),
    BibleBook(name: 'Micah', abbreviation: 'Mic', chapters: 7, testament: 'old'),
    BibleBook(name: 'Nahum', abbreviation: 'Nah', chapters: 3, testament: 'old'),
    BibleBook(name: 'Habakkuk', abbreviation: 'Hab', chapters: 3, testament: 'old'),
    BibleBook(name: 'Zephaniah', abbreviation: 'Zep', chapters: 3, testament: 'old'),
    BibleBook(name: 'Haggai', abbreviation: 'Hag', chapters: 2, testament: 'old'),
    BibleBook(name: 'Zechariah', abbreviation: 'Zec', chapters: 14, testament: 'old'),
    BibleBook(name: 'Malachi', abbreviation: 'Mal', chapters: 4, testament: 'old'),
    
    // New Testament (27 books)
    BibleBook(name: 'Matthew', abbreviation: 'Mat', chapters: 28, testament: 'new'),
    BibleBook(name: 'Mark', abbreviation: 'Mrk', chapters: 16, testament: 'new'),
    BibleBook(name: 'Luke', abbreviation: 'Luk', chapters: 24, testament: 'new'),
    BibleBook(name: 'John', abbreviation: 'Jhn', chapters: 21, testament: 'new'),
    BibleBook(name: 'Acts', abbreviation: 'Act', chapters: 28, testament: 'new'),
    BibleBook(name: 'Romans', abbreviation: 'Rom', chapters: 16, testament: 'new'),
    BibleBook(name: '1 Corinthians', abbreviation: '1Co', chapters: 16, testament: 'new'),
    BibleBook(name: '2 Corinthians', abbreviation: '2Co', chapters: 13, testament: 'new'),
    BibleBook(name: 'Galatians', abbreviation: 'Gal', chapters: 6, testament: 'new'),
    BibleBook(name: 'Ephesians', abbreviation: 'Eph', chapters: 6, testament: 'new'),
    BibleBook(name: 'Philippians', abbreviation: 'Php', chapters: 4, testament: 'new'),
    BibleBook(name: 'Colossians', abbreviation: 'Col', chapters: 4, testament: 'new'),
    BibleBook(name: '1 Thessalonians', abbreviation: '1Th', chapters: 5, testament: 'new'),
    BibleBook(name: '2 Thessalonians', abbreviation: '2Th', chapters: 3, testament: 'new'),
    BibleBook(name: '1 Timothy', abbreviation: '1Ti', chapters: 6, testament: 'new'),
    BibleBook(name: '2 Timothy', abbreviation: '2Ti', chapters: 4, testament: 'new'),
    BibleBook(name: 'Titus', abbreviation: 'Tit', chapters: 3, testament: 'new'),
    BibleBook(name: 'Philemon', abbreviation: 'Phm', chapters: 1, testament: 'new'),
    BibleBook(name: 'Hebrews', abbreviation: 'Heb', chapters: 13, testament: 'new'),
    BibleBook(name: 'James', abbreviation: 'Jas', chapters: 5, testament: 'new'),
    BibleBook(name: '1 Peter', abbreviation: '1Pe', chapters: 5, testament: 'new'),
    BibleBook(name: '2 Peter', abbreviation: '2Pe', chapters: 3, testament: 'new'),
    BibleBook(name: '1 John', abbreviation: '1Jn', chapters: 5, testament: 'new'),
    BibleBook(name: '2 John', abbreviation: '2Jn', chapters: 1, testament: 'new'),
    BibleBook(name: '3 John', abbreviation: '3Jn', chapters: 1, testament: 'new'),
    BibleBook(name: 'Jude', abbreviation: 'Jud', chapters: 1, testament: 'new'),
    BibleBook(name: 'Revelation', abbreviation: 'Rev', chapters: 22, testament: 'new'),
  ];

  static List<BibleBook> get allBooks => _bibleBooks;
  
  static List<BibleBook> get oldTestament => 
      _bibleBooks.where((book) => book.testament == 'old').toList();
  
  static List<BibleBook> get newTestament => 
      _bibleBooks.where((book) => book.testament == 'new').toList();

  static Future<List<BibleBook>> getUserReadingProgress(String userId) async {
    try {
      print('Fetching reading progress for user: $userId');
      
      final response = await _supabase
          .from(SupabaseConfig.bibleReadingProgressTable)
          .select()
          .eq('user_id', userId);

      print('Response received: ${response?.length ?? 0} records');

      if (response == null) return _bibleBooks;

      final progressMap = <String, Map<String, dynamic>>{};
      for (final record in response) {
        progressMap[record['book_name']] = record;
      }

      return _bibleBooks.map((book) {
        final progress = progressMap[book.name];
        if (progress != null) {
          return book.copyWith(
            completedChapters: List<int>.from(progress['completed_chapters'] ?? []),
            lastRead: progress['last_read'] != null 
                ? DateTime.parse(progress['last_read']) 
                : null,
          );
        }
        return book;
      }).toList();
    } catch (e) {
      print('Error loading reading progress: $e');
      print('Error type: ${e.runtimeType}');
      print('Error details: ${e.toString()}');
      
      // If table doesn't exist, return books without progress
      if (e.toString().contains('relation') && e.toString().contains('does not exist')) {
        print('Bible reading progress table not found. Please run the SQL script to create it.');
        return _bibleBooks;
      }
      
      // If it's a 406 error, the table might not exist or RLS might be blocking
      if (e.toString().contains('406')) {
        print('406 error - table might not exist or RLS policies might be blocking access.');
        print('Please ensure the bible_reading_progress table exists and RLS policies are set up correctly.');
        return _bibleBooks;
      }
      
      return _bibleBooks;
    }
  }

  static Future<void> markChapterAsRead({
    required String userId,
    required String bookName,
    required int chapter,
  }) async {
    try {
      // Get current progress
      final response = await _supabase
          .from(SupabaseConfig.bibleReadingProgressTable)
          .select()
          .eq('user_id', userId)
          .eq('book_name', bookName)
          .maybeSingle();

      List<int> completedChapters = [];
      if (response != null) {
        completedChapters = List<int>.from(response['completed_chapters'] ?? []);
      }

      // Add chapter if not already completed
      if (!completedChapters.contains(chapter)) {
        completedChapters.add(chapter);
        completedChapters.sort(); // Keep chapters in order
      }

      // Use upsert with onConflict to handle existing records
      await _supabase
          .from(SupabaseConfig.bibleReadingProgressTable)
          .upsert({
            'user_id': userId,
            'book_name': bookName,
            'completed_chapters': completedChapters,
            'last_read': DateTime.now().toIso8601String(),
          }, onConflict: 'user_id,book_name');
    } catch (e) {
      print('Error marking chapter as read: $e');
      if (e.toString().contains('relation') && e.toString().contains('does not exist')) {
        throw Exception('Bible reading progress table not found. Please run the SQL script to create it.');
      }
      rethrow;
    }
  }

  static Future<void> markChapterAsUnread({
    required String userId,
    required String bookName,
    required int chapter,
  }) async {
    try {
      final response = await _supabase
          .from(SupabaseConfig.bibleReadingProgressTable)
          .select()
          .eq('user_id', userId)
          .eq('book_name', bookName)
          .maybeSingle();

      if (response != null) {
        List<int> completedChapters = List<int>.from(response['completed_chapters'] ?? []);
        completedChapters.remove(chapter);

        await _supabase
            .from(SupabaseConfig.bibleReadingProgressTable)
            .update({
              'completed_chapters': completedChapters,
              'last_read': DateTime.now().toIso8601String(),
            })
            .eq('user_id', userId)
            .eq('book_name', bookName);
      }
    } catch (e) {
      print('Error marking chapter as unread: $e');
      rethrow;
    }
  }

  static Future<void> markAllChaptersAsRead({
    required String userId,
    required String bookName,
  }) async {
    try {
      final book = getBookByName(bookName);
      if (book == null) return;

      // Create array of all chapter numbers
      final allChapters = List.generate(book.chapters, (index) => index + 1);

      // Upsert with all chapters marked as read
      await _supabase
          .from(SupabaseConfig.bibleReadingProgressTable)
          .upsert({
            'user_id': userId,
            'book_name': bookName,
            'completed_chapters': allChapters,
            'last_read': DateTime.now().toIso8601String(),
          }, onConflict: 'user_id,book_name');
    } catch (e) {
      print('Error marking all chapters as read: $e');
      rethrow;
    }
  }

  static Future<void> markAllChaptersAsUnread({
    required String userId,
    required String bookName,
  }) async {
    try {
      // First check if record exists
      final existingRecord = await _supabase
          .from(SupabaseConfig.bibleReadingProgressTable)
          .select()
          .eq('user_id', userId)
          .eq('book_name', bookName)
          .maybeSingle();

      if (existingRecord != null) {
        // Update existing record
        await _supabase
            .from(SupabaseConfig.bibleReadingProgressTable)
            .update({
              'completed_chapters': [],
              'last_read': DateTime.now().toIso8601String(),
            })
            .eq('user_id', userId)
            .eq('book_name', bookName);
      } else {
        // Insert new record with empty chapters
        await _supabase
            .from(SupabaseConfig.bibleReadingProgressTable)
            .insert({
              'user_id': userId,
              'book_name': bookName,
              'completed_chapters': [],
              'last_read': DateTime.now().toIso8601String(),
            });
      }
    } catch (e) {
      print('Error marking all chapters as unread: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>> getOverallProgress(String userId) async {
    try {
      final books = await getUserReadingProgress(userId);
      
      int totalChapters = 0;
      int completedChapters = 0;
      
      for (final book in books) {
        totalChapters += book.chapters;
        completedChapters += book.completedChapters.length;
      }

      return {
        'totalChapters': totalChapters,
        'completedChapters': completedChapters,
        'percentage': totalChapters > 0 ? (completedChapters / totalChapters) * 100 : 0.0,
        'completedBooks': books.where((book) => book.completedChapters.length == book.chapters).length,
        'totalBooks': books.length,
      };
    } catch (e) {
      print('Error getting overall progress: $e');
      return {
        'totalChapters': 0,
        'completedChapters': 0,
        'percentage': 0.0,
        'completedBooks': 0,
        'totalBooks': _bibleBooks.length,
      };
    }
  }

  static BibleBook? getBookByName(String name) {
    try {
      return _bibleBooks.firstWhere((book) => book.name == name);
    } catch (e) {
      return null;
    }
  }

  static BibleBook? getBookByAbbreviation(String abbreviation) {
    try {
      return _bibleBooks.firstWhere((book) => book.abbreviation == abbreviation);
    } catch (e) {
      return null;
    }
  }

  static int get totalChapters {
    return _bibleBooks.fold(0, (sum, book) => sum + book.chapters);
  }

  static int get totalBooks => _bibleBooks.length;

  // Get next recommended reading
  static BibleBook? getNextRecommendedBook(List<BibleBook> userBooks) {
    for (var book in _bibleBooks) {
      final userBook = userBooks.firstWhere(
        (ub) => ub.name == book.name,
        orElse: () => book,
      );
      
      if (userBook.completedChapters.length < book.chapters) {
        return userBook;
      }
    }
    return null;
  }

  // Get today's reading suggestion (simple sequential)
  static Map<String, dynamic>? getTodaysReading(List<BibleBook> userBooks) {
    final nextBook = getNextRecommendedBook(userBooks);
    if (nextBook == null) return null;

    final nextChapter = nextBook.completedChapters.isEmpty 
        ? 1 
        : nextBook.completedChapters.last + 1;

    return {
      'book': nextBook,
      'chapter': nextChapter,
      'testament': nextBook.testament,
    };
  }
} 