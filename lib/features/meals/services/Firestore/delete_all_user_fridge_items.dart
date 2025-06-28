import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteAllUserIngredientsFromFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteIngredients({required String userId}) async {
    try {
      final snap = await _firestore
          .collection('fridgeItems')
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in snap.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Error while deleting fridge items: $e');
    }
  }
}

final deleteFridgeItemsServiceProvider =
Provider<DeleteAllUserIngredientsFromFirebase>(
        (ref) => DeleteAllUserIngredientsFromFirebase());
