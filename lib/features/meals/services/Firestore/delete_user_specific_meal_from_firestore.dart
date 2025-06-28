import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteUserSpecificMealProvider =
    Provider<DeleteUserSpecificMealFromFireStore>((ref) {
  return DeleteUserSpecificMealFromFireStore();
});

class DeleteUserSpecificMealFromFireStore {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteUserSpecificMealFromFireStore({
    required String mealId,
    required String userId,
  }) async {
    try {

      final query = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .where('mealId', isEqualTo: mealId)
          .limit(1)
          .get();

      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.delete();
      } else {
        if (kDebugMode) {
          print("No matching meal found.");
        }
      }
    } catch (e) {
      throw ('Error deleting specific meal: $e');
    }
  }
}
