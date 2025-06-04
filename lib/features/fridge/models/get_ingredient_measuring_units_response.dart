import 'get_ingredient_measuring_unit.dart';

class GetIngredientMeasuringUnitsResponse {
  final String message;
  final List<GetIngredientMeasuringUnit> ingredientMeasuringUnits;

  GetIngredientMeasuringUnitsResponse(this.message, this.ingredientMeasuringUnits);
}
