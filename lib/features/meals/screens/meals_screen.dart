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
  bool _isLoading = false;


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
