import 'package:firebase_auth/firebase_auth.dart';

String getFirebaseAuthErrorMessage(FirebaseAuthException e) {
  switch (e.code) {
  // Common for both login and register
    case 'invalid-email':
      return 'The email address is not valid.';
    case 'user-disabled':
      return 'This user account has been disabled.';
    case 'user-not-found':
      return 'No user found with this email.';
    case 'wrong-password':
      return 'The password is incorrect.';
    case 'too-many-requests':
      return 'Too many requests. Please try again later.';
    case 'operation-not-allowed':
      return 'Operation not allowed. Please contact support.';

  // Registration-specific
    case 'email-already-in-use':
      return 'This email address is already in use.';
    case 'weak-password':
      return 'Weak password. Requires minimum 6 characters and at least one unique character.';

  // Credential-related errors
    case 'invalid-credential':
      return 'The provided credentials are invalid.';
    case 'account-exists-with-different-credential':
      return 'An account already exists with a different credential.';
    case 'credential-already-in-use':
      return 'This credential is already associated with another account.';

  // Re-authentication & sensitive operation errors
    case 'requires-recent-login':
      return 'Please log in again to perform this operation.';

  // Internal / unexpected errors
    case 'network-request-failed':
      return 'Network error. Please check your connection.';
    case 'internal-error':
      return 'An internal error occurred. Please try again later.';
    case 'invalid-verification-code':
      return 'Invalid verification code.';
    case 'invalid-verification-id':
      return 'Invalid verification ID.';

  // Default catch-all
    default:
      return 'An unknown error occurred. (${e.code})';
  }
}

