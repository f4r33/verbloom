import 'package:flutter/material.dart';
import 'package:verbloom/features/rewards/domain/models/achievement.dart';

class AchievementCard extends StatelessWidget {
  final Achievement achievement;

  const AchievementCard({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: () {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(achievement.title),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(achievement.description),
                  const SizedBox(height: 8),
                  if (!achievement.isUnlocked)
                    Text(
                      'Progress: ${achievement.progress}/${achievement.total}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  if (achievement.isUnlocked && achievement.unlockedAt != null)
                    Text(
                      'Unlocked: ${_formatDate(achievement.unlockedAt!)}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Close'),
                ),
              ],
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                achievement.icon,
                style: const TextStyle(fontSize: 32),
              ),
              const SizedBox(height: 8),
              Text(
                achievement.title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: achievement.isUnlocked
                          ? null
                          : Theme.of(context).colorScheme.outline,
                    ),
                textAlign: TextAlign.center,
              ),
              if (!achievement.isUnlocked) ...[
                const SizedBox(height: 4),
                Text(
                  '${achievement.progress}/${achievement.total}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Today';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
} 