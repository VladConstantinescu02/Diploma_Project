import 'package:diploma_prj/features/authentication/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/meal_model.dart';
import '../services/FireStore/save_meals_to_firestore_service.dart';

class MealSelectionScreen extends ConsumerStatefulWidget {
  const MealSelectionScreen({super.key});

  @override
  ConsumerState<MealSelectionScreen> createState() =>
      _MealSelectionScreenState();
}

class _MealSelectionScreenState extends ConsumerState<MealSelectionScreen> {
  List<Meal> _meals = [];
  final bool _isLoading = false;
  String? _error;

  final Set<int> _savedMealIds = {};

  bool _isMealSaved(Meal m) => _savedMealIds.contains(m.id);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final meals = GoRouterState.of(context).extra as List<Meal>?;

    if (meals != null) {
      setState(() {
        _meals = meals;
      });
    }
  }

  List<String> filterHTMLElements(String response) {
    if (RegExp(r"<li>").hasMatch(response)) {
      return RegExp(r"<li>(.*?)</li>",
              dotAll: true) // dotAll ⇒ matches multiline
          .allMatches(response)
          .map((m) => m.group(1)!.trim())
          .toList();
    }
    return [response.trim()];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAF9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3C4C59),
        title: const Text(
          "Select your meal",
          style:
              TextStyle(fontWeight: FontWeight.w600, color: Color(0xFFFAFAF9)),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFF3C4C59),
                foregroundColor: Colors.white,
                side: const BorderSide(width: 1, color: Colors.white),
              ),
              onPressed: () {
                context.go('/meals');
              },
              label: const Text("Go back"),
              icon: const Icon(Icons.navigate_before),
            ),
          )
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : _meals.isEmpty
                  ? const Center(child: Text('Something went wrong.'))
                  : ListView.builder(
                      itemCount: _meals.length,
                      itemBuilder: (context, index) {
                        final meal = _meals[index];
                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                              color: const Color(0xFFFAFAF9),
                              borderRadius: BorderRadius.circular(48),
                              border:
                                  Border.all(color: const Color(0xFF3C4C59))),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(48),
                                          child: Image.network(
                                            meal.image,
                                            width: 100,
                                            height: 100,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                const Icon(Icons.fastfood,
                                                    size: 50),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                meal.title,
                                                style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight:
                                                        FontWeight.w600),
                                              ),
                                              if (meal.readyInMinutes != null)
                                                Text(
                                                    'Ready in: ${meal.readyInMinutes} min'),
                                              if (meal.nutrition != null)
                                                Builder(
                                                  builder: (_) {
                                                    final nutrients = meal
                                                            .nutrition![
                                                        'nutrients'] as List?;
                                                    final calories =
                                                        nutrients?.firstWhere(
                                                                (n) =>
                                                                    n['name'] ==
                                                                    'Calories',
                                                                orElse: () =>
                                                                    null)?[
                                                            'amount'];
                                                    return calories != null
                                                        ? Text(
                                                            'Calories: ${calories.toStringAsFixed(0)} kcal')
                                                        : const SizedBox();
                                                  },
                                                ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    if (meal.instructions != null &&
                                        meal.instructions!.isNotEmpty)
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const Text('Instructions:',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600)),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12),
                                            child: Text(
                                              filterHTMLElements(
                                                      meal.instructions!)
                                                  .join('\n'),
                                              style: const TextStyle(
                                                  fontSize: 13,
                                                  color: Colors.black),
                                            ),
                                          ),
                                        ],
                                      ),
                                    if (meal.sourceName != null &&
                                        meal.sourceName!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Found originally at:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              meal.sourceName!,
                                            ),
                                          ],
                                        ),
                                      ),
                                    if (meal.sourceUrl != null &&
                                        meal.sourceUrl!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 12),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              'Find out more:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              meal.sourceUrl!,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor:
                                            const Color(0xFFF27507),
                                        elevation: 0,
                                      ),
                                      onPressed: _isMealSaved(meal)
                                          ? null // disables the button completely
                                          : () async {
                                              setState(() =>
                                                  _savedMealIds.add(meal.id));

                                              try {
                                                final uid = FirebaseAuth
                                                    .instance.currentUser?.uid;

                                                if (uid == null) {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(
                                                    const SnackBar(
                                                      content: Text(
                                                          "User not logged in."),
                                                      backgroundColor:
                                                          Color(0xFF8B1E3F),
                                                    ),
                                                  );
                                                  return;
                                                }

                                                final saveMealService = ref.read(
                                                    saveToFirestoreMealsServiceProvider);

                                                await saveMealService
                                                    .addMealToFireStore(
                                                        meal: meal,
                                                        userId: uid);
                                              } catch (e) {
                                                if (!context.mounted) return;
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(
                                                  SnackBar(
                                                    content: Text(
                                                        "An unexpected error occurred: $e"),
                                                    backgroundColor:
                                                        const Color(0xFF8B1E3F),
                                                  ),
                                                );
                                              }
                                            },
                                      label: _isMealSaved(
                                              meal) // ④ label reflects state
                                          ? const Text(
                                              'Saved',
                                              style:
                                                  TextStyle(color: darkColor),
                                            )
                                          : const Text(
                                              'Save to account',
                                              style: TextStyle(
                                                  color: backGroundColor),
                                            ),
                                      icon: _isMealSaved(meal)
                                          ? const Icon(
                                              Icons.check,
                                              color: darkColor,
                                            )
                                          : const Icon(
                                              Icons.save,
                                              color: backGroundColor,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
    );
  }
}
