import 'package:verbloom/features/game/domain/models/game_stats.dart';
import 'package:verbloom/features/game/domain/models/leaderboard_entry.dart';
import 'package:verbloom/features/game/domain/models/word.dart';

abstract class GameRepository {
  // Game Stats
  Future<GameStats> getGameStats(String userId);
  Future<void> updateGameStats(String userId, GameStats stats);
  
  // Words
  Future<Word> getDailyWord();
  Future<List<Word>> getSavedWords(String userId);
  Future<void> saveWord(String userId, String wordId);
  Future<void> unsaveWord(String userId, String wordId);
  
  // Leaderboard
  Future<List<LeaderboardEntry>> getLeaderboard({
    int limit = 10,
    String? userId,
  });
  
  // Challenges
  Future<void> completeChallenge(String userId, String challengeId);
  Future<int> getWeeklyChallengeProgress(String userId);
} 