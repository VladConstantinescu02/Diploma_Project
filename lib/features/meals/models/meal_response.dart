import 'meal_model.dart';

class MealResponse {
  List<Meal> results;

  MealResponse({required this.results});

  factory MealResponse.fromJson(Map<String, dynamic> json) {
    return MealResponse(
      results: (json['results'] as List)
          .map((item) => Meal.fromJson(item))
          .toList(),
    );
  }
}
