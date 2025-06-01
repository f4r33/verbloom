import 'package:flutter/material.dart';
import 'package:verbloom/core/theme/app_theme.dart';
import 'package:verbloom/features/challenge/domain/models/challenge_question.dart';

class ChallengeQuestionCard extends StatelessWidget {
  final ChallengeQuestion question;
  final Function(String) onAnswer;

  const ChallengeQuestionCard({
    super.key,
    required this.question,
    required this.onAnswer,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
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
                    onPressed: () => onAnswer(answer),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class _AnswerButton extends StatelessWidget {
  final String answer;
  final VoidCallback onPressed;

  const _AnswerButton({
    required this.answer,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
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