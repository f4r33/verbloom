import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbloom/features/challenge/presentation/providers/challenge_provider.dart';
import 'package:verbloom/features/challenge/presentation/widgets/challenge_question_card.dart';
import 'package:verbloom/features/challenge/presentation/widgets/challenge_result_card.dart';

class ChallengeScreen extends StatefulWidget {
  const ChallengeScreen({super.key});

  @override
  State<ChallengeScreen> createState() => _ChallengeScreenState();
}

class _ChallengeScreenState extends State<ChallengeScreen> {
  @override
  void initState() {
    super.initState();
    // Load challenges when the screen is first shown
    Future.microtask(() {
      context.read<ChallengeProvider>().loadDailyChallenge();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Challenge'),
        centerTitle: true,
      ),
      body: Consumer<ChallengeProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${provider.error}',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      provider.clearError();
                      provider.loadDailyChallenge();
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (provider.questions.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'No challenges available',
                    style: theme.textTheme.titleLarge,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Check back later for new challenges!',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            );
          }

          if (provider.isComplete) {
            return ChallengeResultCard(
              score: provider.score,
              totalQuestions: provider.questions.length,
              xpEarned: provider.totalXpEarned,
              onTryAgain: () {
                provider.reset();
                provider.loadDailyChallenge();
              },
            );
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                LinearProgressIndicator(
                  value: (provider.currentQuestionIndex + 1) /
                      provider.questions.length,
                  backgroundColor: theme.colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ChallengeQuestionCard(
                    question: provider.currentQuestion!,
                    onAnswer: (answer) {
                      final isCorrect = provider.answerQuestion(answer);
                      if (isCorrect) {
                        // Show success feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Correct! +${provider.currentQuestion!.xpReward} XP',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: theme.colorScheme.primary,
                            duration: const Duration(seconds: 1),
                          ),
                        );
                      } else {
                        // Show error feedback
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              'Incorrect. The answer is: ${provider.currentQuestion!.correctAnswer}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            backgroundColor: theme.colorScheme.error,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }

                      // Move to next question after a short delay
                      Future.delayed(const Duration(seconds: 1), () {
                        if (provider.currentQuestionIndex <
                            provider.questions.length - 1) {
                          provider.nextQuestion();
                        } else {
                          // Complete the challenge
                          provider.completeChallenge();
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
} 