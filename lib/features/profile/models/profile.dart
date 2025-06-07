import 'dart:async';

import 'package:diploma_prj/features/profile/models/profile_alergen.dart';
import 'package:diploma_prj/features/profile/models/profile_diet_restriction.dart';

import '../../../shared/errors/result.dart';
import '../providers/profile_provider.dart';
import 'create_profile.dart';
import 'create_profile_response.dart';
import 'delete_profile_response.dart';


class ProfilesApiClient {
  ProfilesApiClient(String _, dynamic __, String ___); // Dummy constructor for compatibility

  Future<Result<Profile, Exception>> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));

    return Success(
      Profile(
        'mock-id',
        'mockUser',
        'Mock User',
        'https://example.com/profile.jpg',
        'user-123',
        [
          ProfileAlergen('milk', 'Milk'),
          ProfileAlergen('nuts', 'Nuts'),
        ],
        ProfileDietRestriction('vegan', 'Vegan'),
      ),
    );
  }

  Future<Result<CreateProfileResponse, Exception>> createProfile(CreateProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Success(CreateProfileResponse('Mock profile created for ${profile.userName}'));
  }

  Future<Result<CreateProfileResponse, Exception>> updateProfile(CreateProfile profile) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Success(CreateProfileResponse('Mock profile updated for ${profile.userName}'));
  }

  Future<Result<DeleteProfileResponse, Exception>> deleteProfile() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Success(DeleteProfileResponse('Mock profile deleted'));
  }
}
