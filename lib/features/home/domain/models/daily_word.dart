class DailyWord {
  final String word;
  final String definition;
  final String example;
  final String pronunciation;
  final bool isSaved;

  const DailyWord({
    required this.word,
    required this.definition,
    required this.example,
    required this.pronunciation,
    this.isSaved = false,
  });
} 