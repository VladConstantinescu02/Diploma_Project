import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import '../models/meal_model.dart';
import '../providers/fetch_meal_information.dart';
import '../widgets/display_meal_card.dart';
import '../widgets/filter_meal_dialog_box.dart';

final firestoreMealServiceProvider =
    Provider<FirestoreFetchMealInformation>((ref) {
  return FirestoreFetchMealInformation();
});

final userMealsProvider =
    StreamProvider.family<List<Meal>, String>((ref, userId) {
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
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid ?? '';
    final mealsAsync = ref.watch(userMealsProvider(userId));

    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
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
        data: (meals) {
          if (meals.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'lib/utils/images/search_animation.json',
                    width: 300,
                    height: 300,
                  ),
                  const Text(
                    'No meals found',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'Use the button below to add some',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            );
          }

          // Scrollable list of meals
          return ListView.builder(
            padding: const EdgeInsets.all(12),
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
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Failed to load your meals.\n\nError: $e',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
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
