import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routing/router_configuration.dart';
import '../../../shared/services/authentication_service.dart';

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
              Container(
                width: MediaQuery.of(context).size.width,
                margin: kIsWeb
                    ? const EdgeInsets.symmetric(horizontal: 350)
                    : const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: "Enter Email",
                    prefixIcon: Icon(Icons.email),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Username
              Container(
                width: MediaQuery.of(context).size.width,
                margin: kIsWeb
                    ? const EdgeInsets.symmetric(horizontal: 350)
                    : const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: "Enter Username",
                    prefixIcon: Icon(Icons.person),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Password
              Container(
                width: MediaQuery.of(context).size.width,
                margin: kIsWeb
                    ? const EdgeInsets.symmetric(horizontal: 350)
                    : const EdgeInsets.symmetric(horizontal: 25),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: "Enter Password",
                    prefixIcon: Icon(Icons.lock),
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Sign Up Button
              Container(
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
                  onTap: () async {
                    final email = _emailController.text.trim();
                    final password = _passwordController.text.trim();
                    final username = _usernameController.text.trim();

                    final authService = ref.read(authServiceProvider);

                    try {
                      // Create the account
                      await authService.createAccount(email: email, password: password);

                      // Optionally update the display name
                      await authService.updateUsername(username: username);

                      // Update UI state or navigate
                      ref.read(registeredProvider.notifier).state = true;
                      context.go('/fridge');
                    } catch (e) {
                      print("Registration failed: $e");
                      // Show error to user
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: const Text("Failed to register, please add valid credentials"),
                            backgroundColor: Colors.redAccent,
                            action: SnackBarAction(textColor: Colors.white, label: 'Ok', onPressed: () { }),
                        ),
                      );
                    }
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