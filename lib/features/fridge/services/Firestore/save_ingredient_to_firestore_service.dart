import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/ingredient_model.dart';

final saveIngredientsToFirestoreProvider = Provider<SaveIngredientToFirestore>((ref) {
  return SaveIngredientToFirestore();
});

class SaveIngredientToFirestore {
  final ingredients = FirebaseFirestore.instance.collection('fridgeItems');

  // ✔ 1) fixed spelling, 2) no extra userId param needed
  Future<void> addIngredientToFirestore({
    required Ingredient ingredient,
  }) async {
    await ingredients.add(ingredient.toFirestore());   // ← one clean call
  }
}