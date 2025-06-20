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
  List<dynamic>? ingredients;

  bool isSaved;

  Meal({
    required this.id,
    required this.title,
    required this.image,
    this.readyInMinutes,
    this.ingredients,
    this.summary,
    this.nutrition,
    this.instructions,
    this.sourceName,
    this.sourceUrl,
    this.isSaved = false,
  });


  Meal copyWith({
    int? id,
    String? title,
    String? image,
    int? readyInMinutes,
    String? summary,
    Map<String, dynamic>? nutrition,
    String? instructions,
    List<dynamic>? ingredients,
    bool? isSaved,
  }) {
    return Meal(
      id: id ?? this.id,
      title: title ?? this.title,
      image: image ?? this.image,
      readyInMinutes: readyInMinutes ?? this.readyInMinutes,
      summary: summary ?? this.summary,
      nutrition: nutrition ?? this.nutrition,
      instructions: instructions ?? this.instructions,
      ingredients: ingredients ?? this.ingredients,
      isSaved: isSaved ?? this.isSaved, // ← add this if using a flag
    );
  }


  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      readyInMinutes: json['readyInMinutes'],
      summary: json['summary'] ?? '',
      nutrition: json['nutrition'],
      instructions: json['instructions'] ?? '',
      ingredients: json['ingredients'] ?? [],
      sourceName: json['sourceName'] ?? '',
      sourceUrl: json['sourceUrl'] ?? '',
      isSaved: false,
    );
  }
}
