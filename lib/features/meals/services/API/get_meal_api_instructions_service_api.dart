import 'dart:convert';
import 'package:http/http.dart' as http;


class GetMealApiInstructionsService {

  final String _apiKey = 'bc0dd98ec2d8401291e11033be45a64a';
  
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