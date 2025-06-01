import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../config/routing/router_configuration.dart';
import 'login_screen.dart';

const Color buttonColor = Colors.orange;
const Color secondaryColor = Colors.grey;

class RegisterScreen extends ConsumerWidget {
  RegisterScreen({Key? key}) : super(key: key);

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
              Text(
                "Application",
                style: TextStyle(
                  color: buttonColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 25),

              const Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(
                      'https://www.pngitem.com/pimgs/m/150-1503945_transparent-user-png-default-user-image-png-png.png',
                    ),
                    backgroundColor: Colors.grey,
                  ),
                  Positioned(
                    bottom: 30,
                    left: 28,
                    child: Icon(Icons.upload, color: Colors.black, size: 34),
                  ),
                ],
              ),
              const SizedBox(height: 15),

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
                decoration: BoxDecoration(
                  color: buttonColor,
                  borderRadius: const BorderRadius.all(Radius.circular(8)),
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
                    child: Text(
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
