import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final updateUserSpecificIngredientProvider = Provider<UpdateUserSpecificIngredient>((ref) {
  return UpdateUserSpecificIngredient();
});

class UpdateUserSpecificIngredient {
  final userIngredient = FirebaseFirestore.instance.collection('fridgeItems');

  Future<void> updateUserIngredient(
      {required String uid,
      required int ingredientId,
      required double amount,
      required String unit}) async {
    final query = await userIngredient
        .where('userId', isEqualTo: uid)
        .where('ingredientId', isEqualTo: ingredientId)
        .limit(1)
        .get();

    final docId = query.docs.first.id;

    await FirebaseFirestore.instance
        .collection('fridgeItems')
        .doc(docId)
        .update({'quantity': amount, 'unit': unit});
  }
}
