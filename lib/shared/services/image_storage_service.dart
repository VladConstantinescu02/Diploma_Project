import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class ImageStorageService {
  final ImagePicker _picker = ImagePicker();
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Pick image from gallery & upload to Firebase Storage
  Future<void> pickAndUploadProfileImage({String? uid}) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) {
      throw Exception('No image selected.');
    }

    final Uint8List imageBytes = await image.readAsBytes();

    // Get uid if not provided
    final String userId = uid ?? _auth.currentUser?.uid ?? (throw Exception("No user signed in"));

    final imageRef = _storage.ref().child("users/$userId/profile_picture.jpg");

    await imageRef.putData(imageBytes);
  }

  /// Upload profile image directly from bytes (ex: from register form)
  Future<void> uploadProfileImageFromBytes(Uint8List imageBytes, {String? uid}) async {
    final String userId = uid ?? _auth.currentUser?.uid ?? (throw Exception("No user signed in"));

    final imageRef = _storage.ref().child("users/$userId/profile_picture.jpg");

    await imageRef.putData(imageBytes);
  }

  /// Retrieve profile picture from Firebase Storage
  Future<Uint8List?> getProfilePicture({String? uid}) async {
    final String userId = uid ?? _auth.currentUser?.uid ?? (throw Exception("No user signed in"));

    final imageRef = _storage.ref().child("users/$userId/profile_picture.jpg");

    try {
      final Uint8List? imageBytes = await imageRef.getData();
      return imageBytes;
    } catch (e) {
      // File not found or download error
      return null;
    }
  }
}
