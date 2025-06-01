class LeaderboardEntry {
  final String userId;
  final String username;
  final String? avatarUrl;
  final int xp;
  final int rank;

  const LeaderboardEntry({
    required this.userId,
    required this.username,
    this.avatarUrl,
    required this.xp,
    required this.rank,
  });
} 