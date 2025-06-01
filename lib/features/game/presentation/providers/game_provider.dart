import 'package:flutter/foundation.dart';
import 'package:verbloom/features/game/domain/models/game_stats.dart';
import 'package:verbloom/features/game/domain/models/leaderboard_entry.dart';
import 'package:verbloom/features/game/domain/models/word.dart';
import 'package:verbloom/features/game/domain/repositories/game_repository.dart';

class GameProvider extends ChangeNotifier {
  final GameRepository _repository;
  final String userId;

  GameProvider(this._repository, this.userId) {
    _init();
  }

  GameStats? _gameStats;
  Word? _dailyWord;
  List<Word> _savedWords = [];
  List<LeaderboardEntry> _leaderboard = [];
  bool _isLoading = false;
  String? _error;

  GameStats? get gameStats => _gameStats;
  Word? get dailyWord => _dailyWord;
  List<Word> get savedWords => _savedWords;
  List<LeaderboardEntry> get leaderboard => _leaderboard;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> _init() async {
    await Future.wait([
      _loadGameStats(),
      _loadDailyWord(),
      _loadSavedWords(),
      _loadLeaderboard(),
    ]);
  }

  Future<void> _loadGameStats() async {
    try {
      _gameStats = await _repository.getGameStats(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _loadDailyWord() async {
    try {
      _dailyWord = await _repository.getDailyWord();
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _loadSavedWords() async {
    try {
      _savedWords = await _repository.getSavedWords(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> _loadLeaderboard() async {
    try {
      _leaderboard = await _repository.getLeaderboard(userId: userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> saveWord(String wordId) async {
    try {
      await _repository.saveWord(userId, wordId);
      await _loadSavedWords();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> unsaveWord(String wordId) async {
    try {
      await _repository.unsaveWord(userId, wordId);
      await _loadSavedWords();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> completeChallenge(String challengeId) async {
    try {
      await _repository.completeChallenge(userId, challengeId);
      await _loadGameStats();
      await _loadLeaderboard();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }

  void addXp(int amount) {
    if (_gameStats != null) {
      _gameStats = _gameStats!.copyWith(
        xp: _gameStats!.xp + amount,
      );
      notifyListeners();
    }
  }
} 