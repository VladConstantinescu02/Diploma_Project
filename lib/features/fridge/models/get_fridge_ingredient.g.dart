import 'get_fridge.dart';
import 'get_fridge.g.dart';
import 'get_fridge_ingredient.dart';

final mockFridge = GetFridge(
      'My Fridge',
      [
            GetFridgeIngredient('id1', 'Tomato', 18.0, 2, 'pcs'),
            GetFridgeIngredient('id2', 'Milk', 42.0, 1, 'liters'),
            GetFridgeIngredient('id3', 'Cheese', 402.0, 3, 'kg'),
      ],
      ['allergen1', 'allergen2'],
);
