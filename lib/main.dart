import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:verbloom/core/routes/app_router.dart';
import 'package:verbloom/features/auth/domain/services/auth_service.dart';
import 'package:verbloom/features/auth/presentation/providers/auth_provider.dart';
import 'package:verbloom/features/challenge/presentation/providers/challenge_provider.dart';
import 'package:verbloom/features/game/data/repositories/firebase_game_repository.dart';
import 'package:verbloom/features/game/data/seed_data.dart';
import 'package:verbloom/features/game/presentation/providers/game_provider.dart';
import 'package:verbloom/features/settings/presentation/providers/settings_provider.dart';
import 'package:verbloom/firebase_options.dart';
import 'package:verbloom/features/rewards/data/repositories/firestore_rewards_repository.dart';
import 'package:verbloom/features/rewards/domain/repositories/rewards_repository.dart';
import 'package:verbloom/features/rewards/presentation/providers/rewards_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with the generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  
  final authService = AuthService();
  final gameRepository = FirebaseGameRepository();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(authService),
        ),
        ChangeNotifierProxyProvider<AuthProvider, GameProvider>(
          create: (context) {
            final authProvider = context.read<AuthProvider>();
            return GameProvider(gameRepository, authProvider.user?.uid ?? '');
          },
          update: (context, authProvider, previous) {
            return GameProvider(gameRepository, authProvider.user?.uid ?? '');
          },
        ),
        ChangeNotifierProxyProvider<GameProvider, ChallengeProvider>(
          create: (context) {
            final gameProvider = context.read<GameProvider>();
            return ChallengeProvider(gameProvider);
          },
          update: (context, gameProvider, previous) {
            return ChallengeProvider(gameProvider);
          },
        ),
        ChangeNotifierProvider(
          create: (_) => SettingsProvider(prefs),
        ),
        ChangeNotifierProxyProvider<AuthProvider, RewardsProvider>(
          create: (context) {
            final authProvider = context.read<AuthProvider>();
            return RewardsProvider(
              repository: FirestoreRewardsRepository(),
              userId: authProvider.user?.uid ?? '',
            );
          },
          update: (context, authProvider, previous) => RewardsProvider(
            repository: FirestoreRewardsRepository(),
            userId: authProvider.user?.uid ?? '',
          ),
        ),
      ],
      child: Builder(
        builder: (context) {
          final settingsProvider = context.watch<SettingsProvider>();
          return MaterialApp.router(
            title: 'Verbloom',
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.light,
              ),
              useMaterial3: true,
            ),
            darkTheme: ThemeData(
              colorScheme: ColorScheme.fromSeed(
                seedColor: Colors.green,
                brightness: Brightness.dark,
              ),
              useMaterial3: true,
            ),
            themeMode: settingsProvider.themeMode,
            routerConfig: AppRouter.router,
          );
        },
      ),
    ),
  );
}
