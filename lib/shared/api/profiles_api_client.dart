import '../../features/profile/models/create_profile.dart';
import '../../features/profile/models/create_profile_response.dart';
import '../../features/profile/models/delete_profile_response.dart';
import '../../features/profile/models/profile.dart';
import '../errors/result.dart';

class ProfilesApiClient {
  ProfilesApiClient(String _, dynamic __, String ___); // Constructor stays the same

  Future<Result<Profile, Exception>> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Success(Profile(
      name: 'Mock User',
      dietaryOptionId: 1,
      ingredientAllergies: ['Milk', 'Gluten'],
      profilePhotoUrl: 'https://example.com/mock-photo.jpg',
    ));
  }

  @override
  Future<Result<CreateProfileResponse, Exception>> createProfile(CreateProfile createProfile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Success(CreateProfileResponse('Profile created for ${createProfile.userName}'));
  }

  Future<Result<CreateProfileResponse, Exception>> updateProfile(CreateProfile createProfile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Success(CreateProfileResponse('Profile updated for ${createProfile.userName}'));
  }

  Future<Result<DeleteProfileResponse, Exception>> deleteProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Success(DeleteProfileResponse('Profile successfully deleted'));
  }
}