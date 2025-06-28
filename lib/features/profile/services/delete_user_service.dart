import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../meals/services/Firestore/delete_all_user_fridge_items.dart';
import '../../meals/services/firestore/delete_meals_from_firestore.dart';

/// ── PROVIDER ───────────────────────────────────────────────────────────────
final deleteUserServiceProvider = Provider<DeleteUserService>((ref) {
  final mealsSvc   = ref.read(deleteMealsServiceProvider);
  final fridgeSvc  = ref.read(deleteFridgeItemsServiceProvider);

  return DeleteUserService(
    deleteMeals: mealsSvc,
    deleteFridge: fridgeSvc,
  );
});

/// ── SERVICE ────────────────────────────────────────────────────────────────
class DeleteUserService {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final DeleteMealFromFirebase _deleteMeals;
  final DeleteAllUserIngredientsFromFirebase _deleteFridge;

  DeleteUserService({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
    required DeleteMealFromFirebase deleteMeals,
    required DeleteAllUserIngredientsFromFirebase deleteFridge,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance,
        _deleteMeals = deleteMeals,
        _deleteFridge = deleteFridge;

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('No user signed in');

    final uid = user.uid;

    // 1️⃣ Re-authenticate
    final cred =
    EmailAuthProvider.credential(email: email, password: password);
    await user.reauthenticateWithCredential(cred);

    // 2️⃣ Delete meals & fridge items
    await _deleteMeals.deleteMeals(userId: uid);
    await _deleteFridge.deleteIngredients(userId: uid);

    // 3️⃣ Delete profile picture (if any)
    try {
      await _storage.ref('users/$uid/profile_picture.jpg').delete();
    } on FirebaseException catch (e) {
      debugPrint('No profile picture to delete: ${e.code}');
    }

    // 4️⃣ Delete user document & auth account
    await _firestore.collection('users').doc(uid).delete();
    await user.delete();
  }
}
