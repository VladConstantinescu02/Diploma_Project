import 'package:flutter/material.dart';

class FridgeScreen extends StatelessWidget {
  const FridgeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fridge'),
      ),
      body: const Center(
        child: Text(
          'Welcome to the Fridge Screen!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
