import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/errors/authentication_service_error_handling.dart';

final updateUserNameService = Provider<UpdateUserNameService>((ref) {
  return UpdateUserNameService();
});

class UpdateUserNameService {

  final FirebaseAuth _firebaseAuth;

  final FirebaseFirestore _firestore;

  UpdateUserNameService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> updateUsername(String newUsername) async {

    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw FirebaseAuthException(
        code: 'user-not-logged-in',
        message: 'No user is currently logged in.',
      );
    }

    try {

      user.updateDisplayName(newUsername);

      await _firestore.collection('users').doc(user.uid).update({
        'username': newUsername,
      });
    } catch (e) {
      if (e is FirebaseAuthException) {
        throw ('Unable to update username');
      }
    }
  }
}
