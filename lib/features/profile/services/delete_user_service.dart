import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/*
The main function for deleting the user across the database
It it a 4 step component, being responsible for: deleting user
authentification, user data from firestore (username, id, meal and ingredient data)  &
deleting the user's profile photo
*/

// Provider using Riverpod to expose DeleteUserService throughout the app
final deleteUserServiceProvider = Provider<DeleteUserService>((ref) {
  return DeleteUserService();
});

class DeleteUserService {
  // Firebase authentication instance
  final FirebaseAuth _firebaseAuth;

  // Firestore instance used to manage database data
  final FirebaseFirestore _firestore;

  // Firebase storage instance used to manage file storage
  final FirebaseStorage _firebaseStorage;

  // Constructor
  DeleteUserService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? firebaseStorage,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _firebaseStorage = firebaseStorage ?? FirebaseStorage.instance;

  // Deletes the user's account and all associated data (auth, Firestore, and profile image)
  Future<void> deleteAccount({
    // User's email
    required String email,
    // User's password
    required String password,
  }) async {
    // Get the current user
    final user = _firebaseAuth.currentUser;

    // If no user is signed in, throw an exception
    if (user == null) {
      throw Exception("No user signed in.");
    }

    // Retrieve user ID
    final uid = user.uid;

    try {
      /* In order for Firebase to delete the account of user,
    it first requires to re-authenticate said user (for security purposes)
     */

      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      //Delete profile picture from Firebase Storage (if it exists)
      final storageRef = FirebaseStorage.instance
          .ref()
          .child("users/$uid/profile_picture.jpg"); // refrence inside Storage
      try {
        await storageRef.delete();
      } catch (e) {
        // If no profile image is found, show debug message
        debugPrint("No profile picture found to delete: $e");
      }

      //Delete the user's Firestore document
      await _firestore.collection('users').doc(uid).delete();

      // Step 4: Delete the user's Firebase Authentication account
      await user.delete();
    } on FirebaseAuthException catch (e) {
      // Re-throw FirebaseAuth-specific exceptions
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      // Throw exceptions
      throw Exception("Failed to delete account: ${e.toString()}");
    }
  }

  // Deletes the user's profile image from Firebase Storage
  Future<void> deleteAccountProfileImage() async {
    // Retrieve current user ID
    final String uid = _firebaseAuth.currentUser?.uid ??
        (throw Exception("No user signed in"));

    // Reference to the profile image in storage
    final imageRef =
        _firebaseStorage.ref().child("users/$uid/profile_picture.jpg");

    try {
      // Attempt to delete the image
      await imageRef.delete();
      if (kDebugMode) {
        print("Profile image deleted");
      }
    } on FirebaseException catch (e) {
      // If image does not exist, ignore
      if (e.code == 'object-not-found') {
        if (kDebugMode) {
          print("Profile image not found");
        }
      } else {
        // Log any other errors
        if (kDebugMode) {
          print("Failed to delete profile photo $e");
        }
      }
    }
  }
}
