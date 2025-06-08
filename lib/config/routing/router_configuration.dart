import 'package:diploma_prj/features/authentication/screens/register_screen.dart';
import 'package:diploma_prj/shared/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/authentication/screens/login_screen.dart';
import '../../features/fridge/screens/fridge_screen.dart';
import '../../features/homepage/screens/homepage.dart';
import '../../features/profile/screens/edit_profile_screen.dart';
import '../../shared/helpers/custom_go_router_refresh_stream.dart';
import '../navigation/navigation.dart';
import '../../features/meals/screens/meals_screen.dart';
import '../../features/profile/screens/profile_screen.dart';

final registeredProvider = StateProvider<bool>((ref) => false);
final loginProvider = StateProvider<bool>((ref) => false);


final routerProvider = Provider<GoRouter>((ref) {
  final authService = ref.watch(authServiceProvider);
  final user = authService.currentUser;

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: GoRouterRefreshStream(authService.authStateChanges),
    redirect: (context, state) {
      final path = state.uri.path;
      final isAtLogin = path == '/login';
      final isAtRegister = path == '/register';

      final isLoggedIn = user != null;
      final isRegistered = user?.displayName != null && user!.displayName!.isNotEmpty;

      final isProtected = !(isAtLogin || isAtRegister);

      if (!isLoggedIn && isProtected) return '/login';
      if (isLoggedIn && !isRegistered && isProtected && !isAtRegister) return '/register';
      if (isLoggedIn && isRegistered && (isAtLogin || isAtRegister)) return '/home';

      return null;
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
      GoRoute(
        path: '/editProfile',
        builder: (context, state) => const EditProfileScreen(),
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
