import 'package:flutter/material.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meals'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Meals Screen!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
