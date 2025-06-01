class ChallengeQuestion {
  final String id;
  final String question;
  final List<String> options;
  final String correctAnswer;
  final String? explanation;
  final int xpReward;

  const ChallengeQuestion({
    required this.id,
    required this.question,
    required this.options,
    required this.correctAnswer,
    this.explanation,
    this.xpReward = 10,
  });

  bool isCorrectAnswer(String answer) => answer == correctAnswer;

  ChallengeQuestion copyWith({
    String? id,
    String? question,
    List<String>? options,
    String? correctAnswer,
    String? explanation,
    int? xpReward,
  }) {
    return ChallengeQuestion(
      id: id ?? this.id,
      question: question ?? this.question,
      options: options ?? this.options,
      correctAnswer: correctAnswer ?? this.correctAnswer,
      explanation: explanation ?? this.explanation,
      xpReward: xpReward ?? this.xpReward,
    );
  }
} 