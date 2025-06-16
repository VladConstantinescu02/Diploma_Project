import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteUserServiceProvider = Provider<DeleteUserService>((ref) {
  return DeleteUserService();
});

class DeleteUserService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage;

  DeleteUserService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? firebaseStorage,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw Exception("No user signed in.");
    }

    final uid = user.uid;

    try {
      // 1️⃣ Re-authenticate user first (important: before deleting anything!)
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // 2️⃣ Delete profile picture from Firebase Storage (if exists)
      final storageRef = FirebaseStorage.instance.ref().child("users/$uid/profile_picture.jpg");
      try {
        await storageRef.delete();
      } catch (e) {
        // No image found — safe to ignore
        debugPrint("No profile picture found to delete: $e");
      }

      // 3️⃣ Delete Firestore user document
      await _firestore.collection('users').doc(uid).delete();

      // 4️⃣ Finally delete user from Authentication
      await user.delete();

    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception("Failed to delete account: ${e.toString()}");
    }
  }


  Future<void> deleteAccountProfileImage() async {
    final String uid = _firebaseAuth.currentUser?.uid ??
        (throw Exception("No user signed in"));
    final imageRef =
        _firebaseStorage.ref().child("users/$uid/profile_picture.jpg");

    try {
      await imageRef.delete();
      if (kDebugMode) {
        print("Profile image deleted");
      }
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        if (kDebugMode) {
          print("Profile image not found");
        } else {
          if (kDebugMode) {
            print("Failed to delete profile photo $e");
          }
        }
      }
    }
  }
}
