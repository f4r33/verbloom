class Language {
  final String id;
  final String name;
  final String code; // ISO 639-1 language code (e.g., 'en', 'es', 'fr')
  final String flag; // Emoji flag or URL to flag image
  final bool isActive;

  const Language({
    required this.id,
    required this.name,
    required this.code,
    required this.flag,
    this.isActive = true,
  });

  Language copyWith({
    String? id,
    String? name,
    String? code,
    String? flag,
    bool? isActive,
  }) {
    return Language(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      flag: flag ?? this.flag,
      isActive: isActive ?? this.isActive,
    );
  }
} 