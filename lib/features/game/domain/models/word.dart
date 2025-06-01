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
  final String languageCode;
  final Map<String, String> translations; // Map of language code to translation
  final List<String> tags; // For categorization (e.g., 'business', 'travel', 'food')

  Word({
    required this.id,
    required this.word,
    required this.definition,
    required this.example,
    required this.pronunciation,
    required this.languageCode,
    this.synonyms = const [],
    this.antonyms = const [],
    this.difficulty = 'medium',
    this.isSaved = false,
    this.translations = const {},
    this.tags = const [],
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
    String? languageCode,
    Map<String, String>? translations,
    List<String>? tags,
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
      languageCode: languageCode ?? this.languageCode,
      translations: translations ?? this.translations,
      tags: tags ?? this.tags,
      lastReviewed: lastReviewed ?? this.lastReviewed,
    );
  }
} 