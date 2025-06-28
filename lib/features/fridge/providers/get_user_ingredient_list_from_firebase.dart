import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final getUserIngredientListFromFirebase =
    StreamProvider.family<List<String>, String>((ref, uid) {
  final ingredientsFromFirestore =
      FirebaseFirestore.instance.collection('fridgeItems');

  return ingredientsFromFirestore
      .where('userId', isEqualTo: uid)
      .snapshots()
      .map((snap) => snap.docs
          .map((doc) => (doc.data()['name'] as String?) ?? '')
          .where((name) => name.isNotEmpty)
          .toSet()
          .toList());
});
