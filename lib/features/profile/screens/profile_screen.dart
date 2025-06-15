import 'package:diploma_prj/features/profile/services/delete_user_service.dart';
import 'package:diploma_prj/features/profile/widgets/info_display_widget.dart';
import 'package:diploma_prj/shared/widgets/alert_dialog_box.dart';
import 'package:diploma_prj/shared/widgets/two_textbox_dialog_box.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/services/authentication_service.dart';
import '../../../shared/widgets/one_textbox_dialog_box.dart';
import '../../authentication/services/authentication_service_error_handling.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authService = ref.watch(authServiceProvider);
    final username = authService.username ?? 'there!';
    final email = authService.email ?? 'you@mail.com';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        elevation: 0,
        backgroundColor: const Color(0xFFFF5733),
        foregroundColor: Colors.white,
        title: const Text("Profile"),
        actions: <Widget>[
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              elevation: 0,
              backgroundColor: const Color(0xFFFF5733),
              foregroundColor: Colors.white,
              side: const BorderSide(width: 1, color: Colors.white),
            ),
            onPressed: () {},
            icon: const Icon(Icons.edit),
            label: const Text("Edit Theme"),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
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
                      // Replace with actual username variable if needed
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
                      backgroundColor: const Color(0xFFFF5733),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {},
                    child: const Text("Edit Username"),
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
                      backgroundColor: const Color(0xFFFF5733),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 48),
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => OneTextBoxDialogBox(
                          title: 'Your new username',
                          label: 'Username',
                          icon: Icons.person_2_outlined,
                          onSubmit: (username) {
                            if (kDebugMode) {
                              print('Username $email');
                            }
                          },
                        ),
                      );
                    },
                    child: const Text("Edit Password"),
                  ),
                ),
              ],
            ),
            const Divider(height: 16.0 * 2),
            const Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20),
                child: Text(
                    ''
                    'Danger zone',
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
                      backgroundColor: Colors.red,
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
                      backgroundColor: const Color(0xFFFF5733),
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
                          confirmText: 'Yup',
                          cancelText: 'Stay logged in',
                          textButtonColorConfirm: Colors.red,
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
                          textButtonColorCancel: Colors.black,
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
