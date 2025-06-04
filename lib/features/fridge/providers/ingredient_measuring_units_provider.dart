import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/api/fridges_api_client.dart';
import '../../../shared/errors/result.dart';
import '../../../shared/providers/fridges_api_client_provider.dart';
import '../models/get_ingredient_measuring_unit.dart';
import '../models/get_ingredient_measuring_units_response.dart';

final ingredientMeasuringUnitsProvider =
FutureProvider.autoDispose<List<GetIngredientMeasuringUnit>>((ref) async {
  final fridgesApi = ref.watch(fridgesApiClientProvider);
  final result = await fridgesApi.getIngredientMeasuringUnits();

  if (result is Success<GetIngredientMeasuringUnitsResponse, Exception>) {
    return result.value.ingredientMeasuringUnits;
  } else {
    return [];
  }
});
