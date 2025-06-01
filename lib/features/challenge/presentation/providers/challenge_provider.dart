import 'package:flutter/foundation.dart';
import 'package:verbloom/features/challenge/data/repositories/firestore_challenge_repository.dart';
import 'package:verbloom/features/challenge/domain/models/challenge_question.dart';
import 'package:verbloom/features/game/presentation/providers/game_provider.dart';

class ChallengeProvider extends ChangeNotifier {
  final GameProvider _gameProvider;
  final FirestoreChallengeRepository _repository;
  List<ChallengeQuestion> _questions = [];
  int _currentQuestionIndex = 0;
  int _score = 0;
  int _totalXpEarned = 0;
  bool _isLoading = false;
  String? _error;

  ChallengeProvider(this._gameProvider)
      : _repository = FirestoreChallengeRepository();

  List<ChallengeQuestion> get questions => _questions;
  int get currentQuestionIndex => _currentQuestionIndex;
  ChallengeQuestion? get currentQuestion =>
      _questions.isNotEmpty ? _questions[_currentQuestionIndex] : null;
  int get score => _score;
  int get totalXpEarned => _totalXpEarned;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isComplete => _currentQuestionIndex >= _questions.length;

  Future<void> loadDailyChallenge() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _questions = await _repository.getDailyChallenge();
      _currentQuestionIndex = 0;
      _score = 0;
      _totalXpEarned = 0;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  bool answerQuestion(String answer) {
    if (currentQuestion == null) return false;

    final isCorrect = currentQuestion!.isCorrectAnswer(answer);
    if (isCorrect) {
      _score++;
      _totalXpEarned += currentQuestion!.xpReward;
      _gameProvider.addXp(currentQuestion!.xpReward);
    }

    notifyListeners();
    return isCorrect;
  }

  void nextQuestion() {
    if (_currentQuestionIndex < _questions.length - 1) {
      _currentQuestionIndex++;
      notifyListeners();
    }
  }

  Future<void> completeChallenge() async {
    if (!isComplete) return;

    try {
      await _repository.completeChallenge(
        _gameProvider.userId,
        currentQuestion?.id ?? '',
      );
      reset();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  void reset() {
    _currentQuestionIndex = 0;
    _score = 0;
    _totalXpEarned = 0;
    notifyListeners();
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
} 