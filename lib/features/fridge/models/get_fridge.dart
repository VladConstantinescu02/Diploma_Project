import 'get_fridge.g.dart';
import 'get_fridge_ingredient.dart';

class GetFridge {
  final String? fridgeName;
  final List<GetFridgeIngredient>? fridgeIngredients;
  final List<String>? fridgeAlergensIds;

  GetFridge(this.fridgeName, this.fridgeIngredients, this.fridgeAlergensIds);
}
