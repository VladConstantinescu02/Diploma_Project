import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';

// Screens
import '../../features/authentication/screens/login_screen.dart';
import '../../features/authentication/screens/register_screen.dart';
import '../../features/authentication/services/authentication_service.dart';
import '../../features/fridge/screens/fridge_screen.dart';
import '../../features/homepage/screens/homepage.dart';
import '../../features/meals/screens/meal_selection_screen.dart';
import '../navigation/navigation.dart';
import '../../features/meals/screens/meals_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

/// Global key to access the root navigator of the app
final _rootNavigatorKey = GlobalKey<NavigatorState>();

//Provides the Firebase authentication state stream using Riverpod
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});

// Define an instance of GoRouter
// Check if a user is logged in or not, and rout accordingaly
final routerProvider = Provider<GoRouter>((ref) {
  // Watch the current auth state
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/login',
    debugLogDiagnostics: true, // Enables logging for router activity

    // Handles automatic redirection based on authentication state
    redirect: (context, state) {
      // While loading auth state, do not perform any redirect
      if (authState.isLoading) return null;

      // Get the current user (null if not authenticated)
      final user = authState.value;

      // Define current path checks
      final isAtLogin = state.uri.toString() == '/login';
      final isAtRegister = state.uri.toString() == '/register';

      // If user is not signed in and not on login/register page, redirect to login
      if (user == null && !isAtLogin && !isAtRegister) {
        return '/login';
      }

      // If user is signed in and tries to access login, redirect to home
      if (user != null && isAtLogin) {
        return '/home';
      }

      // No redirection needed in other cases
      return null;
    },

    // List of defined routes
    routes: [
      // Route for login screen
      GoRoute(
        path: '/login',
        builder: (context, state) => LoginScreen(),
      ),

      // Route for register screen
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),

      // Route for meal selection screen (temporary or onboarding flow)
      GoRoute(
        path: '/meal_select_screen',
        builder: (context, state) => const MealSelectionScreen(),
      ),

      // Shell route for bottom navigation
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: Navigation(navigationShell: navigationShell),
          );
        },
        branches: [
          // Home page branch
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ]),

          // Fridge screen branch
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/fridge',
              builder: (context, state) => const FridgeScreen(),
            ),
          ]),

          // Meals screen branch
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/meals',
              builder: (context, state) => const MealScreen(),
            ),
          ]),

          // Profile screen branch
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],
  );
});
