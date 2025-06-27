import 'package:diploma_prj/features/fridge/widgets/fridge_ingredient.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/fetch_ingredient_info_firebase_service.dart';
import '../widgets/ingredient_search_form.dart';

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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('Error: $e')),
          data: (items) => ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final ing = items[index];
              return FridgeIngredientTile(ingredient: ing);
            }
          ),
        ),
        floatingActionButton: FloatingActionButton(
          elevation: 0,
          backgroundColor: const Color(0xFFF2A20C),
          shape: const StadiumBorder(
            side: BorderSide(color: Colors.transparent),
          ),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              builder: (context) {
                return const SearchIngredientForm();
              },
            );
          },
          child: const Icon(Icons.add, color: Color(0xFFFAFAF9)),
        ));
  }
}
