import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/meal_model.dart';

final fetchFirestoreMealInformationProvider = Provider<FirestoreFetchMealInformation>((ref) {
  return FirestoreFetchMealInformation();
});

final firestoreMealServiceProvider = Provider<FirestoreFetchMealInformation>((ref) {
  return FirestoreFetchMealInformation();
});

final userMealsProvider = StreamProvider.family<List<Meal>, String>((ref, userId) {
  final service = ref.read(firestoreMealServiceProvider);
  return service.getMeals(userId);
});

class FirestoreFetchMealInformation {
  final CollectionReference _mealsCollection = FirebaseFirestore.instance.collection('meals');

  Stream<List<Meal>> getMeals(String userId) {
    return _mealsCollection
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Meal.fromFirestore(doc.data() as Map<String, dynamic>))
        .toList());
  }
}
