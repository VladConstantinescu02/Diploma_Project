import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../../models/meal_response.dart';

class MealAPIService {
  final String _apiKey = dotenv.env["API_KEY"]!;

  Future<MealResponse?> getMeal({
    int? number,
    String? mealType,
    String? cuisine,
    String? diet,
    String? intolerances,
    String? excludeIngredients,
    String? information,
    int? minCalories,
    int? maxCalories,
    int? maxReadyTime,
    List? fetchedIngredients,
    String? ingredients,
  }) async {
    final queryParameters = {
      'apiKey': _apiKey,
      if (number != null) 'number': '$number',
      if (mealType != null) 'type': mealType,
      if (cuisine != null) 'cuisine': cuisine,
      if (diet != null) 'diet': diet,
      if (intolerances != null) 'intolerances': intolerances,
      if (excludeIngredients != null) 'excludeIngredients': excludeIngredients,
      if (minCalories != null || maxCalories != null)
        'addRecipeNutrition': 'true',
      if (minCalories != null) 'minCalories': '$minCalories',
      if (maxCalories != null) 'maxCalories': '$maxCalories',
      if (maxReadyTime != null) 'maxReadyTime': '$maxReadyTime',
      if (ingredients != null && ingredients.isNotEmpty) // <-- Add this
        'includeIngredients': ingredients,
      'addRecipeInformation': 'true',
    };

    final uri = Uri.https(
        'api.spoonacular.com', '/recipes/complexSearch', queryParameters);

    try {
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final rawData = jsonDecode(response.body);
        final parsed = MealResponse.fromJson(rawData);

        if (minCalories != null || maxCalories != null) {
          parsed.results = parsed.results.where((meal) {
            final nutrition = meal.nutrition;
            if (nutrition == null) return false;

            final calories = nutrition['nutrients']?.firstWhere(
                (n) => n['name'] == 'Calories',
                orElse: () => null)?['amount'];

            if (calories == null || calories is! num) return false;

            return (minCalories == null || calories >= minCalories) &&
                (maxCalories == null || calories <= maxCalories);
          }).toList();
        }

        return parsed;
      } else {
        if (kDebugMode) print('Failed: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      if (kDebugMode) print('Error: $e');
      return null;
    }
  }
}
