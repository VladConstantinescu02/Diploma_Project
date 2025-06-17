import 'package:diploma_prj/shared/services/authentication_service.dart';
import 'package:diploma_prj/shared/widgets/text_box_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

import '../../../shared/errors/authentication_service_error_handling.dart';
import '../../../shared/widgets/template_obscured_input_field.dart';

// Replace with actual colors or use default Material colors
const Color mainColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: backGroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 200,
                      width: 200,
                      child: Lottie.asset('lib/utils/images/login_screen_animation.json'),
                    ),
                  ),
                  const Text(
                    "Hi there!",
                    style: TextStyle(
                        color: mainColor, fontSize: 30, fontWeight: FontWeight.w900),
                  ),
                  const Text(
                    "Welcome to Dishify!",
                    style: TextStyle(fontSize: 23, color: secondaryColor),
                  ),
                  const SizedBox(height: 25),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: TemplateControllerTextbox(
                      textBoxController: _emailController,
                      textBoxLabel: 'Email',
                      textBoxIcon: Icons.email_outlined,
                      textLabelColor: darkColor,
                      textBoxFocusedColor: mainColor,
                      textBoxStaticColor: secondaryColor,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child:  TemplateObscuredTextbox(
                      textBoxController: _passwordController,
                      textBoxLabel: 'Password',
                      textBoxIcon: Icons.password_outlined,
                      textLabelColor: darkColor,
                      textBoxFocusedColor: mainColor,
                      textBoxStaticColor: secondaryColor,
                      isInput: true,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      margin: kIsWeb
                          ? const EdgeInsets.symmetric(horizontal: 350)
                          : const EdgeInsets.symmetric(horizontal: 25),
                      height: 55,
                      alignment: Alignment.center,
                      decoration: const BoxDecoration(
                        color: mainColor,
                        borderRadius: BorderRadius.all(Radius.circular(48)),
                      ),
                      child: InkWell(
                        onTap: () async {
                          final email = _emailController.text.trim();
                          final password = _passwordController.text.trim();
                          final authService = ref.read(authServiceProvider);

                          try {
                            await authService.signIn(email: email, password: password);

                            if (!context.mounted) return;
                            context.go('/home');
                          } catch (e) {
                            String errorMessage = 'Failed to register';
                            if (e is FirebaseAuthException) {
                              errorMessage = getFirebaseAuthErrorMessage(e);
                            }
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(errorMessage),
                                backgroundColor: const Color(0xFF8B1E3F),
                              ),
                            );
                          }
                        },
                        child: const Text(
                          "Log In",
                          style: TextStyle(
                            color: backGroundColor,
                            fontWeight: FontWeight.w800,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account? ",
                        style: TextStyle(fontSize: 16, color: secondaryColor),
                      ),
                      InkWell(
                        onTap: () {
                          context.go('/register');
                        },
                        child: const Text(
                          "Register Now!",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600, color: mainColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
