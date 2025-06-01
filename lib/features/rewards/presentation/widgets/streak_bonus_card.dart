import 'package:flutter/material.dart';

class StreakBonusCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final int streakBonus;

  const StreakBonusCard({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    required this.streakBonus,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.local_fire_department,
                  color: currentStreak > 0 ? Colors.orange : Colors.grey,
                ),
                const SizedBox(width: 8),
                Text(
                  currentStreak > 0 ? '$currentStreak-day streak' : 'No active streak',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (currentStreak > 0) ...[
              Text(
                'Longest streak: $longestStreak days',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                'Current bonus: +$streakBonus% XP',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: currentStreak / 7, // Weekly progress
                  minHeight: 8,
                  backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${7 - currentStreak} more days until next bonus',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ] else
              Text(
                'Complete daily challenges to start your streak!',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
          ],
        ),
      ),
    );
  }
} 