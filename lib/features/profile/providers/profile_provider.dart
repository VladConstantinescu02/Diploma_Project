import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../models/create_profile.dart';
import '../models/profile.dart';
import '../models/profile_alergen.dart';
import '../models/profile_diet_restriction.dart';


class Profile extends Profile {
  @override
  Future<Profile> build() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return Profile(
      'mock-id',
      'mockUser',
      'Mock User',
      'https://example.com/profile.jpg',
      'user-123',
      [
        ProfileAlergen('milk', 'Milk'),
        ProfileAlergen('peanuts', 'Peanuts'),
      ],
      ProfileDietRestriction('1', 'Vegan'),
    );
  }

  Future<void> getProfile() async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 300));
    state = AsyncValue.data(
      Profile(
        'mock-id',
        'mockUser',
        'Mock User',
        'https://example.com/profile.jpg',
        'user-123',
        [
          ProfileAlergen('milk', 'Milk'),
          ProfileAlergen('peanuts', 'Peanuts'),
        ],
        ProfileDietRestriction('1', 'Vegan'),
      ),
    );
  }

  Future<void> createProfile(CreateProfile profile, BuildContext context) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 300));
    state = AsyncValue.data(
      Profile(
        'created-id',
        profile.userName,
        profile.userName,
        '',
        'user-123',
        profile.ingredientAllergies
            ?.map((id) => ProfileAlergen(id, id))
            .toList() ??
            [],
        ProfileDietRestriction(
          profile.dietaryOptionId?.toString() ?? '0',
          'Diet Option ${profile.dietaryOptionId ?? 0}',
        ),
      ),
    );
  }

  Future<void> updateProfile(CreateProfile profile, BuildContext context) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 300));
    state = AsyncValue.data(
      Profile(
        'updated-id',
        profile.userName,
        profile.userName,
        '',
        'user-123',
        profile.ingredientAllergies
            ?.map((id) => ProfileAlergen(id, id))
            .toList() ??
            [],
        ProfileDietRestriction(
          profile.dietaryOptionId?.toString() ?? '0',
          'Diet Option ${profile.dietaryOptionId ?? 0}',
        ),
      ),
    );
    context.go('/profile');
  }

  Future<void> deleteProfile(BuildContext context) async {
    state = const AsyncLoading();
    await Future.delayed(const Duration(milliseconds: 300));
    state = AsyncValue.data(Profile.defaultProfile());
  }
}
