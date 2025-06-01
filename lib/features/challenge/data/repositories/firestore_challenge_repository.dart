import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verbloom/features/challenge/domain/models/challenge_question.dart';

class FirestoreChallengeRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ChallengeQuestion>> getDailyChallenge() async {
    try {
      final snapshot = await _firestore
          .collection('challenges')
          .where('type', isEqualTo: 'daily')
          .where('expiresAt', isGreaterThan: DateTime.now().toIso8601String())
          .limit(1)
          .get();

      if (snapshot.docs.isEmpty) {
        throw Exception('No daily challenge available');
      }

      final challenge = snapshot.docs.first.data();
      final questions = (challenge['questions'] as List).map((q) {
        return ChallengeQuestion(
          id: q['id'] ?? '',
          question: q['question'],
          options: List<String>.from(q['options']),
          correctAnswer: q['options'][q['correctAnswer']],
          explanation: q['explanation'],
          xpReward: q['reward'] ?? 10,
        );
      }).toList();

      return questions;
    } catch (e) {
      throw Exception('Failed to load daily challenge: $e');
    }
  }

  Future<void> completeChallenge(String userId, String challengeId) async {
    try {
      final batch = _firestore.batch();
      
      // Update user's completed challenges
      final userChallengeRef = _firestore
          .collection('users')
          .doc(userId)
          .collection('completed_challenges')
          .doc(challengeId);
      
      batch.set(userChallengeRef, {
        'completedAt': FieldValue.serverTimestamp(),
      });

      // Update user's stats
      final userRef = _firestore.collection('users').doc(userId);
      batch.update(userRef, {
        'totalChallengesCompleted': FieldValue.increment(1),
      });

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to complete challenge: $e');
    }
  }
} 