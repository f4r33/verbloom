class Word {
  final String id;
  final String word;
  final String definition;
  final String example;
  final String pronunciation;
  final List<String> synonyms;
  final List<String> antonyms;
  final String difficulty;
  final bool isSaved;
  final DateTime lastReviewed;

  const Word({
    required this.id,
    required this.word,
    required this.definition,
    required this.example,
    required this.pronunciation,
    this.synonyms = const [],
    this.antonyms = const [],
    this.difficulty = 'medium',
    this.isSaved = false,
    DateTime? lastReviewed,
  }) : lastReviewed = lastReviewed ?? DateTime.now();

  Word copyWith({
    String? id,
    String? word,
    String? definition,
    String? example,
    String? pronunciation,
    List<String>? synonyms,
    List<String>? antonyms,
    String? difficulty,
    bool? isSaved,
    DateTime? lastReviewed,
  }) {
    return Word(
      id: id ?? this.id,
      word: word ?? this.word,
      definition: definition ?? this.definition,
      example: example ?? this.example,
      pronunciation: pronunciation ?? this.pronunciation,
      synonyms: synonyms ?? this.synonyms,
      antonyms: antonyms ?? this.antonyms,
      difficulty: difficulty ?? this.difficulty,
      isSaved: isSaved ?? this.isSaved,
      lastReviewed: lastReviewed ?? this.lastReviewed,
    );
  }
} 