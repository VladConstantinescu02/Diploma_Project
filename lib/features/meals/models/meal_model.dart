class Meal {
  final int id;
  final String title;
  final String image;
  final int? readyInMinutes;
  final String? instructions;
  final Map<String, dynamic>? nutrition;

  Meal({
    required this.id,
    required this.title,
    required this.image,
    this.readyInMinutes,
    this.instructions,
    this.nutrition,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      readyInMinutes: json['readyInMinutes'],
      instructions: json['instructions'],
      nutrition: json['nutrition'],
    );
  }
}
