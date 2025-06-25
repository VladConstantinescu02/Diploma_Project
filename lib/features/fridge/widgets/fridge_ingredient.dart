import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ingredient_model.dart';
import '../services/Firestore/delete_user_specific_ingredients.dart';

const Color thirdColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);
const Color mainColor = Color(0xFFF2A20C);

class FridgeIngredientTile extends ConsumerWidget {
  const FridgeIngredientTile({super.key, required this.ingredient});

  final Ingredient ingredient;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key('${ingredient.id}-${ingredient.userId}'),
      direction: DismissDirection.endToStart,

      // ── confirm dialog (unchanged) ──────────────────────────────
      confirmDismiss: (direction) async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: const Color(0xFFFAFAF9),
            title: const Text('Confirm Delete'),
            content:
                const Text('Are you sure you want to delete this ingredient?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                style: TextButton.styleFrom(
                  backgroundColor: const Color(0xFF8B1E3F),
                ),
                child: const Text(
                  'Delete',
                  style: TextStyle(
                    color: Color(0xFFFAFAF9),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        );

        return confirmed ?? false; // ← return the result
      },

      // ── NEW: what actually happens after swipe is confirmed ────
      onDismissed: (_) async {
        await ref.read(deleteIngredientProvider).deleteSpecificUserIngredient(
              uid: ingredient.userId,
              ingredientId: ingredient.id,
            );

        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('You just deleted ${ingredient.name}'),
              backgroundColor: Colors.green,
            ),
          );
        }
      },

      // … background + card UI exactly as before …
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        color: backGroundColor,
        child: Container(
          width: 36, // Adjust size for the circle
          height: 36,
          decoration: const BoxDecoration(
            color: Color(0xFFFAFAF9), // Background color of the circle
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.delete_outline,
            color: Colors.white, // Icon color
            size: 20, // Icon size
          ),
        ),
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        color: const Color(0xFF61788C),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(48),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ingredient.name,
                      style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFAFAF9),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // Quantity
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(48),
                            color: const Color(0xFFFAFAF9),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.scale,
                                size: 18,
                                color: Color(0xFF3C4C59),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${ingredient.amount} ${ingredient.unit}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF3C4C59),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        // Calories
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(48),
                            color: const Color(0xFFFAFAF9),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.local_fire_department,
                                size: 18,
                                color: Color(0xFFE65100),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '${ingredient.nutrition.toStringAsFixed(1)} cal/100g',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  fontStyle: FontStyle.italic,
                                  color: Color(0xFFE65100),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
