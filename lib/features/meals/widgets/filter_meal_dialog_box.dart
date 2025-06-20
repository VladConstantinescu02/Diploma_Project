import 'package:diploma_prj/features/meals/widgets/to_int_slider.dart';
import 'package:diploma_prj/shared/widgets/slider_template.dart';
import 'package:diploma_prj/shared/widgets/text_box_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../services/get_meal_api_instructions_service.dart';
import '../services/get_meal_api_service.dart';

const Color mainColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);

class FilerMeal extends StatefulWidget {
  const FilerMeal({super.key});

  @override
  FilterMealState createState() => FilterMealState();
}

class FilterMealState extends State<FilerMeal> {
  final PageController _pageController = PageController();
  final TextEditingController _controllerCuisine = TextEditingController();
  final TextEditingController _controllerDiet = TextEditingController();
  final TextEditingController _controllerExclude = TextEditingController();
  final TextEditingController _controllerAllergy = TextEditingController();
  final TextEditingController _dishType = TextEditingController();
  double _minCalories = 500.0;
  double _maxCalories = 1500.0;
  double _resultCount = 2;

  int _currentPage = 0;

  final List<IconData> scrollPageIcons = [
    Icons.local_grocery_store_outlined,
    Icons.filter_list,
  ];

  Future<void> _returnMealSearch() async {
    const excludeAlcoholIngredients =
        "vodka,rum,whiskey,brandy,beer,tequila,bourbon,cognac";

    final keywords = [
      'vodka',
      'rum',
      'whiskey',
      'brandy',
      'beer',
      'tequila',
      'bourbon',
      'cognac',
      'wine'
    ];

    final cuisine = _controllerCuisine.text.trim();
    final diet = _controllerDiet.text.trim();
    final intolerance = _controllerAllergy.text.trim();

    final excludeIngredients = [
      _controllerExclude.text.trim(),
      excludeAlcoholIngredients
    ].where((e) => e.isNotEmpty).join(',');

    // Use these to call your API
    final mealService = MealAPIService();

    try {
      final results = await mealService.getMeal(
        number: _resultCount.toInt(),
        cuisine: cuisine.isEmpty ? null : cuisine,
        diet: diet.isEmpty ? null : diet,
        intolerances: intolerance.isEmpty ? null : intolerance,
        excludeIngredients:
            excludeIngredients.isEmpty ? null : excludeIngredients,
        minCalories: _minCalories.toInt(),
        maxCalories: _maxCalories.toInt(),
      );

      if (results == null) {
        throw Exception("No meals found.");
      }

      final instructionService = GetMealApiInstructionsService();

      final filtered = results.results.where((meal) {
        final title = meal.title.toLowerCase();
        return !keywords.any((word) => title.contains(word));
      }).toList();

      for (final meal in filtered) {
        final instructions = await instructionService.getInstructions(meal.id);
        meal.instructions = instructions ?? 'No instructions available.';
      }

      if (filtered.isEmpty) {
        throw Exception("No meals found (alcohol is filtered).");
      }

      if (!mounted) return;

      context.go('/meal_select_screen', extra: filtered);
    } catch (e) {
      if (!mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFFFAFAF9),
      contentPadding: const EdgeInsets.only(left: 25, right: 25),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(48.0)),
      ),
      content: SizedBox(
        height: 600,
        width: 300,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Text(
                "Lets find a meal!",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: mainColor,
                  fontSize: 30,
                ),
              ),
            ),
            // Progress Indicator
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  2,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 60,
                    width: _currentPage == index ? 60 : 60,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? const Color(0xFFF2A20C)
                          : const Color(0xFFD5E5F2),
                      borderRadius: BorderRadius.circular(48),
                    ),
                    child: Icon(scrollPageIcons[index],
                        color: _currentPage == index
                            ? const Color(0xFFFAFAF9)
                            : Colors.transparent),
                  ),
                ),
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (int page) {
                  setState(() {
                    _currentPage = page;
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
                              child: TemplateControllerTextbox(
                                textBoxController: _dishType,
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
                                textBoxController: _controllerCuisine,
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
                                textBoxController: _controllerDiet,
                                textBoxLabel: 'Choose a diet',
                                textBoxIcon: Icons.eco,
                                textLabelColor: darkColor,
                                textBoxFocusedColor: secondaryColor,
                                textBoxStaticColor: mainColor,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: TemplateControllerTextbox(
                                textBoxController: _controllerAllergy,
                                textBoxLabel: 'Add your allergy',
                                textBoxIcon: Icons.sick_outlined,
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
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: TemplateControllerTextbox(
                            textBoxController: _controllerExclude,
                            textBoxLabel: 'Wish to avoid',
                            textBoxIcon: Icons.directions_run_sharp,
                            textLabelColor: darkColor,
                            textBoxFocusedColor: secondaryColor,
                            textBoxStaticColor: mainColor,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: TemplateSlider(
                            color: darkColor,
                            divisions: 10,
                            min: 0,
                            max: 1500,
                            initialValue: _minCalories,
                            onChanged: (value) =>
                                setState(() => _minCalories = value),
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
                            initialValue: _maxCalories,
                            onChanged: (value) =>
                                setState(() => _maxCalories = value),
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
                            initialValue: _resultCount,
                            onChanged: (value) =>
                                setState(() => _resultCount = value),
                            label: 'No. of results',
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            // Progress Indicator
            // Button at the bottom
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFF2A20C),
                    ),
                    onPressed: _returnMealSearch,
                    child: const Text(
                      "Find me a meal!",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFFAFAF9),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
