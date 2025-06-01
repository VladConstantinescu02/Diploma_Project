import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'homepage_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Lets get cooking!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 35,
          ),
        ),
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Lottie.asset(
              'lib/utils/images/initial_home_animation.json',
              width: 300,
              height: 300,
            ),
          ),

          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 10),
              children: <Widget>[
                HomePageCard(
                  onTap: () {
                    GoRouter.of(context).go('/fridge');
                  },
                  icon: const Icon(Icons.set_meal_rounded, color: Colors.white, size: 40),
                  text: 'Lets build your fridge',
                  cardColor: const Color(0xFF8FB1BE),
                  textColor: Colors.white,
                  iconColor: Colors.white,
                ),
                HomePageCard(
                  onTap: () {
                    GoRouter.of(context).go('/meals');
                  },
                  icon: const Icon(Icons.fastfood, color: Colors.black, size: 40),
                  text: 'Create your meals',
                  cardColor: const Color(0xFFEEE3AB),
                  textColor: Colors.black,
                  iconColor: Colors.black,
                ),
                HomePageCard(
                  onTap: () {
                    GoRouter.of(context).go('/profile');
                  },
                  icon: const Icon(Icons.account_circle, color: Colors.white, size: 40),
                  text: 'Set up your profile',
                  cardColor: const Color(0xFF561D25),
                  textColor: Colors.white,
                  iconColor: Colors.white,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}