class GetFridgeIngredient {
  final String ingredientId;
  final String name;
  final double quantity;
  final int measuringUnitId;
  final String ingredientMeasuringUnitSuffix;
  final double? caloriesPer100Grams; // optional

  GetFridgeIngredient(
      this.ingredientId,
      this.name,
      this.quantity,
      this.measuringUnitId,
      this.ingredientMeasuringUnitSuffix, {
        this.caloriesPer100Grams,
      });
}
