import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../meals/services/FireStore/delete_meals_from_firestore.dart';

final deleteUserServiceProvider = Provider<DeleteUserService>((ref) {
  final deleteMealsService = ref.read(deleteMealsFromFirestoreServiceProvider);
  return DeleteUserService(deleteMealsService: deleteMealsService);
});

class DeleteUserService {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firestore;
  final FirebaseStorage firebaseStorage;
  final DeleteMealFromFirebase deleteMealsService;

  DeleteUserService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? firebaseStorage,
    required this.deleteMealsService,
  })  : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        firestore = firestore ?? FirebaseFirestore.instance,
        firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final user = firebaseAuth.currentUser;


    if (user == null) {
      throw Exception("No user signed in.");
    }

    final uid = user.uid;

    try {
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );

      await user.reauthenticateWithCredential(credential);

      await deleteMealsService.deleteMealFromFireStore(userId: uid);

      final storageRef = FirebaseStorage.instance
          .ref()
          .child("users/$uid/profile_picture.jpg");
      try {
        await storageRef.delete();
      } catch (e) {
        debugPrint("No profile picture found to delete: $e");
      }

      await firestore.collection('users').doc(uid).delete();
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception("Failed to delete account: ${e.toString()}");
    }
  }

  Future<void> deleteAccountProfileImage() async {
    final String uid = firebaseAuth.currentUser?.uid ??
        (throw Exception("No user signed in"));

    final imageRef =
    firebaseStorage.ref().child("users/$uid/profile_picture.jpg");

    try {
      await imageRef.delete();
      if (kDebugMode) {
        print("Profile image deleted");
      }
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        if (kDebugMode) {
          print("Profile image not found");
        }
      } else {
        if (kDebugMode) {
          print("Failed to delete profile photo $e");
        }
      }
    }
  }
}
