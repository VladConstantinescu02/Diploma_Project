import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../shared/models/search_ingredient.dart';
import '../../shared/errors/result.dart';

final _ingredientsApiClientProvider = Provider<IngredientsApiClient>((ref) {
  return IngredientsApiClient();
});

Provider<IngredientsApiClient> get ingredientsApiClientProvider => _ingredientsApiClientProvider;


class IngredientsApiClient {
  Future<Result<List<SearchIngredient>, Exception>> searchIngredients(String query) async {
    await Future.delayed(Duration(milliseconds: 300)); // simulate API delay

    final mockData = [
      SearchIngredient('1', 'Tomato'),
      SearchIngredient('2', 'Basil'),
      SearchIngredient('3', 'Olive Oil'),
    ];

    final filtered = mockData
        .where((ingredient) => ingredient.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Success(filtered);
  }
}
