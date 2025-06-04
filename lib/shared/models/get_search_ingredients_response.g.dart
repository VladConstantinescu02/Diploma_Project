import 'package:diploma_prj/shared/models/search_ingredient.dart';

import 'get_search_ingredients_response.dart';

Future<GetSearchIngredientsResponse> getMockSearchResults(String query) async {
  await Future.delayed(Duration(milliseconds: 300)); // simulate delay
  final all = [
    SearchIngredient('ing1', 'Tomato'),
    SearchIngredient('ing2', 'Cheddar Cheese'),
    SearchIngredient('ing3', 'Milk'),
    SearchIngredient('ing4', 'Butter'),
  ];
  final filtered = all.where((ing) => ing.name.toLowerCase().contains(query.toLowerCase())).toList();
  return GetSearchIngredientsResponse(filtered);
}
