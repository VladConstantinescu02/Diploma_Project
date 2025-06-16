import 'dart:typed_data';
import 'package:flutter/material.dart';
import '../services/profile_image_handling_service.dart';

class ProfilePictureWidget extends StatefulWidget {
  const ProfilePictureWidget({super.key});

  @override
  State<ProfilePictureWidget> createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  Uint8List? profileImage;
  final ImageStorageService imageStorageService = ImageStorageService();

  @override
  void initState() {
    super.initState();
    loadProfileImage();
  }

  Future<void> loadProfileImage() async {
    final image = await imageStorageService.getProfilePicture();
    if (!mounted) return;
    setState(() => profileImage = image);
  }

  Future<void> onProfileTapped() async {
    try {
      await imageStorageService.pickAndUploadProfileImage();
      await loadProfileImage();  // reload image after upload
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTap: onProfileTapped,
      child: CircleAvatar(
        radius: 50,
        backgroundColor: const Color(0xFFD5E5F2),
        backgroundImage: profileImage != null ? MemoryImage(profileImage!) : null,
        child: profileImage == null
            ? const Icon(Icons.person_add, size: 35, color: Color(0xFF3C4C59))
            : null,
      ),
    );
  }
}

