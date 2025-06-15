import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Using Riverpod for state management, since it is necessary in order to call inside the application
final authServiceProvider = Provider<AuthenticationService>((ref) {
  return AuthenticationService();
});

class AuthenticationService {
  /*Create firebaseAuth object, imported from the firebase_auth package,
  it is tasked with handling features like login, logout & authentication
   */
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //Used said object to get access to the current user
  User? get currentUser => firebaseAuth.currentUser;

  // Getter used to return the display name (username) of the current user
  String? get username => currentUser?.displayName;

  // Getter used to return the email of the current user
  String? get email => currentUser?.email;

  //Used to find the state of the current user, if they are connected or not
  Stream<User?> get authStateChanges => firebaseAuth.authStateChanges();

  //---------------------------------------* Functions * -----------------------------------------

  //SignIn method, requires two parameters
  Future<UserCredential> signIn({
    //User's email
    required String email,
    //User's password
    required String password,
  }) async {
    // Uses the FirebaseAuth instance to sign in an user with the provided email and password.
    return await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  // Uses the FirebaseAuth instance to create an user, with the same requirements as before.
  Future<UserCredential> createAccount({
    //Same requirements
    required String email,
    required String password,
  }) async {
    return await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  // Uses the FirebaseAuth instance to sign out thr user
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  // Uses the instance of FirebaseAuth to send an email for password reset
  Future<void> resetPassword({required String email}) async {
    await firebaseAuth.sendPasswordResetEmail(
      // Requires the user's email
      email: email,
    );
  }

  // Uses and instance of the currentUser object
  Future<void> updateUsername({
    // requires a String username
    required String username,
  }) async {
    await currentUser?.updateDisplayName(username);
  }

  /* Re-authenticates the current user using their current password,
   then updates their password to a new one.
   */

  /* Deletes the currently signed-in user's account after re-authenticating
   with their email and password. Signs the user out afterward.
   */
  Future<void> deleteAccount({
    // User's email
    required String email,
    // User's password
    required String password,
  }) async {
    // Re-authenticate the user to confirm their identity
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: password,
    );

    /* In order for Firebase to delete the account of user,
    it first requires to re-authenticate said user (for security purposes)
     */
    await currentUser!.reauthenticateWithCredential(credential);

    // Delete the user account
    await currentUser!.delete();

    // Sign out the user from Firebase
    await firebaseAuth.signOut();
  }
  Future<void> resetPasswordFromCurrentPassword({
    // String for current password
    required String currentPassword,
    // String for new password
    required String newPassword,
    // User's email
    required String email,
  }) async {
    // Re-authenticate the user to confirm their identity
    AuthCredential credential = EmailAuthProvider.credential(
      email: email,
      password: currentPassword,
    );
    /*
    * Same as before, this is a security sensitive issue, as such it requires
    * re-authentication
    */
    await currentUser!.reauthenticateWithCredential(credential);

    // Update the user's password
    await currentUser!.updatePassword(newPassword);
  }

}
