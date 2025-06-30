import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class LoadingScreen extends StatelessWidget {
  const LoadingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      body: Center(
        child: LoadingAnimationWidget.discreteCircle(
          color: const Color(0xFFF2A20C), // or use Theme.of(context).primaryColor
          size: 60.0,
        ),
      ),
    );
  }
}
