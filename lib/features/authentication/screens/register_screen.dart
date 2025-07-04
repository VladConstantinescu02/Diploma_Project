import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/widgets/loading_widget.dart';
import '../../../shared/widgets/text_box_widget.dart';
import 'package:go_router/go_router.dart';

import '../services/authentication_service.dart';

// Colors (keep your design)
const Color mainColor = Color(0xFFF27507);
const Color secondaryColor = Color(0xFF3C4C59);
const Color backGroundColor = Color(0xFFFAFAF9);
const Color darkColor = Color(0xFF2B2B2B);

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();

  Uint8List? pickedImage;

  // Pick profile image
  Future<void> pickProfileImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        final imageBytes = await image.readAsBytes();
        setState(() => pickedImage = imageBytes);
      }
    } catch (e) {
      if(context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Image selection failed: ${e.toString()}")),
        );
      }
    }
  }

  // Main register function
  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();
    final username = usernameController.text.trim();

    if (username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Username is required.'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final authService = ref.read(authServiceProvider);

    try {
      final userCredential = await authService.createAccount(email: email, password: password);
      final user = userCredential.user;

      if (user == null) {
        throw Exception('User creation failed');
      }

      await user.updateDisplayName(username);


      await user.getIdToken(true);

      String? profilePhotoUrl;

      if (pickedImage != null) {
        final imageRef = FirebaseStorage.instance
            .ref()
            .child("users/${user.uid}/profile_picture.jpg");

        await imageRef.putData(pickedImage!);
        profilePhotoUrl = await imageRef.getDownloadURL();
      }

      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'userId': user.uid,
        'username': username,
        'email': email,
        'profilePhoto': profilePhotoUrl ?? '',
      });

      if (context.mounted) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => const LoadingScreen(),
        );
      }

      if (!mounted) return;
      context.go('/login');
    } catch (e) {
      String errorMessage = 'Failed to register';
      if (e is FirebaseAuthException) {
        errorMessage = e.message ?? errorMessage;
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: const Color(0xFF8B1E3F),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        color: backGroundColor,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Nice to meet you!",
                style: TextStyle(
                  color: mainColor,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 25),

              // Profile Image Picker
              GestureDetector(
                onTap: pickProfileImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: const Color(0xFFD5E5F2),
                  backgroundImage: pickedImage != null ? MemoryImage(pickedImage!) : null,
                  child: pickedImage == null
                      ? const Icon(Icons.person_add, size: 35, color: Color(0xFF3C4C59))
                      : null,
                ),
              ),


              const SizedBox(height: 25),

              // Email Input
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TemplateControllerTextbox(
                  textBoxController: emailController,
                  textBoxLabel: 'Your Email',
                  textBoxIcon: Icons.email_outlined,
                  textLabelColor: darkColor,
                  textBoxFocusedColor: mainColor,
                  textBoxStaticColor: secondaryColor,
                ),
              ),

              // Username Input
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TemplateControllerTextbox(
                  textBoxController: usernameController,
                  textBoxLabel: 'Your username',
                  textBoxIcon: Icons.supervised_user_circle_outlined,
                  textLabelColor: darkColor,
                  textBoxFocusedColor: mainColor,
                  textBoxStaticColor: secondaryColor,
                ),
              ),

              // Password Input
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TemplateControllerTextbox(
                  textBoxController: passwordController,
                  textBoxLabel: 'Your password',
                  textBoxIcon: Icons.password_outlined,
                  textLabelColor: darkColor,
                  textBoxFocusedColor: mainColor,
                  textBoxStaticColor: secondaryColor,
                ),
              ),

              // Register Button
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
                    color: mainColor,
                    borderRadius: BorderRadius.all(Radius.circular(48)),
                  ),
                  child: InkWell(
                    onTap: register,
                    child: const Text(
                      "Sign up",
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

              // Login Redirect
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account? ", style: TextStyle(fontSize: 16, color: secondaryColor)),
                  InkWell(
                    onTap: () => context.go('/login'),
                    child: const Text("Login", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: mainColor)),
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
