import 'package:flutter/material.dart';
import '../models/meal_model.dart';
import '../widgets/filter_meal_dialog_box.dart';

class MealScreen extends StatefulWidget {
  const MealScreen({super.key});

  @override
  State<MealScreen> createState() => _MealScreenState();
}

class _MealScreenState extends State<MealScreen> {
//  final MealAPIService _apiService = MealAPIService();
  List<Meal> _meals = [];
  bool _isLoading = false;
  String? _error;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFFF2A20C),
        foregroundColor: Colors.white,
        title: const Text(
          "Meals",
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
          ? Center(child: Text(_error!))
          : _meals.isEmpty
          ? const Center(child: Text('No meals yet. Tap "Add meal".'))
          : ListView.builder(
        itemCount: _meals.length,
        itemBuilder: (context, index) {
          final meal = _meals[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: ListTile(
              contentPadding: const EdgeInsets.all(12),
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.network(
                  meal.image,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => const Icon(Icons.fastfood),
                ),
              ),
              title: Text(
                meal.title,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (meal.readyInMinutes != null)
                    Text('Ready in: ${meal.readyInMinutes} min'),

                  if (meal.nutrition != null)
                    Builder(builder: (_) {
                      final nutrients = meal.nutrition!['nutrients'] as List?;
                      final calories = nutrients
                          ?.firstWhere((n) => n['name'] == 'Calories', orElse: () => null)?['amount'];
                      return calories != null
                          ? Text('Calories: ${calories.toStringAsFixed(0)} kcal')
                          : const SizedBox();
                    }),

                  if (meal.instructions != null && meal.instructions!.isNotEmpty)
                    Text(
                      'Instructions: ${meal.instructions}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                ],
              ),
              isThreeLine: true,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: const Color(0xFFF27507),
        shape: const StadiumBorder(side: BorderSide(color: Colors.transparent)),
        onPressed: () async {
          setState(() => _isLoading = true);

          final List<Meal>? filteredMeals = await showDialog<List<Meal>>(
            context: context,
            builder: (_) => const FilerMeal(),
          );

          if (filteredMeals != null) {
            setState(() {
              _meals = filteredMeals;
              _error = null;
            });
          }

          setState(() => _isLoading = false);
        },
        label: const Text(
          'Add meal',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
