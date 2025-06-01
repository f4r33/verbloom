class GameStats {
  final int xp;
  final int streak;
  final int weeklyChallengeProgress;
  final int weeklyChallengeGoal;
  final int totalWordsLearned;
  final int totalChallengesCompleted;
  final DateTime lastActiveDate;

  const GameStats({
    this.xp = 0,
    this.streak = 0,
    this.weeklyChallengeProgress = 0,
    this.weeklyChallengeGoal = 7,
    this.totalWordsLearned = 0,
    this.totalChallengesCompleted = 0,
    DateTime? lastActiveDate,
  }) : lastActiveDate = lastActiveDate ?? DateTime.now();

  double get weeklyChallengePercentage => 
    weeklyChallengeProgress / weeklyChallengeGoal;

  GameStats copyWith({
    int? xp,
    int? streak,
    int? weeklyChallengeProgress,
    int? weeklyChallengeGoal,
    int? totalWordsLearned,
    int? totalChallengesCompleted,
    DateTime? lastActiveDate,
  }) {
    return GameStats(
      xp: xp ?? this.xp,
      streak: streak ?? this.streak,
      weeklyChallengeProgress: weeklyChallengeProgress ?? this.weeklyChallengeProgress,
      weeklyChallengeGoal: weeklyChallengeGoal ?? this.weeklyChallengeGoal,
      totalWordsLearned: totalWordsLearned ?? this.totalWordsLearned,
      totalChallengesCompleted: totalChallengesCompleted ?? this.totalChallengesCompleted,
      lastActiveDate: lastActiveDate ?? this.lastActiveDate,
    );
  }
} 