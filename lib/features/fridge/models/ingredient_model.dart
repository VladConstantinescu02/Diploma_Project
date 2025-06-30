class Ingredient {
  // --- Fields you store ------------------------------------------------------
  final int id; // id from Spoonacular search
  final String name; // ingredient name
  final double amount; // user-entered quantity
  final String unit; // user-chosen unit (g, ml, piece …)
  final String userId; // owner
  final double nutrition; // optional: “100 kcal / 100 g” etc.

  Ingredient({
    required this.id,
    required this.name,
    required this.amount,
    required this.unit,
    required this.userId,
    required this.nutrition,
  });

  // --------------------------------------------------------------------------
  // Construct from Spoonacular SEARCH + user input
  // (Before it’s saved you usually don’t have ingredientId yet.)
  // --------------------------------------------------------------------------
  factory Ingredient.fromSearch({
    required int id,
    required String name,
    required double amount,
    required String unit,
    required String userId,
    required double nutrition,
  }) {
    return Ingredient(
      // will be filled after Firestore .add()
      id: id,
      name: name,
      amount: amount,
      unit: unit,
      userId: userId,
      nutrition: nutrition,
    );
  }

  factory Ingredient.fromFirestore(Map<String, dynamic> json, String docId) {
    return Ingredient(
      id: json['ingredientId'] as int,
      name: json['name'] as String,
      amount: (json['quantity'] as num).toDouble(),
      unit: json['unit'] as String,
      userId: json['userId'] as String,
      nutrition: (json['nutrition'] as num).toDouble(),
    );
  }


  Map<String, dynamic> toFirestore() =>
      {
        'ingredientId': id,
        'name': name,
        'quantity': amount,
        'unit': unit,
        'userId': userId,
        'nutrition': nutrition,
      };

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      amount: 0.0,
      unit: '',
      userId: '',
      nutrition: 0.0,
    );
  }

}