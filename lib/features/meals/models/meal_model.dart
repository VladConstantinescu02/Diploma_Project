class Meal {
  final int id;
  final String title;
  final String image;
  final int? readyInMinutes;
  final String? summary;
  final Map<String, dynamic>? nutrition;
  String? instructions;

  Meal({
    required this.id,
    required this.title,
    required this.image,
    this.readyInMinutes,
    this.summary,
    this.nutrition,
    this.instructions,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    return Meal(
      id: json['id'],
      title: json['title'],
      image: json['image'],
      readyInMinutes: json['readyInMinutes'],
      summary: json['summary'] ?? '',
      nutrition: json['nutrition'] ,
      instructions: json['instructions'] ?? '',
    );
  }
}
