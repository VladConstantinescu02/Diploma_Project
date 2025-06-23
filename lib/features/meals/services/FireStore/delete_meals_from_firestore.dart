import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteMealsFromFirestoreServiceProvider = Provider<DeleteMealFromFirebase>((ref) {
  return DeleteMealFromFirebase();
});

class DeleteMealFromFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteMealFromFireStore({required String userId}) async {
    try {
      final snapshot = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in snapshot.docs) {
        await doc.reference.delete();
      }
    } catch (e) {

      throw("Error occured when deleting meal: $e");

    };
  }
}
