import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;


class GetMealApiInstructionsService {

  final String _apiKey = dotenv.env["API_KEY"]!;
  
  Future<String?> getInstructions(int mealId) async {
    final uri = Uri.https('api.spoonacular.com', '/recipes/$mealId/information', {
      'apiKey': _apiKey,
    });

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['instructions'];
    }
    return null;
  }
  
}