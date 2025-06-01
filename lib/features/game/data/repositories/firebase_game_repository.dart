import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:verbloom/features/game/domain/models/game_stats.dart';
import 'package:verbloom/features/game/domain/models/language.dart';
import 'package:verbloom/features/game/domain/models/leaderboard_entry.dart';
import 'package:verbloom/features/game/domain/models/word.dart';
import 'package:verbloom/features/game/domain/repositories/game_repository.dart';

class FirebaseGameRepository implements GameRepository {
  final FirebaseFirestore _firestore;

  FirebaseGameRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  // Language-related methods
  Future<List<Language>> getLanguages() async {
    final snapshot = await _firestore.collection('languages').get();
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Language(
        id: doc.id,
        name: data['name'],
        code: data['code'],
        flag: data['flag'],
        isActive: data['isActive'] ?? true,
      );
    }).toList();
  }

  Future<Language> getLanguage(String code) async {
    final doc = await _firestore
        .collection('languages')
        .where('code', isEqualTo: code)
        .limit(1)
        .get();

    if (doc.docs.isEmpty) {
      throw Exception('Language not found');
    }

    final data = doc.docs.first.data();
    return Language(
      id: doc.docs.first.id,
      name: data['name'],
      code: data['code'],
      flag: data['flag'],
      isActive: data['isActive'] ?? true,
    );
  }

  // Word-related methods
  @override
  Future<Word> getDailyWord({String languageCode = 'en'}) async {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    final doc = await _firestore
        .collection('languages')
        .doc(languageCode)
        .collection('daily_words')
        .where('date', isEqualTo: Timestamp.fromDate(startOfDay))
        .limit(1)
        .get();

    if (doc.docs.isEmpty) {
      throw Exception('No daily word found for today');
    }

    final data = doc.docs.first.data();
    return Word(
      id: doc.docs.first.id,
      word: data['word'],
      definition: data['definition'],
      example: data['example'],
      pronunciation: data['pronunciation'],
      languageCode: languageCode,
      synonyms: List<String>.from(data['synonyms'] ?? []),
      antonyms: List<String>.from(data['antonyms'] ?? []),
      difficulty: data['difficulty'] ?? 'medium',
      translations: Map<String, String>.from(data['translations'] ?? {}),
      tags: List<String>.from(data['tags'] ?? []),
    );
  }

  @override
  Future<List<Word>> getSavedWords(String userId, {String languageCode = 'en'}) async {
    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_words')
        .where('languageCode', isEqualTo: languageCode)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      return Word(
        id: doc.id,
        word: data['word'],
        definition: data['definition'],
        example: data['example'],
        pronunciation: data['pronunciation'],
        languageCode: languageCode,
        synonyms: List<String>.from(data['synonyms'] ?? []),
        antonyms: List<String>.from(data['antonyms'] ?? []),
        difficulty: data['difficulty'] ?? 'medium',
        isSaved: true,
        translations: Map<String, String>.from(data['translations'] ?? {}),
        tags: List<String>.from(data['tags'] ?? []),
      );
    }).toList();
  }

  @override
  Future<void> saveWord(String userId, String wordId, {String languageCode = 'en'}) async {
    final wordDoc = await _firestore
        .collection('languages')
        .doc(languageCode)
        .collection('words')
        .doc(wordId)
        .get();

    if (!wordDoc.exists) {
      throw Exception('Word not found');
    }

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_words')
        .doc(wordId)
        .set({
      ...wordDoc.data()!,
      'languageCode': languageCode,
      'savedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> unsaveWord(String userId, String wordId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('saved_words')
        .doc(wordId)
        .delete();
  }

  // Rest of the existing methods...
  @override
  Future<GameStats> getGameStats(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) {
      return GameStats();
    }

    final data = doc.data() as Map<String, dynamic>;
    return GameStats(
      xp: data['xp'] ?? 0,
      streak: data['streak'] ?? 0,
      weeklyChallengeProgress: data['weeklyChallengeProgress'] ?? 0,
      weeklyChallengeGoal: data['weeklyChallengeGoal'] ?? 7,
      totalWordsLearned: data['totalWordsLearned'] ?? 0,
      totalChallengesCompleted: data['totalChallengesCompleted'] ?? 0,
      lastActiveDate: (data['lastActiveDate'] as Timestamp?)?.toDate(),
    );
  }

  @override
  Future<void> updateGameStats(String userId, GameStats stats) async {
    await _firestore.collection('users').doc(userId).update({
      'xp': stats.xp,
      'streak': stats.streak,
      'weeklyChallengeProgress': stats.weeklyChallengeProgress,
      'weeklyChallengeGoal': stats.weeklyChallengeGoal,
      'totalWordsLearned': stats.totalWordsLearned,
      'totalChallengesCompleted': stats.totalChallengesCompleted,
      'lastActiveDate': Timestamp.fromDate(stats.lastActiveDate),
    });
  }

  @override
  Future<List<LeaderboardEntry>> getLeaderboard({
    int limit = 10,
    String? userId,
  }) async {
    final query = _firestore
        .collection('users')
        .orderBy('xp', descending: true)
        .limit(limit);

    final snapshot = await query.get();
    final entries = snapshot.docs.asMap().entries.map((entry) {
      final data = entry.value.data();
      return LeaderboardEntry(
        userId: entry.value.id,
        username: data['username'] ?? 'Anonymous',
        avatarUrl: data['avatarUrl'],
        xp: data['xp'] ?? 0,
        rank: entry.key + 1,
        streak: data['streak'] ?? 0,
        totalWordsLearned: data['totalWordsLearned'] ?? 0,
      );
    }).toList();

    if (userId != null) {
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        final data = userDoc.data()!;
        final userEntry = LeaderboardEntry(
          userId: userId,
          username: data['username'] ?? 'Anonymous',
          avatarUrl: data['avatarUrl'],
          xp: data['xp'] ?? 0,
          rank: entries.indexWhere((e) => e.userId == userId) + 1,
          streak: data['streak'] ?? 0,
          totalWordsLearned: data['totalWordsLearned'] ?? 0,
        );
        if (!entries.any((e) => e.userId == userId)) {
          entries.add(userEntry);
        }
      }
    }

    return entries;
  }

  @override
  Future<void> completeChallenge(String userId, String challengeId) async {
    final batch = _firestore.batch();
    
    final userRef = _firestore.collection('users').doc(userId);
    batch.update(userRef, {
      'weeklyChallengeProgress': FieldValue.increment(1),
      'xp': FieldValue.increment(10),
    });

    final challengeRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('completed_challenges')
        .doc(challengeId);
    batch.set(challengeRef, {
      'completedAt': FieldValue.serverTimestamp(),
    });

    await batch.commit();
  }

  @override
  Future<int> getWeeklyChallengeProgress(String userId) async {
    final doc = await _firestore.collection('users').doc(userId).get();
    if (!doc.exists) return 0;
    
    final data = doc.data() as Map<String, dynamic>;
    return data['weeklyChallengeProgress'] ?? 0;
  }
} 