import 'package:verbloom/features/rewards/domain/models/achievement.dart';

abstract class RewardsRepository {
  // Achievements
  Future<List<Achievement>> getAchievements(String userId);
  Future<void> updateAchievementProgress(String userId, String achievementId, int progress);
  Future<void> unlockAchievement(String userId, String achievementId);

  // User Stats
  Future<Map<String, dynamic>> getUserStats(String userId);
  Future<void> updateUserStats(String userId, Map<String, dynamic> stats);
} 