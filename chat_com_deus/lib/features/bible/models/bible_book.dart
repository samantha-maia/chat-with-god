class BibleBook {
  final String name;
  final String abbreviation;
  final int chapters;
  final String testament; // 'old' or 'new'
  final List<int> completedChapters;
  final DateTime? lastRead;

  BibleBook({
    required this.name,
    required this.abbreviation,
    required this.chapters,
    required this.testament,
    this.completedChapters = const [],
    this.lastRead,
  });

  double get progressPercentage {
    if (chapters == 0) return 0.0;
    return (completedChapters.length / chapters) * 100;
  }

  bool isChapterCompleted(int chapter) {
    return completedChapters.contains(chapter);
  }

  BibleBook copyWith({
    String? name,
    String? abbreviation,
    int? chapters,
    String? testament,
    List<int>? completedChapters,
    DateTime? lastRead,
  }) {
    return BibleBook(
      name: name ?? this.name,
      abbreviation: abbreviation ?? this.abbreviation,
      chapters: chapters ?? this.chapters,
      testament: testament ?? this.testament,
      completedChapters: completedChapters ?? this.completedChapters,
      lastRead: lastRead ?? this.lastRead,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'abbreviation': abbreviation,
      'chapters': chapters,
      'testament': testament,
      'completedChapters': completedChapters,
      'lastRead': lastRead?.toIso8601String(),
    };
  }

  factory BibleBook.fromJson(Map<String, dynamic> json) {
    return BibleBook(
      name: json['name'],
      abbreviation: json['abbreviation'],
      chapters: json['chapters'],
      testament: json['testament'],
      completedChapters: List<int>.from(json['completedChapters'] ?? []),
      lastRead: json['lastRead'] != null 
          ? DateTime.parse(json['lastRead']) 
          : null,
    );
  }
} 