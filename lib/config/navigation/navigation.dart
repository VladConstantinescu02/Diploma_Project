import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class Navigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  const Navigation({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF2A20C),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
        child: GNav(
          selectedIndex: navigationShell.currentIndex,
          onTabChange: (index) {
            navigationShell.goBranch(index);
          },
          backgroundColor: const Color(0xFFF2A20C),
          color: Colors.white,
          activeColor: Colors.white,
          tabActiveBorder: Border.all(color: const Color(0xFFFAFAF9)),
          padding: const EdgeInsets.all(12),
          gap: 10,
          tabs: const [
            GButton(icon: Icons.home_filled, text: 'Home'),
            GButton(icon: Icons.food_bank_rounded, text: 'Fridge'),
            GButton(icon: Icons.set_meal, text: 'Meals'),
            GButton(icon: Icons.person, text: 'Profile'),
          ],
        ),
      ),
    );
  }
}
