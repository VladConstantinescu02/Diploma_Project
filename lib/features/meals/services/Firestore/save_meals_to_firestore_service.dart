import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

import '../../models/meal_model.dart';

final saveToFirestoreMealsServiceProvider = Provider<SaveToFirestoreMealsService>((ref) {
  return SaveToFirestoreMealsService();
});


class SaveToFirestoreMealsService {
  final _mealsCollection = FirebaseFirestore.instance.collection('meals');

  final uuid = const Uuid();
  final user = FirebaseAuth.instance.currentUser;



  Future<void> addMealToFireStore(
      {required Meal meal, required String userId}) async {
    final mealID = uuid.v4();
    await _mealsCollection.add({
      'name': meal.title,
      'imageURL': meal.image,
      'instructions': meal.instructions ?? '',
      'summary': meal.summary ?? '',
      'readyInMinutes': meal.readyInMinutes ?? 0,
      'calories': _extractCalories(meal),
      'cuisine': meal.cuisine ?? '',
      'mealType': meal.mealType ?? '',
      'mealId': mealID,
      'spoonacularID': meal.id.toString(),
      'userId': FirebaseAuth.instance.currentUser!.uid,
      'sourceUrl': meal.sourceUrl ?? '',
    });
  }

  int _extractCalories(Meal meal) {
    try {
      final nutrients = meal.nutrition?['nutrients'] as List?;
      final cal = nutrients?.firstWhere((n) => n['name'] == 'Calories',
          orElse: () => null);
      return (cal?['amount'] as num?)?.toInt() ?? 0;
    } catch (_) {
      return 0;
    }
  }
}
