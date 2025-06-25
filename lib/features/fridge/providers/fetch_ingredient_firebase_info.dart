import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ingredient_model.dart';

final ingredientServiceProvider =
Provider<FirestoreIngredientService>((ref) => FirestoreIngredientService());

/// Stream all fridge items that belong to the *current* user
final userIngredientsProvider = StreamProvider<List<Ingredient>>((ref) {
  final uid = FirebaseAuth.instance.currentUser?.uid;
  if (uid == null) return const Stream.empty();
  return ref.read(ingredientServiceProvider).getIngredients(uid);
});

/// If you need to fetch another user’s fridge items by UID:
final ingredientsByUserProvider =
StreamProvider.family<List<Ingredient>, String>((ref, userId) {
  return ref.read(ingredientServiceProvider).getIngredients(userId);
});


class FirestoreIngredientService {
  final CollectionReference _items =
  FirebaseFirestore.instance.collection('fridgeItems');

  /// Live stream of all ingredients that belong to [userId]
  Stream<List<Ingredient>> getIngredients(String userId) {
    return _items
        .where('userID', isEqualTo: userId) // ← field must be userID
        .snapshots()
        .map((snap) => snap.docs.map((doc) {
      final data = doc.data() as Map<String, dynamic>;
      debugPrint('📦 Firestore doc ${doc.id} → $data'); // 🔍 View each document

      return Ingredient.fromFirestore(data, doc.id);
    }).toList());
  }

  /// If you ever need a single ingredient by document-ID:
  Future<Ingredient?> getIngredientByDocId(String docId) async {
    final doc = await _items.doc(docId).get();
    if (!doc.exists) return null;
    return Ingredient.fromFirestore(doc.data() as Map<String, dynamic>, doc.id);
  }
}
