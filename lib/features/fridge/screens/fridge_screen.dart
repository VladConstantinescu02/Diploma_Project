import 'package:diploma_prj/features/fridge/widgets/fridge_ingredient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';

import '../providers/fetch_ingredient_info_firebase_service.dart';
import '../widgets/ingredient_search_form.dart';

// Replace with actual colors or use default Material colors
const Color mainColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);

class FridgeScreen extends ConsumerStatefulWidget {
  const FridgeScreen({super.key});

  @override
  ConsumerState<FridgeScreen> createState() => _FridgeScreenState();
}

class _FridgeScreenState extends ConsumerState<FridgeScreen> {
  @override
  Widget build(BuildContext context) {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final asyncItems = ref.watch(userIngredientsProvider(uid));
    return Scaffold(
      backgroundColor: backGroundColor,
        appBar: AppBar(
          centerTitle: false,
          elevation: 0,
          backgroundColor: const Color(0xFFF2A20C),
          foregroundColor: Colors.white,
          title: const Text(
            "Fridge",
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      body: asyncItems.when(
        loading: () => const Center(child: CircularProgressIndicator(
          backgroundColor: backGroundColor,
          valueColor: AlwaysStoppedAnimation(mainColor),
          strokeWidth: 5,
        )),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (items) {
          if (items.isEmpty) {
            // ⬇️  Empty-state UI
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // substitute your own asset / network image if you like
                  Lottie.asset(
                    'lib/utils/images/frideg_screen_animation.json',
                    width: 300,
                    height: 300,
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your fridge is empty',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3C4C59),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tap the + button to add ingredients!',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF3C4C59),
                    ),
                  ),
                ],
              ),
            );
          }

          // ⬇️  Normal list when there are ingredients
          return ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final ing = items[index];
              return FridgeIngredientTile(ingredient: ing);
            },
          );
        },
      ),

      floatingActionButton: FloatingActionButton(
        elevation: 0,
        backgroundColor: const Color(0xFFF2A20C),
        shape: const StadiumBorder(),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => const SearchIngredientForm(),
          );
        },
        child: const Icon(Icons.add, color: Color(0xFFFAFAF9)),
      ),
    );
  }
}
