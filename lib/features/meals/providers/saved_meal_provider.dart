import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/meal_model.dart';

final savedMealsProvider = StateNotifierProvider<SavedMealsNotifier, List<Meal>>(
      (ref) => SavedMealsNotifier(),
);

class SavedMealsNotifier extends StateNotifier<List<Meal>> {
  SavedMealsNotifier() : super([]);

  void saveMeal(Meal meal) {
    if (!state.any((m) => m.id == meal.id)) {
      state = [...state, meal.copyWith(isSaved: true)];
    }
  }

  void removeMeal(Meal meal) {
    state = state.where((m) => m.id != meal.id).toList();
  }

  bool isSaved(Meal meal) => state.any((m) => m.id == meal.id);
}
