import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/ingredient_model.dart';



class SearchIngredientsService {

  final String _apiKey = 'bc0dd98ec2d8401291e11033be45a64a';

  Future<List<Ingredient>> searchIngredients({
    required String query,
    int number = 5,
  }) async {
    final uri = Uri.https(
      'api.spoonacular.com',
      '/food/ingredients/search',
      {
        'apiKey': _apiKey,
        'query': query,
        'number': number.toString(),
      },
    );

    final result = await http.get(uri);
    if (result.statusCode != 200) throw Exception('Spoonacular error ${result.statusCode}');

    final data = jsonDecode(result.body);
    final results = (data['results'] as List)
        .map((e) => Ingredient.fromJson(e))
        .toList();

    return results;
  }


}