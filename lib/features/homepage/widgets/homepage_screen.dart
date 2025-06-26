import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'homepage_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFDF5),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAF9),
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
          Lottie.asset(
              'lib/utils/images/UI.json',
              width: 300,
              height: 300,
            ),
          Expanded(
            child: ListView.builder(
              itemCount: 3,
              itemBuilder: (context, index) {
                // Define card details
                final cards = [
                  {
                    'onTap': () => GoRouter.of(context).go('/fridge'),
                    'icon': const Icon(Icons.food_bank_rounded, color: Colors.white, size: 40),
                    'text': 'Lets build your fridge',
                    'cardColor': const Color(0xFF3C4C59),
                    'textColor': Colors.white,
                    'iconColor': Colors.white,
                  },
                  {
                    'onTap': () => GoRouter.of(context).go('/meals'),
                    'icon': const Icon(Icons.set_meal, color: Color(0xFFFAFAF9), size: 40),
                    'text': 'Create your meals',
                    'cardColor': const Color(0xFF61788C),
                    'textColor': const Color(0xFFFAFAF9),
                    'iconColor': const Color(0xFFFAFAF9),
                  },
                  {
                    'onTap': () => GoRouter.of(context).go('/profile'),
                    'icon': const Icon(Icons.person, color: Colors.white, size: 40),
                    'text': 'Set up your profile',
                    'cardColor': const Color(0xFFF27507),
                    'textColor': Colors.white,
                    'iconColor': Colors.white,
                  },
                ];

                // Adjust the spacing dynamically
                final double spacing = MediaQuery.of(context).size.height * 0.01;

                return Padding(
                  padding: EdgeInsets.only(
                    top: index == 0 ? 0 : spacing, // No spacing for the first card
                    bottom: index == cards.length - 1 ? spacing : 0, // Optional bottom spacing for the last card
                  ),
                  child: HomePageCard(
                    onTap: cards[index]['onTap'] as VoidCallback,
                    icon: cards[index]['icon'] as Icon,
                    text: cards[index]['text'] as String,
                    cardColor: cards[index]['cardColor'] as Color,
                    textColor: cards[index]['textColor'] as Color,
                    iconColor: cards[index]['iconColor'] as Color,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

}