import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/api/fridges_api_client.dart';
import '../../../shared/errors/result.dart';
import '../../../shared/providers/fridges_api_client_provider.dart';
import '../models/add_fridge_ingredient.dart';
import '../models/add_fridge_ingredient_response.dart';
import '../models/delete_fridge_ingredient_response.dart';
import '../models/fridge_state.dart';
import '../models/get_fridge_response.dart';

class Fridge extends AutoDisposeAsyncNotifier<FridgeState> {
  FridgesApiClient get _fridgesApiClient =>
      ref.watch(fridgesApiClientProvider);

  Future<void> getFridge() async {
    state = const AsyncLoading();

    final result = await _fridgesApiClient.getFridge();

    if (result is Success<GetFridgeResponse, Exception>) {
      final fridge = result.value.fridge;
      final fridgeState = FridgeState(fridge, result.value.warnings);
      state = AsyncValue.data(fridgeState);
    } else {
      state = AsyncValue.data(FridgeState.defaultState());
    }
  }

  Future<void> addFridgeIngredient(AddFridgeIngredient addFridgeIngredient) async {
    state = const AsyncLoading();

    final result = await _fridgesApiClient.addFridgeIngredient(addFridgeIngredient);

    if (result is Success<AddFridgeIngredientResponse, Exception>) {
      ref.invalidateSelf();
      await future;
    }
  }

  Future<void> updateFridgeIngredient(AddFridgeIngredient addFridgeIngredient) async {
    state = const AsyncLoading();

    final result = await _fridgesApiClient.updateFridgeIngredient(addFridgeIngredient);

    if (result is Success<AddFridgeIngredientResponse, Exception>) {
      ref.invalidateSelf();
      await future;
    }
  }

  Future<void> deleteFridgeIngredient(String fridgeIngredientId) async {
    state = const AsyncLoading();

    final result = await _fridgesApiClient.deleteFridgeIngredient(fridgeIngredientId);

    if (result is Success<DeleteFridgeIngredientResponse, Exception>) {
      ref.invalidateSelf();
      await future;
    }
  }

  @override
  Future<FridgeState> build() async {
    final result = await _fridgesApiClient.getFridge();

    if (result is Success<GetFridgeResponse, Exception>) {
      final fridge = result.value.fridge;
      final fridgeState = FridgeState(fridge, result.value.warnings);
      return fridgeState;
    }

    return FridgeState.defaultState();
  }
}

/// ✅ Manual provider declaration (no codegen needed)
final fridgeProvider = AutoDisposeAsyncNotifierProvider<Fridge, FridgeState>(
  Fridge.new,
);
