import 'package:diploma_prj/shared/widgets/text_box_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routing/router_configuration.dart';

// Replace with actual colors or use default Material colors
const Color buttonColor = Colors.orange;
const Color secondaryColor = Colors.grey;

class LoginScreen extends ConsumerWidget {
  LoginScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Application",
              style: TextStyle(
                  color: buttonColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w900),
            ),
            const Text(
              "Login",
              style: TextStyle(
                  fontSize: 23,
                  color: secondaryColor,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 25),

            // Email Text Field
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MyControllerTextbox(
                textBoxController: _emailController,
                textBoxLabel: 'Email address',
                textBoxIcon: Icons.email_outlined,
              ),
            ),

            // Password Text Field
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: MyControllerTextbox(
                textBoxController: _passwordController,
                textBoxLabel: 'Password',
                textBoxIcon: Icons.password_outlined),
            ),

            // Login Button (Dummy)
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
                  color: buttonColor,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: InkWell(
                  onTap: () {
                    // Dummy placeholder
                    ref.read(authProvider.notifier).state = true;
                    ref.read(registeredProvider.notifier).state =
                        true; // if already has profile
                    context.go('/home'); // This works now
                  },
                  child: const Text(
                    "Log In",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 18),

            // Sign Up Prompt (Dummy Navigation)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Don't have an account? ",
                    style: TextStyle(fontSize: 16)),
                InkWell(
                  onTap: () {
                    context.go('/register');
                  },
                  child: const Text(
                    "Register Now!",
                    style: TextStyle(fontSize: 18, color: secondaryColor),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
