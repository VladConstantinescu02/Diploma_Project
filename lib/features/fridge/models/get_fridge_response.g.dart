import '../../../shared/models/warning.dart';
import 'get_fridge.dart';
import 'get_fridge.g.dart';
import 'get_fridge_ingredient.dart';
import 'get_fridge_response.dart';

final mockFridgeResponse = GetFridgeResponse(
  'Fridge loaded successfully',
  GetFridge(
    'My Fridge',
    [
      GetFridgeIngredient('id1', 'Tomato', 18.0, 2, 'pcs'),
      GetFridgeIngredient('id2', 'Milk', 42.0, 1, 'liters'),
      GetFridgeIngredient('id3', 'Cheese', 402.0, 3, 'kg'),
    ],
    ['allergen1', 'allergen2'],
  ),
  [
    Warning('Low quantity for Milk'),
    Warning('Cheese may expire soon'),
  ],
);
