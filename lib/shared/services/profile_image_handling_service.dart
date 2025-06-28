import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

class ImageStorageService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Pick image from gallery & upload to Firebase Storage
  Future<Uint8List?> pickAndUploadProfileImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return null;

    final Uint8List imageBytes = await image.readAsBytes();
    await uploadProfileImageFromBytes(imageBytes);
    return imageBytes;
  }

  /// Upload image bytes directly
  Future<void> uploadProfileImageFromBytes(Uint8List imageBytes) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception("No user signed in");

    final imageRef =
        _storage.ref().child("users/${user.uid}/profile_picture.jpg");
    await imageRef.putData(imageBytes);
  }

  /// Retrieve profile picture
  Future<Uint8List?> getProfilePicture() async {
    final user = _auth.currentUser;
    if (user == null) return null;

    final imageRef =
        _storage.ref().child("users/${user.uid}/profile_picture.jpg");
    try {
      return await imageRef.getData();
    } catch (e) {
      return null;
    }
  }

  Future<void> deleteProfilePicture() async {
    final user = _auth.currentUser ?? (throw Exception("No user signed in"));
    final uid = user.uid;
    final imageRef = _storage.ref().child("users/$uid/profile_picture.jpg");

    try {
      await imageRef.delete();
      if (kDebugMode) {
        print("Profile picture deleted");
      }
    } on FirebaseException catch (e) {
      if (e.code == 'object-not-found') {
        if (kDebugMode) {
          print("Profile pictur not found, nothing to delete");
        }
      } else {
        if (kDebugMode) {
          print("Failed to delete profile picture $e");
        }
      }
    }
  }

}
