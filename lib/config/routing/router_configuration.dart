import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screens
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/register_screen.dart';
import '../../features/fridge/screens/fridge_screen.dart';
import '../../features/homepage/screens/homepage.dart';
import '../../shared/services/authentication_service.dart';
import '../navigation/navigation.dart';
import '../../features/meals/screens/meals_screen.dart';
import '../../features/profile/screens/profile_screen.dart';



final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Expose Firebase Auth Stream from your service
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// Main router provider
final routerProvider = Provider<GoRouter>((ref) {
  final authAsync = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: true,

    redirect: (context, state) {
      final path = state.uri.path;
      final isLoggedIn = authAsync.value != null;

      final isAtLogin = path == '/login';
      final isAtRegister = path == '/register';

      // Wait for auth state to load
      if (authAsync.isLoading) return null;

      if (!isLoggedIn && !isAtLogin && !isAtRegister) {
        return '/login';
      }

      if (isLoggedIn && (isAtLogin || isAtRegister)) {
        return '/home';
      }

      return null; // No redirect needed
    },

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => RegisterScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: Navigation(navigationShell: navigationShell),
          );
        },
        branches: [
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/fridge',
              builder: (context, state) => const FridgeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/meals',
              builder: (context, state) => const MealsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});
