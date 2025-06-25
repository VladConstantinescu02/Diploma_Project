import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ingredient_model.dart';
import '../services/API/get_ingredients_from_api_service.dart';

final ingredientApiProvider = Provider<SearchIngredientsService>((ref) {
  return SearchIngredientsService();
});

final ingredientSearchProvider =
FutureProvider.autoDispose.family<List<Ingredient>, String>((ref, query) async {
  if (query.trim().isEmpty) return [];
  final api = ref.read(ingredientApiProvider);
  return api.searchIngredients(query: query);
});
