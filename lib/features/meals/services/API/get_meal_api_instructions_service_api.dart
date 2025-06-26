import 'dart:convert';
import 'package:http/http.dart' as http;


class GetMealApiInstructionsService {

  final String _apiKey = '1a39e08ed50746588fa1e4833137c6e3';
  
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