import '../../features/fridge/models/add_fridge_ingredient.dart';
import '../../features/fridge/models/add_fridge_ingredient_response.dart';
import '../../features/fridge/models/delete_fridge_ingredient_response.dart';
import '../../features/fridge/models/get_fridge.dart';
import '../../features/fridge/models/get_fridge.g.dart';
import '../../features/fridge/models/get_fridge_ingredient.dart';
import '../../features/fridge/models/get_fridge_response.dart';
import '../../features/fridge/models/get_ingredient_measuring_unit.dart';
import '../../features/fridge/models/get_ingredient_measuring_units_response.dart';
import '../errors/result.dart';
import '../models/warning.dart';

class FridgesApiClient {
  // Dummy constructor for mock API
  FridgesApiClient(String _, dynamic __, String ___);

  Future<Result<GetFridgeResponse, Exception>> getFridge() async {
    try {
      await Future.delayed(Duration(milliseconds: 500));

      final fridge = GetFridge(
        'My Fridge',
        [
          GetFridgeIngredient('id1', 'Tomato', 18.0, 2, 'pcs'),
          GetFridgeIngredient('id2', 'Milk', 42.0, 1, 'liters'),
          GetFridgeIngredient('id3', 'Cheese', 402.0, 3, 'kg'),
        ],
        ['allergen1', 'allergen2'],
      );

      final response = GetFridgeResponse(
        'Fridge loaded successfully',
        fridge,
        [
          Warning('Low stock: Milk'),
          Warning('Cheese may expire soon'),
        ],
      );

      return Success(response);
    } catch (e) {
      return Failure(Exception("Mocked error"));
    }
  }

  Future<Result<DeleteFridgeIngredientResponse, Exception>> deleteFridgeIngredient(
      String fridgeIngredientId) async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      final response = DeleteFridgeIngredientResponse("Ingredient deleted: $fridgeIngredientId");
      return Success(response);
    } catch (e) {
      return Failure(Exception("Mocked delete error"));
    }
  }

  Future<Result<AddFridgeIngredientResponse, Exception>> addFridgeIngredient(
      AddFridgeIngredient addFridgeIngredient) async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      final response = AddFridgeIngredientResponse("Ingredient added: ${addFridgeIngredient.ingredientId}");
      return Success(response);
    } catch (e) {
      return Failure(Exception("Mocked add error"));
    }
  }

  Future<Result<AddFridgeIngredientResponse, Exception>> updateFridgeIngredient(
      AddFridgeIngredient addFridgeIngredient) async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      final response = AddFridgeIngredientResponse("Ingredient updated: ${addFridgeIngredient.ingredientId}");
      return Success(response);
    } catch (e) {
      return Failure(Exception("Mocked update error"));
    }
  }

  Future<Result<GetIngredientMeasuringUnitsResponse, Exception>> getIngredientMeasuringUnits() async {
    try {
      await Future.delayed(Duration(milliseconds: 300));
      final response = GetIngredientMeasuringUnitsResponse(
        'Units loaded successfully',
        [
          GetIngredientMeasuringUnit(1, 'Liter', 'liters'),
          GetIngredientMeasuringUnit(2, 'Piece', 'pcs'),
          GetIngredientMeasuringUnit(3, 'Kilogram', 'kg'),
        ],
      );
      return Success(response);
    } catch (e) {
      return Failure(Exception("Mocked unit fetch error"));
    }
  }
}