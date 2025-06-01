import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbloom/features/game/presentation/providers/game_provider.dart';

class DailyWordCard extends StatelessWidget {
  const DailyWordCard({super.key});

  @override
  Widget build(BuildContext context) {
    final gameProvider = context.watch<GameProvider>();

    if (gameProvider.dailyWord == null) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Text('No daily word found for today.'),
          ),
        ),
      );
    }

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
                  'Word of the Day',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: Icon(
                    gameProvider.dailyWord!.isSaved
                        ? Icons.star
                        : Icons.star_border,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  onPressed: () {
                    if (gameProvider.dailyWord!.isSaved) {
                      gameProvider.unsaveWord(gameProvider.dailyWord!.id);
                    } else {
                      gameProvider.saveWord(gameProvider.dailyWord!.id);
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              gameProvider.dailyWord!.word,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              gameProvider.dailyWord!.definition,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              gameProvider.dailyWord!.example,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () {
                    // TODO: Implement pronunciation
                  },
                ),
                Text(
                  gameProvider.dailyWord!.pronunciation,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 