import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verbloom/features/rewards/domain/models/achievement.dart';
import 'package:verbloom/features/rewards/domain/repositories/rewards_repository.dart';

class FirestoreRewardsRepository implements RewardsRepository {
  final FirebaseFirestore _firestore;

  FirestoreRewardsRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Collection references
  CollectionReference get _usersCollection => _firestore.collection('users');
  CollectionReference get _achievementsCollection => _firestore.collection('achievements');

  // Achievements
  @override
  Future<List<Achievement>> getAchievements(String userId) async {
    try {
      final userAchievementsDoc = await _usersCollection.doc(userId).collection('achievements').get();
      final achievements = <Achievement>[];

      for (var doc in userAchievementsDoc.docs) {
        final achievementData = doc.data() as Map<String, dynamic>;
        achievements.add(Achievement.fromJson(achievementData));
      }

      return achievements;
    } catch (e) {
      throw Exception('Failed to get achievements: $e');
    }
  }

  @override
  Future<void> updateAchievementProgress(String userId, String achievementId, int progress) async {
    try {
      await _usersCollection
          .doc(userId)
          .collection('achievements')
          .doc(achievementId)
          .update({'progress': progress});
    } catch (e) {
      throw Exception('Failed to update achievement progress: $e');
    }
  }

  @override
  Future<void> unlockAchievement(String userId, String achievementId) async {
    try {
      await _usersCollection
          .doc(userId)
          .collection('achievements')
          .doc(achievementId)
          .update({
        'isUnlocked': true,
        'unlockedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw Exception('Failed to unlock achievement: $e');
    }
  }

  // User Stats
  @override
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    try {
      final userDoc = await _usersCollection.doc(userId).get();
      if (!userDoc.exists) {
        throw Exception('User not found');
      }
      return userDoc.data() as Map<String, dynamic>;
    } catch (e) {
      throw Exception('Failed to get user stats: $e');
    }
  }

  @override
  Future<void> updateUserStats(String userId, Map<String, dynamic> stats) async {
    try {
      await _usersCollection.doc(userId).update(stats);
    } catch (e) {
      throw Exception('Failed to update user stats: $e');
    }
  }
} 