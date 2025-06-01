import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:verbloom/features/auth/presentation/providers/auth_provider.dart';
import 'package:verbloom/features/auth/presentation/screens/login_screen.dart';
import 'package:verbloom/features/auth/presentation/screens/signup_screen.dart';
import 'package:verbloom/features/home/presentation/screens/home_screen.dart';
import 'package:verbloom/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:verbloom/features/splash/presentation/screens/splash_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

class AppRouter {
  static const String initial = '/';
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';

  static GoRouter getRouter(BuildContext context) {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: splash,
      debugLogDiagnostics: true,
      redirect: (context, state) {
        final authProvider = context.read<AuthProvider>();
        final isAuthenticated = authProvider.isAuthenticated;
        final isSplash = state.matchedLocation == splash;
        final isOnboarding = state.matchedLocation == onboarding;
        final isAuth = state.matchedLocation == login || state.matchedLocation == signup;

        // If we're on the splash screen, let it handle the initial auth check
        if (isSplash) {
          return null;
        }

        // If not authenticated and not on auth screens, redirect to login
        if (!isAuthenticated && !isAuth && !isOnboarding) {
          return login;
        }

        // If authenticated and on auth screens, redirect to home
        if (isAuthenticated && isAuth) {
          return home;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: splash,
          builder: (context, state) => const SplashScreen(),
        ),
        GoRoute(
          path: onboarding,
          builder: (context, state) => const OnboardingScreen(),
        ),
        GoRoute(
          path: login,
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: signup,
          builder: (context, state) => const SignupScreen(),
        ),
        GoRoute(
          path: home,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    );
  }
} 