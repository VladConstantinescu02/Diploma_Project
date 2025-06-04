import 'get_ingredient_measuring_unit.dart';
import 'get_ingredient_measuring_units_response.dart';

final mockGetIngredientMeasuringUnitsResponse = GetIngredientMeasuringUnitsResponse(
  'Units retrieved successfully',
  [
    GetIngredientMeasuringUnit(1, 'Liter', 'liters'),
    GetIngredientMeasuringUnit(2, 'Piece', 'pcs'),
    GetIngredientMeasuringUnit(3, 'Kilogram', 'kg'),
  ],
);

