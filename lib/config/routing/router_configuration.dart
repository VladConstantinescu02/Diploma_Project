import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentification/screens/login_screen.dart';
import '../../features/authentification/screens/register_screen.dart';
import '../../features/fridge/screens/fridge_screen.dart';
import '../../features/homepage/screens/homepage.dart';
import '../navigation/navigationbar.dart';
import '../../features/meals/screens/meals_screen.dart';
import '../../features/profile/profile_screen.dart';


final authProvider = StateProvider<bool>((ref) => false);
final registeredProvider = StateProvider<bool>((ref) => false);


final routerProvider = Provider<GoRouter>((ref) {
  final isLoggedIn = ref.watch(authProvider);
  final isRegistered = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: '/login',
        name: 'Login',
        builder: (context, state) => LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'Register',
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
              name: 'Home',
              builder: (context, state) => const HomePage(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/fridge',
              name: 'Fridge',
              builder: (context, state) => const FridgeScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/meals',
              name: 'Meals',
              builder: (context, state) => const MealsScreen(),
            ),
          ]),
          StatefulShellBranch(routes: [
            GoRoute(
              path: '/profile',
              name: 'Profile',
              builder: (context, state) => const ProfileScreen(),
            ),
          ]),
        ],
      ),
    ],

      redirect: (context, state) {
        final path = state.uri.path;
        final isAtLogin = path == '/login';
        final isAtRegister = path == '/register';

        final isLoggedIn = ref.read(authProvider);
        final isRegistered = ref.read(registeredProvider);

        // User not logged in → allow login or register only
        if (!isLoggedIn && !isAtLogin && !isAtRegister) {
          return '/login';
        }

        // User logged in but not registered → force /register
        if (isLoggedIn && !isRegistered && !isAtRegister) {
          return '/register';
        }

        // If user is at login or register but already done → go to /home
        if (isLoggedIn && isRegistered && (isAtLogin || isAtRegister)) {
          return '/home';
        }

        return null;
      }


  );
});
