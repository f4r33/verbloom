class LeaderboardEntry {
  final String userId;
  final String username;
  final String? avatarUrl;
  final int xp;
  final int rank;
  final int streak;
  final int totalWordsLearned;

  const LeaderboardEntry({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.xp,
    required this.rank,
    this.streak = 0,
    this.totalWordsLearned = 0,
  });

  LeaderboardEntry copyWith({
    String? userId,
    String? username,
    String? avatarUrl,
    int? xp,
    int? rank,
    int? streak,
    int? totalWordsLearned,
  }) {
    return LeaderboardEntry(
      userId: userId ?? this.userId,
      username: username ?? this.username,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      rank: rank ?? this.rank,
      streak: streak ?? this.streak,
      totalWordsLearned: totalWordsLearned ?? this.totalWordsLearned,
    );
  }
} 