import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/errors/authentication_service_error_handling.dart';



// Provider using Riverpod to expose UpdateUserNameService throughout the app
final updateUserNameService = Provider<UpdateUserNameService>((ref) {
  return UpdateUserNameService();
});

class UpdateUserNameService {

  // Get an instance of Firebase Auth
  final FirebaseAuth _firebaseAuth;

  // Get an instabce of Firestore
  final FirebaseFirestore _firestore;

  // Constructor
  UpdateUserNameService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  /*
  * Function used inside the update username dialog box, sending the used input to Firestore, to be saved
  */
  Future<void> updateUsername(String newUsername) async {
    // Create an instance of the current user
    final user = _firebaseAuth.currentUser;

    // User null check
    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-logged-in',
        message: 'No user is currently logged in.',
      );
    }

    try {
      // Finally update the username
      user.updateDisplayName(newUsername);

      await _firestore.collection('users').doc(user.uid).update({
        'username': newUsername,
      });
    } catch (e) {
      String errorMessage = 'Failed to register';
      if (e is FirebaseAuthException) {
        errorMessage = getFirebaseAuthErrorMessage(e);
      }
    }
  }
}
