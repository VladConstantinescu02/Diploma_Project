import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/ingredient_model.dart';
import '../services/API/get_ingredient_detailed_information.dart';

const Color mainColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);
class SaveIngredientDialogBox extends StatefulWidget {
  final Ingredient partialIngredient; // From search, without amount/unit

  final List<String> units;

  const SaveIngredientDialogBox({
    super.key,
    required this.partialIngredient,
    required this.units,
  });

  @override
  State<SaveIngredientDialogBox> createState() =>
      _SaveIngredientDialogBoxState();
}

class _SaveIngredientDialogBoxState extends State<SaveIngredientDialogBox> {
  final TextEditingController _controller = TextEditingController();
  late String _selectedUnit;

  @override
  void initState() {
    super.initState();
    _selectedUnit = widget.units.isNotEmpty ? widget.units.first : '';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text(
        "You were about to add...",
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: darkColor,
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
              widget.partialIngredient.name,
              style: const TextStyle(
                color: backGroundColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.]'))],
            decoration: InputDecoration(
              labelText: 'Amount',
              labelStyle: const TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(48)),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: mainColor),
                borderRadius: BorderRadius.circular(48),
              ),
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _selectedUnit,
            items: widget.units
                .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                .toList(),
            onChanged: (val) {
              if (val != null) setState(() => _selectedUnit = val);
            },
            decoration: InputDecoration(
              labelText: 'Unit',
              labelStyle: const TextStyle(
                color: secondaryColor,
                fontWeight: FontWeight.bold,
              ),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(48)),
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
            final amount = double.tryParse(_controller.text.trim()) ?? 0;
            if (amount <= 0) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Enter a valid amount')),
              );
              return;
            }

            final uid = FirebaseAuth.instance.currentUser!.uid;
            final id = widget.partialIngredient.id;
            final unit = _selectedUnit;


            final infoService = IngredientInfoService();
            final calories = await infoService.fetchCalories(id, amount, unit);

            if (calories == null) {
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Could not get nutrition info')),
              );
              return;
            }

            final completeIngredient = Ingredient.fromSearch(
              id: id,
              name: widget.partialIngredient.name,
              amount: amount,
              unit: unit,
              userId: uid,
              nutrition: calories,
            );

            if(!context.mounted) return;
            Navigator.of(context).pop(completeIngredient);

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
