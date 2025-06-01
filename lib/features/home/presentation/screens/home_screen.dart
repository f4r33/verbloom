import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:verbloom/features/auth/presentation/providers/auth_provider.dart';
import 'package:verbloom/features/game/presentation/providers/game_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final gameProvider = context.watch<GameProvider>();

    if (authProvider.user == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Please sign in to continue',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  context.go('/login');
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Verbloom'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              authProvider.signOut();
            },
          ),
        ],
      ),
      body: gameProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : gameProvider.error != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: ${gameProvider.error}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Theme.of(context).colorScheme.error,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          gameProvider.clearError();
                        },
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : SafeArea(
                  child: CustomScrollView(
                    slivers: [
                      // Top Section - Greeting & Avatar
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Theme.of(context).colorScheme.primary,
                                child: Text(
                                  authProvider.user?.displayName?[0].toUpperCase() ?? 'U',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Hi, ${authProvider.user?.displayName ?? 'User'}!',
                                      style: Theme.of(context).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.local_fire_department,
                                          size: 16,
                                          color: Theme.of(context).colorScheme.primary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${gameProvider.gameStats?.streak ?? 0}-day streak',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                        const SizedBox(width: 16),
                                        Icon(
                                          Icons.star,
                                          size: 16,
                                          color: Theme.of(context).colorScheme.secondary,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${gameProvider.gameStats?.xp ?? 0} XP',
                                          style: Theme.of(context).textTheme.bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Daily Word Card
                      if (gameProvider.dailyWord != null)
                        SliverToBoxAdapter(
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Card(
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
                            ),
                          ),
                        ),

                      // Challenge Section
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Weekly Challenge',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              Card(
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
                                            '${gameProvider.gameStats?.weeklyChallengeProgress ?? 0}/${gameProvider.gameStats?.weeklyChallengeGoal ?? 7} words',
                                            style: Theme.of(context).textTheme.titleMedium,
                                          ),
                                          Text(
                                            '${((gameProvider.gameStats?.weeklyChallengePercentage ?? 0) * 100).toInt()}%',
                                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                                  color: Theme.of(context).colorScheme.primary,
                                                ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: LinearProgressIndicator(
                                          value: gameProvider.gameStats?.weeklyChallengePercentage ?? 0,
                                          minHeight: 8,
                                        ),
                                      ),
                                      const SizedBox(height: 16),
                                      SizedBox(
                                        width: double.infinity,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // TODO: Navigate to challenge screen
                                          },
                                          style: ElevatedButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(vertical: 16),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                          ),
                                          child: const Text('Start Today\'s Challenge'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Leaderboard Preview
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Leaderboard',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 16),
                              SizedBox(
                                height: 100,
                                child: ListView.builder(
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
                      ),
                    ],
                  ),
                ),
      bottomNavigationBar: NavigationBar(
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_outlined),
            selectedIcon: Icon(Icons.emoji_events),
            label: 'Challenge',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard_outlined),
            selectedIcon: Icon(Icons.card_giftcard),
            label: 'Rewards',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        selectedIndex: 0,
        onDestinationSelected: (index) {
          // TODO: Implement navigation
        },
      ),
    );
  }
} 