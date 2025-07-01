import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class GetMealByIngredient {
  final String _apiKey = dotenv.env["API_KEY"]!;

  Future<List<dynamic>?> getByIngredients(String ingredients) async {
    final uri = Uri.https('api.spoonacular.com', '/recipes/findByIngredients', {
      'apiKey': _apiKey,
      'ingredients': ingredients,
    });

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data; // List of meals (JSON objects)
    } else {
      if (kDebugMode) {
        print("Error: ${response.statusCode}");
      }
      return null;
    }
  }
}
