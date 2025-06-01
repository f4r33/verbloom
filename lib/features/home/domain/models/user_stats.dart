class UserStats {
  final String userId;
  final String username;
  final String? avatarUrl;
  final int xp;
  final int streak;
  final int weeklyChallengeProgress;
  final int weeklyChallengeGoal;

  const UserStats({
    required this.userId,
    required this.username,
    this.avatarUrl,
    this.xp = 0,
    this.streak = 0,
    this.weeklyChallengeProgress = 0,
    this.weeklyChallengeGoal = 7,
  });

  double get weeklyChallengePercentage => 
    weeklyChallengeProgress / weeklyChallengeGoal;
} 