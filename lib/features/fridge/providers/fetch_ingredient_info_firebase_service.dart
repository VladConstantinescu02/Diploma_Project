import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ingredient_model.dart';

final firebaseUserIngredientServiceProvider =
Provider<FirestoreIngredientService>((ref) => FirestoreIngredientService());

final userIngredientsProvider =
StreamProvider.family<List<Ingredient>, String>((ref, uid) {
  return ref
      .read(firebaseUserIngredientServiceProvider)
      .getIngredients(uid);
});


class FirestoreIngredientService {
  final CollectionReference _items =
  FirebaseFirestore.instance.collection('fridgeItems');

  Stream<List<Ingredient>> getIngredients(String userId) {
    return _items
        .where('userID', isEqualTo: userId) // ← field must be userID
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      debugPrint('📦 Firestore doc ${doc.id} → $data');

      return Ingredient.fromFirestore(data, doc.id);
    }).toList());
  }

}
