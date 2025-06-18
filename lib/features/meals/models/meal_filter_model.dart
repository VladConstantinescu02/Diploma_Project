class MealFilter {
  String? cuisine;
  String? diet;
  List<String> intolerances;
  List<String> excludeIngredients;
  double? minCalories;
  double? maxCalories;

  MealFilter({
    this.cuisine,
    this.diet,
    this.intolerances = const [],
    this.excludeIngredients = const [],
    this.minCalories,
    this.maxCalories,
  });

  Map<String, String> toApiQuery() {
    return {
      if (cuisine != null && cuisine!.isNotEmpty) 'cuisine': cuisine!,
      if (diet != null && diet!.isNotEmpty) 'diet': diet!,
      if (intolerances.isNotEmpty) 'intolerances': intolerances.join(','),
      if (excludeIngredients.isNotEmpty) 'excludeIngredients': excludeIngredients.join(','),
      if (minCalories != null) 'minCalories': minCalories!.toInt().toString(),
      if (maxCalories != null) 'maxCalories': maxCalories!.toInt().toString(),
    };
  }
}
