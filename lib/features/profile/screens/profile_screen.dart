import 'package:diploma_prj/features/profile/services/delete_user_service.dart';
import 'package:diploma_prj/features/profile/widgets/info_display_widget.dart';
import 'package:diploma_prj/features/profile/widgets/theme_change_widget.dart';
import 'package:diploma_prj/shared/widgets/alert_dialog_box.dart';
import 'package:diploma_prj/shared/widgets/three_textbox_dialog_box.dart';
import 'package:diploma_prj/shared/widgets/two_textbox_dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/services/authentication_service.dart';
import '../../../shared/widgets/one_textbox_dialog_box.dart';
import '../../../shared/errors/authentication_service_error_handling.dart';
import '../../../shared/widgets/profile_picture.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final username = authService.username ?? 'there!';
    final email = authService.email ?? 'you@mail.com';

    // Get theme-based colors:
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final backgroundColor = theme.scaffoldBackgroundColor;
    final buttonColor = theme.colorScheme.secondary;
    final dialogBackgroundColor = backgroundColor;
    const dangerColor = Color(0xFF8B1E3F);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        title: const Text("Profile"),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: primaryColor,
                foregroundColor: Colors.white,
                side: const BorderSide(width: 1, color: Colors.white),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => const ThemeSwitcher(),
                );
              },
              icon: const Icon(Icons.edit),
              label: const Text("Edit Theme"),
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
                  mainAxisSize: MainAxisSize.min,
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
            const Divider(height: 32),
            MyInfo(infoText: username, titleText: 'User name:'),
            MyInfo(infoText: email, titleText: 'Email address:'),
            const SizedBox(height: 16.0),
            const Divider(height: 32),
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
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => ThreeTextBoxDialogBox(
                          title: 'Update your password',
                          label1: 'Email',
                          label2: 'Old password',
                          label3: 'New password',
                          icon1: Icons.email_outlined,
                          icon2: Icons.password_outlined,
                          icon3: Icons.edit,
                          buttonColor: buttonColor,
                          buttonTextColor: Colors.white,
                          buttonText: 'Confirm',
                          dialogBackgroundColor: dialogBackgroundColor,
                          onSubmit: (currentPassword, newPassword, email) async {
                            try {
                              await authService.resetPasswordFromCurrentPassword(
                                currentPassword: currentPassword,
                                newPassword: newPassword,
                                email: email,
                              );
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("Password updated successfully!"),
                                  backgroundColor: Colors.green,
                                ),
                              );
                            } on Exception catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("Failed to update password: ${e.toString()}"),
                                  backgroundColor: dangerColor,
                                ),
                              );
                            }
                          },
                        ),
                      );
                    },
                    child: const Text("Update password"),
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: buttonColor,
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
                          buttonColor: buttonColor,
                          buttonText: 'Reset',
                          buttonTextColor: Colors.white,
                          dialogBackgroundColor: dialogBackgroundColor,
                          onSubmit: (email) async {
                            try {
                              await authService.resetPassword(email: email);
                            } on FirebaseAuthException catch (e) {
                              String errorMessage = getFirebaseAuthErrorMessage(e);
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                    content: Text(errorMessage),
                                    backgroundColor: dangerColor),
                              );
                            }
                          },
                        ),
                      );
                    },
                    child: const Text("Reset Password"),
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
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
                      backgroundColor: dangerColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => TwoInputDialogBox(
                          title: 'Delete your account',
                          label1: 'Enter your email',
                          label2: 'Enter your password',
                          icon1: Icons.email_outlined,
                          icon2: Icons.password_outlined,
                          buttonColor: dangerColor,
                          buttonTextColor: Colors.white,
                          buttonText: 'Goodbye!',
                          dialogBackgroundColor: dialogBackgroundColor,
                          onSubmit: (email, password) async {
                            try {
                              final deleteUserService = ref.read(deleteUserServiceProvider);
                              await deleteUserService.deleteAccount(email: email, password: password);
                            } on FirebaseAuthException catch (e) {
                              if (!context.mounted) return;
                              String errorMessage = getFirebaseAuthErrorMessage(e);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(errorMessage),
                                  backgroundColor: dangerColor,
                                ),
                              );
                            } catch (e) {
                              if (!context.mounted) return;
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text("An unexpected error occurred."),
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
                const Spacer(),
                SizedBox(
                  width: 180,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: buttonColor,
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => TemplateDialogBox(
                          title: 'You are about to log out!',
                          content: 'Are you sure?',
                          confirmText: 'Yup!',
                          cancelText: 'Stay logged in',
                          backgroundColor: dialogBackgroundColor,
                          textButtonColorCancel: Colors.white,
                          buttonCancel: buttonColor,
                          buttonConfirm: dangerColor,
                          textButtonColorConfirm: Colors.white,
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
                    child: const Text("Log Out"),
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
