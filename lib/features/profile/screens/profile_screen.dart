import 'package:diploma_prj/features/profile/services/delete_user_service.dart';
import 'package:diploma_prj/features/profile/services/update_username_service.dart';
import 'package:diploma_prj/features/profile/widgets/delete_account_dialog_box.dart';
import 'package:diploma_prj/features/profile/widgets/info_display_widget.dart';
import 'package:diploma_prj/shared/widgets/alert_dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../shared/widgets/one_textbox_dialog_box.dart';
import '../../../shared/errors/authentication_service_error_handling.dart';
import '../../../shared/widgets/profile_picture.dart';
import '../../authentication/services/authentication_service.dart';

const Color mainColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);

final usernameOnInitProvider = Provider<String>((ref) {
  final user = FirebaseAuth.instance.currentUser;
  return user?.displayName ?? 'Default Username';
});

final usernameProvider = StateProvider<String>((ref) {
  return ref.watch(usernameOnInitProvider);
});

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);

    final email = authService.email ?? 'you@mail.com';
    final username = ref.watch(usernameProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFFF2A20C),
        foregroundColor: Colors.white,
        title: const Text("Profile"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFF2A20C),
                foregroundColor: Colors.white,
                side: const BorderSide(width: 1, color: Colors.white),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => TemplateDialogBox(
                    title: 'You are about to logout!',
                    content: 'Are you sure?',
                    confirmText: 'Yup!',
                    cancelText: 'Stay logged in',
                    backgroundColor: const Color(0xFFFAFAF9),
                    textButtonColorCancel: const Color(0xFFFAFAF9),
                    buttonCancel: const Color(0xFFF27507),
                    buttonConfirm: const Color(0xFF8B1E3F),
                    textButtonColorConfirm: const Color(0xFFFAFAF9),
                    onConfirm: () async {
                      try {
                        await authService.signOut();

                        if (context.mounted) {
                          context.go('/login');
                        }
                      } on FirebaseAuthException catch (e) {
                        if (kDebugMode) {
                          print(e.message);
                        }
                      }
                    },
                    onCancel: () {
                      if (kDebugMode) {
                        print('Cancelled');
                      }
                    },
                  ),
                );
              },
              icon: const Icon(Icons.logout_outlined),
              label: const Text("Log out"),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: ProfilePictureWidget(),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Align(
                alignment: Alignment.center,
                child: Row(
                  mainAxisSize: MainAxisSize.min, // Keep it compact
                  children: [
                    const Text(
                      'Hi ',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    Text(
                      username,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 16.0 * 2),
            MyInfo(infoText: username, titleText: 'User name:'),
            MyInfo(infoText: email, titleText: 'Email address:'),
            const SizedBox(height: 16.0),
            const Divider(height: 16.0 * 2),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                  'Customize Your profile',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFF2A20C),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => OneTextBoxDialogBox(
                          title: 'Change your user name',
                          label: 'Enter your username',
                          icon: Icons.person_add_alt_1_outlined,
                          buttonColor: mainColor,
                          buttonText: 'Submit',
                          buttonTextColor: backGroundColor,
                          dialogBackgroundColor: backGroundColor,

                          onSubmit: (newUsername) async {
                            Navigator.of(context).pop(); // close the dialog first

                            if (!context.mounted) return;
                            await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: 'Username set to "$newUsername"',
                              autoCloseDuration: const Duration(seconds: 2),
                            );

                            try {
                              final updateUserName =
                              ref.read(updateUserNameService);
                              await updateUserName
                                  .updateUsername(newUsername);
                              ref.read(usernameProvider.notifier).state =
                                  newUsername;

                            } on FirebaseAuthException catch (e) {
                              if (!context.mounted) return;

                              String errorMessage =
                              getFirebaseAuthErrorMessage(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(errorMessage),
                                    backgroundColor: const Color(0xFF8B1E3F)),
                              );
                            } catch (e) {
                              if (!context.mounted) return;


                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                  Text("An unexpected error occurred."),
                                  backgroundColor: Color(0xFF8B1E3F),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                    child: const Text("Edit Username"),
                  ),
                ),
              ],
            ),
            const Divider(height: 16.0 * 2),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text('Danger zone',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                    )),
              ),
            ),
            Row(
              children: [
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFF8B1E3F),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => DeleteAccountDialogBox(
                          title: 'Delete your account',
                          label1: 'Enter your email',
                          label2: 'Enter your password',
                          icon1: Icons.email_outlined,
                          icon2: Icons.password_outlined,
                          buttonColor: const Color(0xFF8B1E3F),
                          buttonTextColor: const Color(0xFFFAFAF9),
                          buttonText: 'Goodbye!',
                          dialogBackgroundColor: const Color(0xFFFAFAF9),
                          onSubmit: (email, password) async {
                            try {
                              final deleteUserService =
                                  ref.read(deleteUserServiceProvider);
                              await deleteUserService.deleteAccount(
                                  email: email, password: password);
                            } on FirebaseAuthException catch (e) {
                              if (!context.mounted) return;

                              String errorMessage =
                                  getFirebaseAuthErrorMessage(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(errorMessage),
                                    backgroundColor: const Color(0xFF8B1E3F)),
                              );
                            } catch (e) {
                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content:
                                      Text("An unexpected error occurred."),
                                  backgroundColor: Color(0xFF8B1E3F),
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                    child: const Text("Delete account"),
                  ),
                ),
                const Spacer(
                  flex: 1,
                ),
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: const Color(0xFFF2A20C),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => OneTextBoxDialogBox(
                          title: 'Reset your password!',
                          label: 'Email',
                          icon: Icons.emergency_rounded,
                          buttonColor: const Color(0xFFF27507),
                          buttonText: 'Reset',
                          buttonTextColor: const Color(0xFFFAFAF9),
                          dialogBackgroundColor: const Color(0xFFFAFAF9),
                          onSubmit: (email) async {
                            Navigator.of(context).pop();

                            if (!context.mounted) return;
                            await QuickAlert.show(
                              context: context,
                              type: QuickAlertType.success,
                              text: 'Check your email!',
                              autoCloseDuration: const Duration(milliseconds: 500),
                              confirmBtnColor: const Color(0xFFF27507),
                              confirmBtnText: 'OK', // optional label
                              confirmBtnTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                              borderRadius: 48,
                            );

                            try {
                              await authService.resetPassword(email: email);
                            } on FirebaseAuthException catch (e) {
                              String errorMessage =
                                  getFirebaseAuthErrorMessage(e);

                              if (!context.mounted) return;

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(errorMessage),
                                    backgroundColor: const Color(0xFF8B1E3F)),
                              );
                            }
                          },
                        ),
                      );
                    },
                    child: const Text("Reset password"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
