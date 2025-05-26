import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GNav(
        gap: 8,
          tabs: [
            GButton(
                icon: Icons.home_filled,
                text: 'Home',
            ),
            GButton(
                icon: Icons.food_bank_rounded,
                text: 'Fridge',

            ),
            GButton(
                icon: Icons.set_meal,
                text: 'Meals',
            ),
            GButton(
                icon: Icons.person,
                text: 'Profile',
            ),
          ]
      ),
    );
  }
}