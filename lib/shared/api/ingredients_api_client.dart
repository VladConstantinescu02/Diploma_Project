import 'dart:async';
import '../errors/result.dart';
import '../models/search_ingredient.dart';

class IngredientsApiClient {
  IngredientsApiClient(); // Empty constructor for mock use

  Future<Result<List<SearchIngredient>, Exception>> searchIngredients(String query) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simulate API delay

    final mockData = [
      SearchIngredient('1', 'Tomato'),
      SearchIngredient('2', 'Basil'),
      SearchIngredient('3', 'Olive Oil'),
      SearchIngredient('4', 'Milk'),
      SearchIngredient('5', 'Cheese'),
    ];

    final filtered = mockData
        .where((ingredient) => ingredient.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Success(filtered);
  }
}
