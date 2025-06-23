import 'package:flutter/material.dart';
import '../models/meal_model.dart';

const Color thirdColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);
const Color mainColor = Color(0xFFF2A20C);

class MealDetailDrawer extends StatelessWidget {
  final Meal meal;

  const MealDetailDrawer({super.key, required this.meal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (meal.instructions != null && meal.instructions!.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Instructions:',
                      style: TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text(meal.instructions!),
                ],
              ),
            const SizedBox(height: 24),
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                    backgroundColor: mainColor, elevation: 0),
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(
                  Icons.close_rounded,
                  color: backGroundColor,
                ),
                label: const Text(
                  "Close",
                  style: TextStyle(color: backGroundColor),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
