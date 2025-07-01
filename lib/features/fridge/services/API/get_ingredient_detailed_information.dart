import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class IngredientInfoService {
  final String _apiKey = dotenv.env["API_KEY"]!;

  Future<List<String>> fetchPossibleUnits(int ingredientId) async {
    final uri = Uri.https(
      'api.spoonacular.com',
      '/food/ingredients/$ingredientId/information',
      {'apiKey': _apiKey},
    );

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final units = data['possibleUnits'];
      if (units is List) {
        return units.cast<String>();
      }
    }

    throw Exception('Failed to fetch units for ingredient $ingredientId');
  }

  Future<double?> fetchCalories(
      int ingredientId, double amount, String unit) async {
    final uri = Uri.https(
      'api.spoonacular.com',
      '/food/ingredients/$ingredientId/information',
      {
        'amount': amount.toString(),
        'unit': unit,
        'apiKey': _apiKey,
      },
    );

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final nutrients = data['nutrition']?['nutrients'];

      if (nutrients is List) {
        final calorieData = nutrients.firstWhere(
              (n) => n['name'] == 'Calories',
          orElse: () => null,
        );
        return calorieData != null ? calorieData['amount']?.toDouble() : null;
      }
    }

    return null;
  }


}
