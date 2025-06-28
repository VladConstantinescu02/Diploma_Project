import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteIngredientProvider = Provider<DeleteSpecificIngredient>((ref) {
  return DeleteSpecificIngredient();
});

class DeleteSpecificIngredient {
  final userIngredient = FirebaseFirestore.instance.collection('fridgeItems');

  Future<void> deleteSpecificUserIngredient(
      {required String uid, required int ingredientId}) async {
    final query = await userIngredient
        .where('userId', isEqualTo: uid)
        .where('ingredientId', isEqualTo: ingredientId)
        .get();

    final batch = FirebaseFirestore.instance.batch();
    for (final doc in query.docs) {
      batch.delete(doc.reference);
    }
    await batch.commit();
  }

}
