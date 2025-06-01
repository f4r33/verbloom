import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verbloom/features/rewards/domain/models/achievement.dart';

class AchievementsSeeder {
  final FirebaseFirestore _firestore;

  AchievementsSeeder({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> seedAchievements() async {
    final achievements = [
      Achievement(
        id: 'first_word',
        title: 'First Word',
        description: 'Learn your first word',
        icon: '🎯',
        progress: 0,
        total: 1,
        isUnlocked: false,
      ),
      Achievement(
        id: 'word_master',
        title: 'Word Master',
        description: 'Learn 50 words',
        icon: '📚',
        progress: 0,
        total: 50,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak_warrior',
        title: 'Streak Warrior',
        description: 'Maintain a 7-day streak',
        icon: '🔥',
        progress: 0,
        total: 7,
        isUnlocked: false,
      ),
      Achievement(
        id: 'perfect_score',
        title: 'Perfect Score',
        description: 'Get 100% on a challenge',
        icon: '⭐',
        progress: 0,
        total: 1,
        isUnlocked: false,
      ),
    ];

    final batch = _firestore.batch();
    final achievementsCollection = _firestore.collection('achievements');

    for (var achievement in achievements) {
      final docRef = achievementsCollection.doc(achievement.id);
      batch.set(docRef, achievement.toJson());
    }

    await batch.commit();
  }

  Future<void> seedUserAchievements(String userId) async {
    final achievements = await _firestore.collection('achievements').get();
    final batch = _firestore.batch();
    final userAchievementsCollection = _firestore
        .collection('users')
        .doc(userId)
        .collection('achievements');

    for (var achievement in achievements.docs) {
      final achievementData = achievement.data();
      achievementData['progress'] = 0;
      achievementData['isUnlocked'] = false;
      achievementData['unlockedAt'] = null;

      final docRef = userAchievementsCollection.doc(achievement.id);
      batch.set(docRef, achievementData);
    }

    await batch.commit();
  }
} 