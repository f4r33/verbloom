import 'package:flutter/foundation.dart';
import 'package:verbloom/features/rewards/domain/models/achievement.dart';
import 'package:verbloom/features/rewards/domain/repositories/rewards_repository.dart';

class RewardsProvider extends ChangeNotifier {
  final RewardsRepository _repository;
  final String _userId;

  RewardsProvider({
    required RewardsRepository repository,
    required String userId,
  })  : _repository = repository,
        _userId = userId;

  List<Achievement> _achievements = [];
  Map<String, dynamic> _userStats = {};
  bool _isLoading = false;
  String? _error;

  // Getters
  List<Achievement> get achievements => _achievements;
  Map<String, dynamic> get userStats => _userStats;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load achievements and user stats
  Future<void> loadData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _achievements = await _repository.getAchievements(_userId);
      _userStats = await _repository.getUserStats(_userId);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update achievement progress
  Future<void> updateAchievementProgress(String achievementId, int progress) async {
    try {
      await _repository.updateAchievementProgress(_userId, achievementId, progress);
      
      // Update local state
      final index = _achievements.indexWhere((a) => a.id == achievementId);
      if (index != -1) {
        _achievements[index] = _achievements[index].copyWith(progress: progress);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Unlock achievement
  Future<void> unlockAchievement(String achievementId) async {
    try {
      await _repository.unlockAchievement(_userId, achievementId);
      
      // Update local state
      final index = _achievements.indexWhere((a) => a.id == achievementId);
      if (index != -1) {
        _achievements[index] = _achievements[index].copyWith(
          isUnlocked: true,
          unlockedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  // Update user stats
  Future<void> updateUserStats(Map<String, dynamic> stats) async {
    try {
      await _repository.updateUserStats(_userId, stats);
      _userStats = stats;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
} 