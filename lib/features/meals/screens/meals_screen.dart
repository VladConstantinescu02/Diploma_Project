import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal_model.dart';
import '../providers/fetch_meal_information.dart';
import '../widgets/display_meal_card.dart';
import '../widgets/filter_meal_dialog_box.dart';

final firestoreMealServiceProvider = Provider<FirestoreFetchMealInformation>((ref) {
  return FirestoreFetchMealInformation();
});

final userMealsProvider = StreamProvider.family<List<Meal>, String>((ref, userId) {
  final service = ref.read(firestoreMealServiceProvider);
  return service.getMeals(userId);
});

class MealScreen extends ConsumerStatefulWidget {
  const MealScreen({super.key});

  @override
  MealScreenState createState() => MealScreenState();
}

class MealScreenState extends ConsumerState<MealScreen> {

  @override
  Widget build(BuildContext context)  {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final mealsAsync = ref.watch(userMealsProvider(userId));

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
      body: mealsAsync.when(
        data: (meals) => ListView.builder(
          itemCount: meals.length,
          itemBuilder: (context, index) {
            try {
              final meal = meals[index];
              return DisplayMealCard(meal: meal);
            } catch (e) {
              return ListTile(
                title: const Text('Failed to load meal'),
                subtitle: Text('Error: $e'),
              );
            }
          },
        ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error to check: $e')),
      ),
      floatingActionButton: FloatingActionButton.extended(
        elevation: 0,
        backgroundColor: const Color(0xFFF27507),
        shape: const StadiumBorder(
          side: BorderSide(color: Colors.transparent),
        ),
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) => const FilerMeal(),
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
