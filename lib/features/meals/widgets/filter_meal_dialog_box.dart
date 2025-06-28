import 'dart:developer';

import 'package:diploma_prj/features/meals/widgets/to_int_slider.dart';
import 'package:diploma_prj/shared/widgets/slider_template.dart';
import 'package:diploma_prj/shared/widgets/text_box_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import '../../../shared/widgets/template_text_box_with_flag.dart';
import '../../fridge/providers/get_user_ingredient_list_from_firebase.dart';
import '../services/API/get_meal_api_instructions_service_api.dart';
import '../services/API/get_meal_api_service_api.dart';
import '../services/API/get_meal_find_by_ingredients_api.dart';

const Color mainColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);

class FilerMeal extends ConsumerStatefulWidget {
  const FilerMeal({super.key});

  @override
  FilterMealState createState() => FilterMealState();
}

class FilterMealState extends ConsumerState<FilerMeal> {
  final PageController pageChangeController = PageController();
  final TextEditingController textControllerCuisine = TextEditingController();
  final TextEditingController textControllerDiet = TextEditingController();
  final TextEditingController excludeIngredientController = TextEditingController();
  final TextEditingController textControllerAllergy = TextEditingController();
  final TextEditingController mealTypeController = TextEditingController();
  double minCalories = 500.0;
  double maxCalories = 1500.0;
  double resultCount = 2;

  int onCurrentPage = 0;

  static const String noFridgeItem = "no fridge ingredients";

  List<String> selectedIngredients = [];
  Future<void> returnMealSearch() async {
    final cuisine = textControllerCuisine.text.trim();
    final diet = textControllerDiet.text.trim();
    final intolerance = textControllerAllergy.text.trim();
    final type = mealTypeController.text.trim();

    final excludeIngredients = [
      excludeIngredientController.text.trim(),
    ].where((e) => e.isNotEmpty).join(',');

    final mealService = MealAPIService();
    final ingredientsArg = selectedIngredients.isNotEmpty
        ? selectedIngredients.join(', ')
        : null; // empty → API ignores ingredient filter

    try {
      print("Fetching meals with the following parameters:");
      print("Cuisine: $cuisine");
      print("Diet: $diet");
      print("Intolerance: $intolerance");
      print("Exclude Ingredients: $excludeIngredients");
      print("Ingredients: $ingredientsArg");
      print("Meal Type: $type");
      print("Calories: $minCalories - $maxCalories");

      final results = await mealService.getMeal(
        number: resultCount.toInt(),
        cuisine: cuisine.isEmpty ? null : cuisine,
        diet: diet.isEmpty ? null : diet,
        intolerances: intolerance.isEmpty ? null : intolerance,
        excludeIngredients:
        excludeIngredients.isEmpty ? null : excludeIngredients,
        minCalories: minCalories.toInt(),
        maxCalories: maxCalories.toInt(),
        ingredients: ingredientsArg,
        mealType: type.isEmpty ? null : type,
      );

      if (results == null || results.results.isEmpty) {
        if (kDebugMode) {
          print("No meals found.");
        }
        throw Exception("No meals found.");
      }

      if (type.isEmpty) {
        if (kDebugMode) {
          print("Meal type is empty.");
        }
        throw Exception("Provide meal type");
      }

      final instructionService = GetMealApiInstructionsService();
      final ingredientService = GetMealByIngredient();

      final searchedMeals = await Future.wait(results.results.map((meal) async {
        if (kDebugMode) {
          print("Fetching instructions and ingredients for meal ID: ${meal.id}");
        }
        final instructions = await instructionService.getInstructions(meal.id);
        final ingredients =
        await ingredientService.getByIngredients(ingredientsArg ?? '');

        meal.instructions = instructions ?? 'No instructions available.';
        meal.ingredients = ingredients ?? [];

        return meal;
      }));

      if (!mounted) return;

      if (kDebugMode) {
        print("Navigating to meal select screen with meals: $searchedMeals");
      }
      context.go('/meal_select_screen', extra: searchedMeals);
    } catch (e) {
      if (kDebugMode) {
        print("Error occurred: ${e.toString()}");
      }
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final asyncNames = ref.watch(getUserIngredientListFromFirebase(uid));

    return AlertDialog(
      backgroundColor: const Color(0xFFFAFAF9),
      contentPadding: const EdgeInsets.only(left: 25, right: 25),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(48.0)),
      ),
      content: SizedBox(
        height: 700,
        width: 300,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Lottie.asset(
                'lib/utils/images/search_animation.json',
                width: 100,
                height: 100,
              ),
            ),
            Expanded(
              child: PageView(
                controller: pageChangeController,
                onPageChanged: (int page) {
                  setState(() {
                    onCurrentPage = page;
                  });
                },
                children: [
                  // Page 1
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TemplateTextBoxWithFlag(
                                textBoxController: mealTypeController,
                                textBoxLabel: 'Meal type',
                                textBoxIcon: Icons.info_outline,
                                textLabelColor: darkColor,
                                textBoxFocusedColor: secondaryColor,
                                textBoxStaticColor: mainColor,

                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TemplateControllerTextbox(
                                textBoxController: textControllerCuisine,
                                textBoxLabel: 'Pick a cuisine',
                                textBoxIcon: Icons.language,
                                textLabelColor: darkColor,
                                textBoxFocusedColor: secondaryColor,
                                textBoxStaticColor: mainColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TemplateControllerTextbox(
                                textBoxController: textControllerDiet,
                                textBoxLabel: 'Choose a diet',
                                textBoxIcon: Icons.eco,
                                textLabelColor: darkColor,
                                textBoxFocusedColor: secondaryColor,
                                textBoxStaticColor: mainColor,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  // Page 2
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: TemplateControllerTextbox(
                            textBoxController: textControllerAllergy,
                            textBoxLabel: 'Add your allergy',
                            textBoxIcon: Icons.sick_outlined,
                            textLabelColor: darkColor,
                            textBoxFocusedColor: secondaryColor,
                            textBoxStaticColor: mainColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: TemplateControllerTextbox(
                            textBoxController: excludeIngredientController,
                            textBoxLabel: 'Wish to avoid',
                            textBoxIcon: Icons.directions_run_sharp,
                            textLabelColor: darkColor,
                            textBoxFocusedColor: secondaryColor,
                            textBoxStaticColor: mainColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: kIsWeb
                                ? const EdgeInsets.symmetric(horizontal: 350)
                                : const EdgeInsets.symmetric(horizontal: 25),
                            child: asyncNames.when(
                              loading: () => const CircularProgressIndicator(),
                              error: (e, _) => Text('Error: $e'),
                              data: (names) {
                                final dropdownItems = [noFridgeItem, ...names];

                                return InkWell(
                                  onTap: () async {
                                    // ① start with the current selection
                                    final Set<String> tempSelected =
                                    selectedIngredients.toSet();

                                    final chosen =
                                    await showDialog<Set<String>>(
                                      context: context,
                                      builder: (context) {
                                        return StatefulBuilder(
                                          builder: (context, localSetState) {
                                            return AlertDialog(
                                              backgroundColor: backGroundColor,
                                              title: const Text(
                                                  'Select ingredients'
                                              ),
                                              content: SizedBox(
                                                width: double.maxFinite,
                                                child: ListView(
                                                  shrinkWrap: true,
                                                  children:
                                                  dropdownItems.map((item) {
                                                    final checked = tempSelected
                                                        .contains(item);
                                                    return CheckboxListTile(
                                                      title: Text(item),
                                                      value: checked,
                                                      onChanged: (v) {
                                                        localSetState(() {
                                                          if (item ==
                                                              noFridgeItem) {
                                                            tempSelected
                                                              ..clear()
                                                              ..add(
                                                                  noFridgeItem);
                                                          } else {
                                                            tempSelected.remove(
                                                                noFridgeItem);
                                                            v == true
                                                                ? tempSelected
                                                                .add(item)
                                                                : tempSelected
                                                                .remove(
                                                                item);
                                                          }
                                                        });
                                                      },
                                                    );
                                                  }).toList(),
                                                ),
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context),
                                                  style:
                                                  ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                    const Color(0xFF8B1E3F),
                                                  ), // cancel
                                                  child: const Text(
                                                    'Cancel',
                                                    style: TextStyle(
                                                        color: backGroundColor,
                                                        fontWeight:
                                                        FontWeight.bold),
                                                  ),
                                                ),
                                                ElevatedButton(
                                                  onPressed: () =>
                                                      Navigator.pop(context,
                                                          tempSelected),
                                                  style: ElevatedButton.styleFrom(
                                                      backgroundColor: mainColor
                                                  ),
                                                  child: const Text(
                                                    'Ok',
                                                    style: TextStyle(
                                                      color: backGroundColor,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                    );

                                    if (chosen != null) {
                                      setState(() {
                                        selectedIngredients =
                                        chosen.contains(noFridgeItem)
                                            ? []
                                            : chosen.toList();
                                      });
                                    }
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 18),
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: darkColor, width: 1),
                                      borderRadius: BorderRadius.circular(48),
                                      color: backGroundColor,
                                    ),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            selectedIngredients.isEmpty
                                                ? 'Select ingredients'
                                                : selectedIngredients
                                                .join(', '),
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: darkColor),
                                          ),
                                        ),
                                        const Icon(Icons.arrow_drop_down,
                                            color: darkColor),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SingleChildScrollView(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: TemplateSlider(
                            color: darkColor,
                            divisions: 10,
                            min: 0,
                            max: 1500,
                            initialValue: minCalories,
                            onChanged: (value) =>
                                setState(() => minCalories = value),
                            label: 'Minimum calories',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: TemplateSlider(
                            color: darkColor,
                            divisions: 10,
                            min: 500,
                            max: 2000,
                            initialValue: maxCalories,
                            onChanged: (value) =>
                                setState(() => maxCalories = value),
                            label: 'Maximum calories',
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: ShowIntSlider(
                            color: darkColor,
                            divisions: 10,
                            min: 1,
                            max: 20,
                            initialValue: resultCount,
                            onChanged: (value) =>
                                setState(() => resultCount = value),
                            label: 'No. of results',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  3,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: onCurrentPage == index ? 30 : 8,
                    decoration: BoxDecoration(
                      color: onCurrentPage == index
                          ? const Color(0xFFF2A20C)
                          : const Color(0xFFD5E5F2),
                      borderRadius: BorderRadius.circular(48),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Progress Indicator
            // Button at the bottom
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Row(
                    children: [
                      IconButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: mainColor),
                          onPressed: () {
                            if (onCurrentPage > 0) {
                              pageChangeController.previousPage(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.easeInOut,
                              );
                              setState(() {
                                onCurrentPage--;
                              });
                            }
                          },
                          icon: const Icon(
                            Icons.navigate_before,
                            color: backGroundColor,
                          )),
                      IconButton(
                        onPressed: () {
                          if (onCurrentPage < 2) {
                            pageChangeController.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                            setState(() {
                              onCurrentPage++;
                            });
                          }
                        },
                        icon: const Icon(
                          Icons.navigate_next,
                          color: backGroundColor,
                        ),
                        style: ElevatedButton.styleFrom(
                            backgroundColor: mainColor),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFF2A20C),
                    ),
                    onPressed: returnMealSearch,
                    child: const Text(
                      "Find me a meal!",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFAFAF9),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
