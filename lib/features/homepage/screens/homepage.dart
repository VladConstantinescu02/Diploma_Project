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
      bottomNavigationBar:
        Container(
          color: Color(0xFFFF5733),
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 15.0,
                vertical: 15
            ),
            child: GNav(
              backgroundColor: Color(0xFFFF5733),
              color: Colors.white,
              activeColor: Colors.white,
              tabActiveBorder: Border.all(color: Color(0xFFFAF3E0)),
              padding: EdgeInsets.all(16),
              gap: 10,
              onTabChange: (index)  {
                print(index);
              },
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
          ),
        ),
    );
  }
}