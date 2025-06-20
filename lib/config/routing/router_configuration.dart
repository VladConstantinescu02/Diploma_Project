import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screens
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/register_screen.dart';
import '../../features/fridge/screens/fridge_screen.dart';
import '../../features/homepage/screens/homepage.dart';
import '../../features/meals/screens/meal_selection_screen.dart';
import '../../shared/services/authentication_service.dart';
import '../navigation/navigation.dart';
import '../../features/meals/screens/meals_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

/// Global root navigator key for shell route
final _rootNavigatorKey = GlobalKey<NavigatorState>();

/// Expose Firebase Auth stream from your service using Riverpod
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

/// GoRouter provider that reacts to auth state changes
final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: true, // optional, helps debugging router behavior
    redirect: (context, state) {
      if (authState.isLoading) return null; // Do not redirect while still loading

      final user = authState.value;

      final isAtLogin = state.uri.toString() == '/login';
      final isAtRegister = state.uri.toString() == '/register';

      if (user == null && !isAtLogin && !isAtRegister) {
        return '/login';
      }

      if (user != null && isAtLogin) {
        return '/home';
      }

      return null; // no redirection needed
    },

    routes: [
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/meal_select_screen',
        builder: (context, state) => const MealSelectionScreen(),
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
              builder: (context, state) => const MealScreen(),
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
