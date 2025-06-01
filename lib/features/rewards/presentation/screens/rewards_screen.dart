import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbloom/features/rewards/domain/models/achievement.dart';
import 'package:verbloom/features/rewards/presentation/providers/rewards_provider.dart';
import 'package:verbloom/features/rewards/presentation/widgets/achievement_card.dart';
import 'package:verbloom/features/rewards/presentation/widgets/reward_summary_card.dart';
import 'package:verbloom/features/rewards/presentation/widgets/streak_bonus_card.dart';
import 'package:verbloom/features/rewards/presentation/widgets/xp_progress_card.dart';

class RewardsScreen extends StatefulWidget {
  const RewardsScreen({super.key});

  @override
  State<RewardsScreen> createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  @override
  void initState() {
    super.initState();
    // Load data when screen initializes
    Future.microtask(() => context.read<RewardsProvider>().loadData());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<RewardsProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${provider.error}'),
                  ElevatedButton(
                    onPressed: () => provider.loadData(),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final userStats = provider.userStats;
          final achievements = provider.achievements;

          return CustomScrollView(
            slivers: [
              SliverAppBar(
                title: const Text('Rewards'),
                floating: true,
                snap: true,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // XP Progress Section
                      XPProgressCard(
                        totalXp: userStats['totalXp'] ?? 0,
                        currentLevel: userStats['level'] ?? 1,
                        xpToNextLevel: userStats['xpToNextLevel'] ?? 100,
                      ),
                      const SizedBox(height: 16),

                      // Streak Bonus Card
                      StreakBonusCard(
                        currentStreak: userStats['currentStreak'] ?? 0,
                        longestStreak: userStats['longestStreak'] ?? 0,
                        streakBonus: userStats['streakBonus'] ?? 0,
                      ),
                      const SizedBox(height: 24),

                      // Badges & Achievements
                      const Text(
                        'Badges & Achievements',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 1.5,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: achievements.length,
                        itemBuilder: (context, index) {
                          final achievement = achievements[index];
                          return AchievementCard(achievement: achievement);
                        },
                      ),
                      const SizedBox(height: 24),

                      // Rewards Summary
                      const Text(
                        'Rewards Summary',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      RewardSummaryCard(
                        recentlyUnlocked: achievements
                            .where((a) => a.isUnlocked)
                            .take(3)
                            .toList(),
                        upcomingRewards: achievements
                            .where((a) => !a.isUnlocked)
                            .take(3)
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
} 