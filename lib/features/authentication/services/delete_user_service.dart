import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final deleteUserServiceProvider = Provider<DeleteUserService>((ref) {
  return DeleteUserService();
});

class DeleteUserService {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  DeleteUserService({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<void> deleteAccount({
    required String email,
    required String password,
  }) async {
    final user = _firebaseAuth.currentUser;

    if (user == null) {
      throw Exception("No user signed in.");
    }

    final uid = user.uid; // 🔥 capture UID BEFORE anything

    try {
      // ✅ Re-authenticate first
      final credential = EmailAuthProvider.credential(
        email: email,
        password: password,
      );
      await user.reauthenticateWithCredential(credential);

      // ✅ 🔥 DELETE Firestore document FIRST while user still exists
      await _firestore.collection('users').doc(uid).delete();

      // ✅ DELETE FirebaseAuth user LAST
      await user.delete();
    } on FirebaseAuthException catch (e) {
      throw FirebaseAuthException(code: e.code, message: e.message);
    } catch (e) {
      throw Exception("Failed to delete account: ${e.toString()}");
    }
  }
}
