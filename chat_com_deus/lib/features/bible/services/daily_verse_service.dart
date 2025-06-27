import 'package:supabase_flutter/supabase_flutter.dart';

class DailyVerse {
  final String verse;
  final String reference;
  final String translation;
  final String? explanation;
  final DateTime date;

  DailyVerse({
    required this.verse,
    required this.reference,
    required this.translation,
    this.explanation,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    return {
      'verse': verse,
      'reference': reference,
      'translation': translation,
      'explanation': explanation,
      'date': date.toIso8601String(),
    };
  }

  factory DailyVerse.fromJson(Map<String, dynamic> json) {
    return DailyVerse(
      verse: json['verse'],
      reference: json['reference'],
      translation: json['translation'],
      explanation: json['explanation'],
      date: DateTime.parse(json['date']),
    );
  }
}

class DailyVerseService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  // Curated list of meaningful daily verses
  static final List<Map<String, dynamic>> _dailyVerses = [
    {
      'verse': 'For I know the plans I have for you," declares the LORD, "plans to prosper you and not to harm you, plans to give you hope and a future.',
      'reference': 'Jeremiah 29:11',
      'translation': 'NIV',
      'explanation': 'A reminder of God\'s loving plans for our lives.',
    },
    {
      'verse': 'I can do all this through him who gives me strength.',
      'reference': 'Philippians 4:13',
      'translation': 'NIV',
      'explanation': 'Finding strength and capability through Christ.',
    },
    {
      'verse': 'Trust in the LORD with all your heart and lean not on your own understanding; in all your ways submit to him, and he will make your paths straight.',
      'reference': 'Proverbs 3:5-6',
      'translation': 'NIV',
      'explanation': 'The importance of trusting God completely.',
    },
    {
      'verse': 'Be strong and courageous. Do not be afraid; do not be discouraged, for the LORD your God will be with you wherever you go.',
      'reference': 'Joshua 1:9',
      'translation': 'NIV',
      'explanation': 'God\'s promise to be with us always.',
    },
    {
      'verse': 'Come to me, all you who are weary and burdened, and I will give you rest.',
      'reference': 'Matthew 11:28',
      'translation': 'NIV',
      'explanation': 'Jesus\' invitation to find rest in Him.',
    },
    {
      'verse': 'The LORD is my shepherd, I lack nothing.',
      'reference': 'Psalm 23:1',
      'translation': 'NIV',
      'explanation': 'God\'s provision and care for His children.',
    },
    {
      'verse': 'But those who hope in the LORD will renew their strength. They will soar on wings like eagles; they will run and not grow weary, they will walk and not be faint.',
      'reference': 'Isaiah 40:31',
      'translation': 'NIV',
      'explanation': 'Finding renewed strength through hope in God.',
    },
    {
      'verse': 'And we know that in all things God works for the good of those who love him, who have been called according to his purpose.',
      'reference': 'Romans 8:28',
      'translation': 'NIV',
      'explanation': 'God\'s promise to work all things for good.',
    },
    {
      'verse': 'Do not be anxious about anything, but in every situation, by prayer and petition, with thanksgiving, present your requests to God.',
      'reference': 'Philippians 4:6',
      'translation': 'NIV',
      'explanation': 'The antidote to anxiety: prayer and thanksgiving.',
    },
    {
      'verse': 'For God so loved the world that he gave his one and only Son, that whoever believes in him shall not perish but have eternal life.',
      'reference': 'John 3:16',
      'translation': 'NIV',
      'explanation': 'The greatest expression of God\'s love.',
    },
    {
      'verse': 'Love is patient, love is kind. It does not envy, it does not boast, it is not proud.',
      'reference': '1 Corinthians 13:4',
      'translation': 'NIV',
      'explanation': 'The characteristics of true love.',
    },
    {
      'verse': 'But the fruit of the Spirit is love, joy, peace, forbearance, kindness, goodness, faithfulness, gentleness and self-control.',
      'reference': 'Galatians 5:22-23',
      'translation': 'NIV',
      'explanation': 'The qualities that grow in us through the Holy Spirit.',
    },
    {
      'verse': 'Rejoice always, pray continually, give thanks in all circumstances; for this is God\'s will for you in Christ Jesus.',
      'reference': '1 Thessalonians 5:16-18',
      'translation': 'NIV',
      'explanation': 'God\'s will for our daily attitude and actions.',
    },
    {
      'verse': 'The LORD is close to the brokenhearted and saves those who are crushed in spirit.',
      'reference': 'Psalm 34:18',
      'translation': 'NIV',
      'explanation': 'God\'s comfort for those who are hurting.',
    },
    {
      'verse': 'Cast your cares on the LORD and he will sustain you; he will never let the righteous be shaken.',
      'reference': 'Psalm 55:22',
      'translation': 'NIV',
      'explanation': 'God\'s promise to sustain us when we trust Him.',
    },
  ];

  static DailyVerse getTodaysVerse() {
    final today = DateTime.now();
    final dayOfYear = today.difference(DateTime(today.year, 1, 1)).inDays;
    final verseIndex = dayOfYear % _dailyVerses.length;
    final verseData = _dailyVerses[verseIndex];

    return DailyVerse(
      verse: verseData['verse'],
      reference: verseData['reference'],
      translation: verseData['translation'],
      explanation: verseData['explanation'],
      date: DateTime(today.year, today.month, today.day),
    );
  }

  static Future<DailyVerse> getTodaysVerseFromDatabase() async {
    try {
      final today = DateTime.now();
      final todayString = DateTime(today.year, today.month, today.day).toIso8601String();

      final response = await _supabase
          .from('daily_verses')
          .select()
          .eq('date', todayString)
          .maybeSingle();

      if (response != null) {
        return DailyVerse.fromJson(response);
      }
    } catch (e) {
      print('Error fetching daily verse from database: $e');
      // Fall back to local verse - this is expected since we don't have a daily_verses table
    }

    // Always fall back to local verse
    return getTodaysVerse();
  }

  static String getVersePrompt(DailyVerse verse) {
    return '''I just read today's verse: "${verse.verse}" (${verse.reference})

Can you help me understand this verse better? What does it mean for my life today? How can I apply this truth in my daily walk with God? Please provide spiritual guidance and practical insights about this verse.''';
  }
} 