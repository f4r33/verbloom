import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:verbloom/features/auth/presentation/screens/login_screen.dart';
import 'package:verbloom/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:verbloom/features/splash/presentation/screens/splash_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
  ],
); 