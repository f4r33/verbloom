import 'package:flutter/material.dart';

class XPProgressCard extends StatelessWidget {
  final int totalXp;
  final int currentLevel;
  final int xpToNextLevel;

  const XPProgressCard({
    super.key,
    required this.totalXp,
    required this.currentLevel,
    required this.xpToNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    final progress = xpToNextLevel > 0 ? totalXp / xpToNextLevel : 1.0;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  '$totalXp XP',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Level $currentLevel → ${currentLevel + 1}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${xpToNextLevel - totalXp} XP until next level',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }
} 