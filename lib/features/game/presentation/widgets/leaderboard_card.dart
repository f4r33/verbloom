import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbloom/features/game/presentation/providers/game_provider.dart';

class LeaderboardCard extends StatelessWidget {
  const LeaderboardCard({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Leaderboard',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to full leaderboard
                  },
                  child: const Text('View All'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 100,
              child: gameProvider.leaderboard.isEmpty
                  ? const Center(
                      child: Text('No leaderboard data available.'),
                    )
                  : ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: gameProvider.leaderboard.length,
                      itemBuilder: (context, index) {
                        final entry = gameProvider.leaderboard[index];
                        return Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: index == 0
                                    ? Colors.amber
                                    : Theme.of(context).colorScheme.primary,
                                child: Text(
                                  entry.username[0].toUpperCase(),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                entry.username,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                              Text(
                                '${entry.xp} XP',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
} 