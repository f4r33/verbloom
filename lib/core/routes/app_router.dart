import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:verbloom/features/auth/presentation/providers/auth_provider.dart';
import 'package:verbloom/features/auth/presentation/screens/login_screen.dart';
import 'package:verbloom/features/auth/presentation/screens/signup_screen.dart';
import 'package:verbloom/features/challenge/presentation/screens/challenge_screen.dart';
import 'package:verbloom/features/home/presentation/screens/home_screen.dart';
import 'package:verbloom/features/onboarding/presentation/screens/onboarding_screen.dart';
import 'package:verbloom/features/profile/presentation/screens/profile_screen.dart';
import 'package:verbloom/features/splash/presentation/screens/splash_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'shell');

class AppRouter {
  static const String initial = '/';
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String home = '/home';
  static const String profile = '/profile';
  static const String challenge = '/challenge';

  static GoRouter get router => GoRouter(
        initialLocation: splash,
        navigatorKey: _rootNavigatorKey,
        redirect: (context, state) {
          final authProvider = context.read<AuthProvider>();
          final isAuthenticated = authProvider.isAuthenticated;
          final isSplash = state.matchedLocation == splash;

          if (!isAuthenticated && !isSplash) {
            return login;
          }

          if (isAuthenticated && (state.matchedLocation == login || state.matchedLocation == signup)) {
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
          ShellRoute(
            navigatorKey: _shellNavigatorKey,
            builder: (context, state, child) {
              return ScaffoldWithBottomNav(child: child);
            },
            routes: [
              GoRoute(
                path: home,
                builder: (context, state) => const HomeScreen(),
              ),
              GoRoute(
                path: profile,
                builder: (context, state) => const ProfileScreen(),
              ),
              GoRoute(
                path: challenge,
                builder: (context, state) => const ChallengeScreen(),
              ),
            ],
          ),
        ],
      );
}

class ScaffoldWithBottomNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithBottomNav({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
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
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) {
          _onItemTapped(context, index);
        },
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).matchedLocation;
    if (location.startsWith('/home')) return 0;
    if (location.startsWith('/challenge')) return 1;
    if (location.startsWith('/rewards')) return 2;
    if (location.startsWith('/profile')) return 3;
    return 0;
  }

  void _onItemTapped(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/challenge');
        break;
      case 2:
        // TODO: Implement rewards screen
        break;
      case 3:
        context.go('/profile');
        break;
    }
  }
} 