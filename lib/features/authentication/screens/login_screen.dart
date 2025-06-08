import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routing/router_configuration.dart';
import '../../../shared/services/authentication_service.dart';

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
            Container(
              width: MediaQuery.of(context).size.width,
              margin: kIsWeb
                  ? const EdgeInsets.symmetric(horizontal: 350)
                  : const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: "email",
                  prefixIcon: Icon(Icons.email),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Password Text Field
            Container(
              width: MediaQuery.of(context).size.width,
              margin: kIsWeb
                  ? const EdgeInsets.symmetric(horizontal: 350)
                  : const EdgeInsets.symmetric(horizontal: 25),
              child: TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "password",
                  prefixIcon: Icon(Icons.lock),
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(height: 25),

            // Login Button (Dummy)
            Container(
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
                onTap: () async {
                  final password = _passwordController.text.trim();
                  final email = _emailController.text.trim();

                  final authService = ref.read(authServiceProvider);

                  try {
                    // Create the account
                    await authService.signIn(
                        email: email, password: password,
                    );

                    // Update UI state or navigate
                    ref.read(loginProvider.notifier).state = true;
                    context.go('/home'); // This works now
                  } catch (e) {
                    print("Login failed: $e");
                    // Show error to user
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                            "Failed to log in, please check your credentials"),
                        backgroundColor: Colors.redAccent,
                        action: SnackBarAction(
                            textColor: Colors.white,
                            label: 'Ok',
                            onPressed: () {}),
                      ),
                    );
                  }
                  ;
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
