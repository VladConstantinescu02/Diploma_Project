class Meal {
  final int id;
  final String title;
  final String image;
  final int? readyInMinutes;
  final String? summary;
  final Map<String, dynamic>? nutrition;
  String? instructions;
  String? sourceName;
  String? sourceUrl;
  String? mealType;
  String? cuisine;
  final String? mealId;
  List<dynamic>? ingredients;

  Meal({
    required this.id,
    required this.title,
    required this.image,
    this.readyInMinutes,
    this.summary,
    this.nutrition,
    this.instructions,
    this.sourceName,
    this.sourceUrl,
    this.ingredients,
    this.cuisine,
    this.mealType,
    this.mealId,
  });

  static const List<String> validMealTypes = [
    'main course',
    'side dish',
    'dessert',
    'appetizer',
    'salad',
    'bread',
    'breakfast',
    'soup',
    'beverage',
    'sauce',
    'marinade',
    'fingerfood',
    'snack',
    'drink',
  ];

  factory Meal.fromJson(Map<String, dynamic> json) {

    String? extractMealType(Map<String, dynamic> j) {
      final rawType = (j['type'] ?? '').toString().toLowerCase();
      if (validMealTypes.contains(rawType)) return rawType;

      final list = (j['dishTypes'] as List?)?.map((e) => e.toString().toLowerCase());
      return list?.firstWhere(
            (e) => validMealTypes.contains(e),
        orElse: () => '',
      );
    }

    return Meal(
      id: json['id'],
      title: json['title'] ?? '',
      image: json['image'] ?? '',
      readyInMinutes: json['readyInMinutes'],
      summary: json['summary'] ?? '',
      nutrition: json['nutrition'],
      instructions: json['instructions'] ?? '',
      ingredients: json['ingredients'] ?? [],
      sourceName: json['sourceName'] ?? '',
      sourceUrl: json['sourceUrl'] ?? '',
      cuisine: json['cuisine'] ?? '',
      mealType: extractMealType(json),
      mealId: json['mealId'] ?? '',
    );
  }

  factory Meal.fromFirestore(Map<String, dynamic> json) {
    return Meal(
      id: int.tryParse(json['spoonacularID']?.toString() ?? '') ?? 0,
      title: json['name'] ?? '',
      image: json['imageURL'] ?? '',
      readyInMinutes: json['readyInMinutes'],
      summary: json['summary'] ?? '',
      nutrition: {
        'nutrients': [
          {
            'name': 'Calories',
            'amount': json['calories'] ?? 0,
          }
        ]
      },
      instructions: json['instructions'] ?? '',
      sourceUrl: json['sourceUrl'] ?? '',
      cuisine: json['cuisine'] ?? '',
      mealType: json['mealType'] ?? '',     // ← reads the correct field
      mealId: json['mealId'] ?? '',
    );
  }
}
