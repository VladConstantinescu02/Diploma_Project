import 'package:diploma_prj/features/fridge/models/ingredient_model.dart';
import 'package:diploma_prj/features/fridge/providers/fetch_ingredient_info_firebase_service.dart';
import 'package:diploma_prj/features/fridge/providers/ingredient_search_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final filteredIngredientSearchProvider =
    FutureProvider.family<List<Ingredient>, ({String query, String userId})>(
        (ref, parameters) async {
  final query = parameters.query.trim();
  if (query.isEmpty) return [];

  final apiResults = await ref
      .read(ingredientApiProvider)
      .searchIngredients(query: parameters.query);

  final userFridge =  await ref.watch(userIngredientsProvider(parameters.userId).future);

  final existingIngredientId = userFridge.map((i) => i.id).toSet();

  return apiResults.where((item) => !existingIngredientId.contains(item.id)).toList();

});
