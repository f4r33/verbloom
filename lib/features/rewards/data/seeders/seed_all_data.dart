import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:verbloom/features/rewards/domain/models/achievement.dart';

class GameDataSeeder {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> seedAllData() async {
    try {
      // Seed data
      await _seedAchievements();
      await _seedDailyWords();
      await _seedUserStatsTemplate();
      await _seedGameSettings();
      await _seedChallenges();
      
      print('All data seeded successfully!');
    } catch (e) {
      print('Error seeding data: $e');
      rethrow;
    }
  }

  Future<void> _seedAchievements() async {
    final achievements = [
      Achievement(
        id: 'first_win',
        title: 'First Victory',
        description: 'Win your first game',
        icon: '🏆',
        progress: 0,
        total: 1,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak_3',
        title: 'On Fire',
        description: 'Maintain a 3-day streak',
        icon: '🔥',
        progress: 0,
        total: 3,
        isUnlocked: false,
      ),
      Achievement(
        id: 'streak_7',
        title: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        icon: '🌟',
        progress: 0,
        total: 7,
        isUnlocked: false,
      ),
      Achievement(
        id: 'perfect_score',
        title: 'Perfect Score',
        description: 'Get a perfect score in any game',
        icon: '💯',
        progress: 0,
        total: 1,
        isUnlocked: false,
      ),
    ];

    final batch = _firestore.batch();
    final achievementsRef = _firestore.collection('achievements');

    for (final achievement in achievements) {
      batch.set(
        achievementsRef.doc(achievement.id),
        achievement.toJson(),
      );
    }

    await batch.commit();
  }

  Future<void> _seedDailyWords() async {
    final dailyWords = [
      {
        'word': 'bloom',
        'definition': 'To produce flowers; to flourish',
        'difficulty': 'medium',
        'category': 'nature',
        'date': DateTime.now().toIso8601String(),
      },
      {
        'word': 'serene',
        'definition': 'Calm, peaceful, and untroubled',
        'difficulty': 'easy',
        'category': 'emotions',
        'date': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      },
      {
        'word': 'eloquent',
        'definition': 'Fluent or persuasive in speaking or writing',
        'difficulty': 'hard',
        'category': 'language',
        'date': DateTime.now().add(const Duration(days: 2)).toIso8601String(),
      },
    ];

    final batch = _firestore.batch();
    final dailyWordsRef = _firestore.collection('daily_words');

    for (final word in dailyWords) {
      batch.set(
        dailyWordsRef.doc(word['date'] as String),
        word,
      );
    }

    await batch.commit();
  }

  Future<void> _seedUserStatsTemplate() async {
    final userStatsTemplate = {
      'totalXP': 0,
      'currentLevel': 1,
      'streak': 0,
      'highestStreak': 0,
      'gamesPlayed': 0,
      'gamesWon': 0,
      'perfectScores': 0,
      'lastPlayedDate': null,
      'achievements': [],
    };

    await _firestore
        .collection('user_stats_template')
        .doc('default')
        .set(userStatsTemplate);
  }

  Future<void> _seedGameSettings() async {
    final gameSettings = {
      'xpPerWin': 100,
      'xpPerPerfectScore': 50,
      'streakBonus': 10,
      'maxStreakBonus': 50,
      'levelThresholds': [0, 100, 250, 500, 1000, 2000, 4000, 8000],
    };

    await _firestore
        .collection('game_settings')
        .doc('default')
        .set(gameSettings);
  }

  Future<void> _seedChallenges() async {
    final challenges = [
      {
        'id': 'daily_challenge_1',
        'title': 'Word Master',
        'description': 'Complete 5 word games with perfect scores',
        'type': 'daily',
        'reward': 500,
        'questions': [
          {
            'question': 'What is the meaning of "eloquent"?',
            'options': [
              'Fluent and persuasive in speaking',
              'Quiet and reserved',
              'Angry and aggressive',
              'Confused and uncertain'
            ],
            'correctAnswer': 0,
            'explanation': 'Eloquent means fluent and persuasive in speaking or writing.'
          },
          {
            'question': 'Which word means "to flourish or grow"?',
            'options': [
              'Wither',
              'Bloom',
              'Fade',
              'Decay'
            ],
            'correctAnswer': 1,
            'explanation': 'Bloom means to flourish or grow, often used in reference to flowers.'
          },
          {
            'question': 'What is the opposite of "serene"?',
            'options': [
              'Calm',
              'Peaceful',
              'Turbulent',
              'Quiet'
            ],
            'correctAnswer': 2,
            'explanation': 'Turbulent is the opposite of serene, meaning agitated or disturbed.'
          }
        ],
        'expiresAt': DateTime.now().add(const Duration(days: 1)).toIso8601String(),
      },
      {
        'id': 'weekly_challenge_1',
        'title': 'Vocabulary Champion',
        'description': 'Master 20 new words this week',
        'type': 'weekly',
        'reward': 1000,
        'questions': [
          {
            'question': 'What does "ephemeral" mean?',
            'options': [
              'Lasting forever',
              'Lasting for a very short time',
              'Growing rapidly',
              'Moving slowly'
            ],
            'correctAnswer': 1,
            'explanation': 'Ephemeral means lasting for a very short time.'
          },
          {
            'question': 'Which word best describes someone who is "meticulous"?',
            'options': [
              'Careless',
              'Very careful and precise',
              'Lazy',
              'Aggressive'
            ],
            'correctAnswer': 1,
            'explanation': 'Meticulous means showing great attention to detail; very careful and precise.'
          },
          {
            'question': 'What is the meaning of "ubiquitous"?',
            'options': [
              'Rare and unusual',
              'Present everywhere',
              'Hidden and secret',
              'Temporary and fleeting'
            ],
            'correctAnswer': 1,
            'explanation': 'Ubiquitous means present, appearing, or found everywhere.'
          }
        ],
        'expiresAt': DateTime.now().add(const Duration(days: 7)).toIso8601String(),
      }
    ];

    final batch = _firestore.batch();
    final challengesRef = _firestore.collection('challenges');

    for (final challenge in challenges) {
      batch.set(
        challengesRef.doc(challenge['id'] as String),
        challenge,
      );
    }

    await batch.commit();
  }
} 