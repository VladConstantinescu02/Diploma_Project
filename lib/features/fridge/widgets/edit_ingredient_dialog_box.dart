import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../models/ingredient_model.dart';
import '../services/API/get_ingredient_detailed_information.dart';
import '../services/Firestore/update_user_specific_ingredient.dart';

const Color mainColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);

class UpdateIngredientDialogBox extends ConsumerStatefulWidget {
  final List<String> units;
  final Ingredient ingredient;

  const UpdateIngredientDialogBox({
    super.key,
    required this.units,
    required this.ingredient,
  });

  @override
  ConsumerState<UpdateIngredientDialogBox> createState() =>
      UpdateIngredientDialogBoxState();
}

class UpdateIngredientDialogBoxState
    extends ConsumerState<UpdateIngredientDialogBox> {
  late final TextEditingController amountTextController;
  late String unitSelected;

  @override
  void initState() {
    super.initState();
    amountTextController = TextEditingController(
      text: widget.ingredient.amount.toString(),
    );

    // Select current unit if available, else fallback to first unit
    unitSelected = widget.units.contains(widget.ingredient.unit)
        ? widget.ingredient.unit
        : (widget.units.isNotEmpty ? widget.units.first : '');
  }

  @override
  void dispose() {
    amountTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "You are editing...",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: darkColor,
          fontSize: 25,
        ),
      ),
      backgroundColor: backGroundColor,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(48),
              color: mainColor,
            ),
            child: Text(
              widget.ingredient.name,
              style: const TextStyle(
                color: backGroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: amountTextController,
            keyboardType: TextInputType.number,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))
            ],
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle: const TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
              ),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(48)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: mainColor),
                borderRadius: BorderRadius.circular(48),
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: unitSelected,
            items: widget.units
                .map((unit) => DropdownMenuItem(
              value: unit,
              child: Text(unit),
            ))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => unitSelected = val);
            },
            decoration: InputDecoration(
              labelText: 'Unit',
              labelStyle: const TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
              ),
              border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(48)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: mainColor),
                borderRadius: BorderRadius.circular(48),
              ),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: mainColor,
            foregroundColor: backGroundColor,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          ),
          onPressed: () async {
            final amount =
                double.tryParse(amountTextController.text.trim()) ?? 0;
            if (amount <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter a valid amount')),
              );
              return;
            }

            final uid = FirebaseAuth.instance.currentUser!.uid;
            final id = widget.ingredient.id;
            final unit = unitSelected;

            final infoService = IngredientInfoService();
            final calories = await infoService.fetchCalories(id, amount, unit);

            if (calories == null) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not get nutrition info')),
              );
              return;
            }

            final service = ref.read(updateUserSpecificIngredientProvider);
            await service.updateUserIngredient(
              uid: uid,
              ingredientId: id,
              amount: amount,
              unit: unit,
            );

            if (!context.mounted) return;
            Navigator.of(context).pop(); // success
          },
          child: const Text(
            "Save",
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }
}
