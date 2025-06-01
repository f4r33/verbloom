import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:verbloom/core/routes/app_router.dart';
import 'package:verbloom/features/auth/domain/services/auth_service.dart';
import 'package:verbloom/features/auth/presentation/providers/auth_provider.dart';
import 'package:verbloom/features/game/data/repositories/firebase_game_repository.dart';
import 'package:verbloom/features/game/data/seed_data.dart';
import 'package:verbloom/features/game/presentation/providers/game_provider.dart';
import 'package:verbloom/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with the generated options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Uncomment the following line to seed the database
  await DatabaseSeeder().seedAll();
  
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
      ],
      child: Builder(
        builder: (context) => MaterialApp.router(
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
          routerConfig: AppRouter.router,
        ),
      ),
    ),
  );
}
