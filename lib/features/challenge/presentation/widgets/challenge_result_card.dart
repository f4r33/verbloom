import 'package:flutter/material.dart';
import 'package:verbloom/core/theme/app_theme.dart';

class ChallengeResultCard extends StatelessWidget {
  final int score;
  final int totalQuestions;
  final int xpEarned;
  final VoidCallback onTryAgain;

  const ChallengeResultCard({
    super.key,
    required this.score,
    required this.totalQuestions,
    required this.xpEarned,
    required this.onTryAgain,
  });

  @override
  Widget build(BuildContext context) {
    final percentage = (score / totalQuestions * 100).round();

    return Center(
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Challenge Complete!',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              Text(
                '$score/$totalQuestions Correct',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(
                '$percentage%',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 24),
              Text(
                'XP Earned: $xpEarned',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: onTryAgain,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Try Again'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 