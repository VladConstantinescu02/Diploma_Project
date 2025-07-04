import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DeleteMealFromFirebase {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> deleteMeals({required String userId}) async {
    try {
      final snap = await _firestore
          .collection('meals')
          .where('userId', isEqualTo: userId)
          .get();

      for (final doc in snap.docs) {
        await doc.reference.delete();
      }
    } catch (e) {
      throw Exception('Error while deleting meals: $e');
    }
  }
}

final deleteMealsServiceProvider =
Provider<DeleteMealFromFirebase>((ref) => DeleteMealFromFirebase());
