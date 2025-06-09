import 'package:diploma_prj/features/authentication/widgets/text_box_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routing/router_configuration.dart';


const Color buttonColor = Colors.orange;
const Color secondaryColor = Colors.grey;

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({super.key});

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Application",
                style: TextStyle(
                  color: buttonColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 25),

              // Email
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MyControllerTextbox(
                    textBoxController: _emailController,
                    textBoxLabel: 'Your Email',
                    textBoxIcon: Icons.email_outlined),
              ),

              // Username
              Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: MyControllerTextbox(
                      textBoxController: _usernameController,
                      textBoxLabel: 'Your username',
                      textBoxIcon: Icons.supervised_user_circle_outlined),
              ),

              // Password
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: MyControllerTextbox(
                    textBoxController: _passwordController,
                    textBoxLabel: 'Your password',
                    textBoxIcon: Icons.password_outlined),
              ),

              // Sign Up Button
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin: kIsWeb
                      ? const EdgeInsets.symmetric(horizontal: 350)
                      : const EdgeInsets.symmetric(horizontal: 25),
                  height: 50,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: buttonColor,
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                  ),
                  child: InkWell(
                    onTap: () {
                      ref.read(registeredProvider.notifier).state = true;
                      context.go('/home');
                    },
                    child: const Text(
                      "Sign up",
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

              // Login Prompt
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Already have an account? ",
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () {
                      context.go('/login');
                    },
                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 18, color: secondaryColor),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}