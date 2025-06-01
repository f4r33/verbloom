import 'package:flutter/material.dart';
import 'package:verbloom/features/rewards/domain/models/achievement.dart';

class RewardSummaryCard extends StatelessWidget {
  final List<Achievement> recentlyUnlocked;
  final List<Achievement> upcomingRewards;

  const RewardSummaryCard({
    super.key,
    required this.recentlyUnlocked,
    required this.upcomingRewards,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (recentlyUnlocked.isNotEmpty) ...[
              const Text(
                'Recently Unlocked',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...recentlyUnlocked.map((achievement) => _RewardItem(
                    icon: achievement.icon,
                    title: achievement.title,
                    description: _formatDate(achievement.unlockedAt!),
                  )),
              if (upcomingRewards.isNotEmpty) const Divider(),
            ],
            if (upcomingRewards.isNotEmpty) ...[
              const Text(
                'Upcoming Rewards',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              ...upcomingRewards.map((achievement) => _RewardItem(
                    icon: achievement.icon,
                    title: achievement.title,
                    description: '${achievement.progress}/${achievement.total}',
                  )),
            ],
          ],
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

class _RewardItem extends StatelessWidget {
  final String icon;
  final String title;
  final String description;

  const _RewardItem({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            icon,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 