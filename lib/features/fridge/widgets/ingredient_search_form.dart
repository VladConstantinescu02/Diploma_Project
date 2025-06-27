import 'dart:async';

import 'package:diploma_prj/features/fridge/widgets/save_ingredient_dailog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/widgets/template_text_box_with_flag.dart';
import '../models/ingredient_model.dart';
import '../providers/filtered_ingredient_search_provider.dart';
import '../services/API/get_ingredient_detailed_information.dart';
import '../services/API/get_ingredients_from_api_service.dart';
import '../services/Firestore/save_ingredient_to_firestore_service.dart';

const Color thirdColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);
const Color mainColor = Color(0xFFF2A20C);

class SearchIngredientForm extends ConsumerStatefulWidget {
  const SearchIngredientForm({super.key});

  @override
  ConsumerState<SearchIngredientForm> createState() =>
      SearchIngredientFormState();
}

class SearchIngredientFormState extends ConsumerState<SearchIngredientForm> {
  final searchTextInput = TextEditingController();
  final searchIngredientService = SearchIngredientsService();
  final IngredientInfoService _infoService = IngredientInfoService();

  static const List<String> sanitizedUnits = [
    // Weight
    'g',
    'kg',
    'oz',
    'lb',

    // Volume
    'ml',
    'l',
    'tsp',
    'tbsp',
    'cup',

    // Countable / portion
    'piece',
    'serving',
    'slice',
    'unit',
  ];

  List<Ingredient> searchResults = [];
  bool isLoading = false;

  Timer? await; // <-- NEW

  String? _validateText(String value) {
    if (value.isEmpty) return 'Keep searching.';
    return null;
  }

  @override
  void initState() {
    super.initState();

    // Listen for text changes
    searchTextInput.addListener(expectedInputResponse);
  }

  @override
  void dispose() {
    await?.cancel();
    searchTextInput.dispose();
    super.dispose();
  }

  void expectedInputResponse() {
    final query = searchTextInput.text.trim();

    // Cancel the previous debounce timer
    await?.cancel();

    // Don’t search for very short input
    if (query.length < 2) {
      setState(() => searchResults = []);
      return;
    }

    // Start a new debounce timer
    await = Timer(const Duration(milliseconds: 350), () async {
      setState(() => isLoading = true);

      try {
        final results =
            await searchIngredientService.searchIngredients(query: query);
        setState(() => searchResults = results);
      } catch (e) {
        debugPrint('Search error: $e');
      } finally {
        if (mounted) setState(() => isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final queryText = searchTextInput.text;

    final filteredResults = ref.watch(
      filteredIngredientSearchProvider((query: queryText, userId: uid)),
    );
    return Container(
      height: 500,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: backGroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(48)),
      ),
      child: Column(
        children: [
          TemplateTextBoxWithFlag(
            textBoxLabel: 'Find your ingredient',
            textBoxIcon: Icons.search,
            textLabelColor: darkColor,
            textBoxFocusedColor: secondaryColor,
            textBoxStaticColor: darkColor,
            onValidate: _validateText,
            textBoxController: searchTextInput,
          ),
          const SizedBox(height: 12),

          // Suggestions
          Expanded(
            child: filteredResults.when(
              loading: () => const Center(
                  child: CircularProgressIndicator(
                backgroundColor: secondaryColor,
                valueColor: AlwaysStoppedAnimation(mainColor),
              )),
              error: (err, _) => Center(child: Text('Error: $err')),
              data: (results) {
                if (results.isEmpty) {
                  return const Center(child: Text('No ingredients found yet'));
                }

                return ListView.separated(
                  itemCount: results.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final ing = results[i];
                    return ListTile(
                      title: Text(ing.name),
                      onTap: () async {
                        try {
                          final responseUnits =
                              await _infoService.fetchPossibleUnits(ing.id);
                          const units = sanitizedUnits;

                          if (!context.mounted) return;
                          final completeIngredient =
                              await showDialog<Ingredient>(
                            context: context,
                            builder: (_) => SaveIngredientDialogBox(
                              partialIngredient: ing,
                              units: units,
                            ),
                          );

                          if (completeIngredient != null && context.mounted) {
                            final saveService =
                                ref.read(saveIngredientsToFirestoreProvider);
                            await saveService.addIngredientToFirestore(
                                ingredient: completeIngredient);
                          }
                        } catch (e) {
                          debugPrint('Error saving ingredient: $e');
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Something went wrong'),
                                backgroundColor: Color(0xFF8B1E3F),
                              ),
                            );
                          }
                        }
                      },
                    );
                  },
                );
              },
            ),
          ),

          // Close button
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: mainColor,
              elevation: 0,
            ),
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close_rounded, color: backGroundColor),
            label:
                const Text("Close", style: TextStyle(color: backGroundColor)),
          ),
        ],
      ),
    );
  }
}
