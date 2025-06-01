import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbloom/features/challenge/domain/models/challenge_question.dart';
import 'package:verbloom/features/challenge/presentation/providers/challenge_provider.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  final PageController _pageController = PageController();
  bool _hasAnswered = false;
  bool _isCorrect = false;
  String? _selectedAnswer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ChallengeProvider>().loadDailyChallenge();
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleAnswer(String answer) {
    if (_hasAnswered) return;

    final challengeProvider = context.read<ChallengeProvider>();
    final isCorrect = challengeProvider.answerQuestion(answer);

    setState(() {
      _hasAnswered = true;
      _selectedAnswer = answer;
      _isCorrect = isCorrect;
    });
  }

  void _nextQuestion() {
    final challengeProvider = context.read<ChallengeProvider>();
    if (!challengeProvider.isComplete) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
      challengeProvider.nextQuestion();
      setState(() {
        _hasAnswered = false;
        _selectedAnswer = null;
      });
    } else {
      // TODO: Navigate to results screen
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final challengeProvider = context.watch<ChallengeProvider>();

    if (challengeProvider.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (challengeProvider.error != null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                challengeProvider.error!,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  challengeProvider.clearError();
                  challengeProvider.loadDailyChallenge();
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (challengeProvider.questions.isEmpty) {
      return const Scaffold(
        body: Center(
          child: Text('No questions available.'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Today\'s Challenge'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Exit Challenge?'),
                  content: const Text(
                    'Your progress will be lost. Are you sure you want to exit?',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: const Text('Exit'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Question ${challengeProvider.currentQuestionIndex + 1}/${challengeProvider.questions.length}',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                // TODO: Add timer if needed
              ],
            ),
          ),
          // Question content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: challengeProvider.questions.map((question) {
                return _QuestionCard(
                  question: question,
                  hasAnswered: _hasAnswered,
                  isCorrect: _isCorrect,
                  selectedAnswer: _selectedAnswer,
                  onAnswerSelected: _handleAnswer,
                );
              }).toList(),
            ),
          ),
          // Bottom action area
          if (_hasAnswered)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    _isCorrect ? 'Correct!' : 'Incorrect',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: _isCorrect
                              ? Theme.of(context).colorScheme.primary
                              : Theme.of(context).colorScheme.error,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _isCorrect
                        ? '+${challengeProvider.currentQuestion?.xpReward ?? 0} XP'
                        : 'Try again!',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  if (challengeProvider.currentQuestion?.explanation != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      challengeProvider.currentQuestion!.explanation!,
                      style: Theme.of(context).textTheme.bodyMedium,
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextQuestion,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        challengeProvider.isComplete ? 'View Results' : 'Next Question',
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _QuestionCard extends StatelessWidget {
  final ChallengeQuestion question;
  final bool hasAnswered;
  final bool isCorrect;
  final String? selectedAnswer;
  final Function(String) onAnswerSelected;

  const _QuestionCard({
    required this.question,
    required this.hasAnswered,
    required this.isCorrect,
    required this.selectedAnswer,
    required this.onAnswerSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question.question,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          ...question.options.map((answer) => Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: _AnswerButton(
                  answer: answer,
                  isSelected: selectedAnswer == answer,
                  isCorrect: hasAnswered && isCorrect && selectedAnswer == answer,
                  isIncorrect: hasAnswered && !isCorrect && selectedAnswer == answer,
                  onPressed: () => onAnswerSelected(answer),
                ),
              )),
        ],
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final String answer;
  final bool isSelected;
  final bool isCorrect;
  final bool isIncorrect;
  final VoidCallback onPressed;

  const _AnswerButton({
    required this.answer,
    required this.isSelected,
    required this.isCorrect,
    required this.isIncorrect,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    Color? backgroundColor;
    if (isCorrect) {
      backgroundColor = Theme.of(context).colorScheme.primaryContainer;
    } else if (isIncorrect) {
      backgroundColor = Theme.of(context).colorScheme.errorContainer;
    } else if (isSelected) {
      backgroundColor = Theme.of(context).colorScheme.secondaryContainer;
    }

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          answer,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
} 