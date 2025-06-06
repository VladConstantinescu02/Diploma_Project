import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/errors/result.dart';
import '../models/authenticate_user_result.dart';
import '../models/user_account.dart';
import '../providers/profile_provider.dart' as profile_provider;
import '../services/authentication_service.dart';
import 'authentication_service_provider.dart';

class Authentication extends AutoDisposeAsyncNotifier<UserAccount> {
  AuthenticationService get _authenticationService =>
      ref.watch(authenticationServiceProvider);
  SecureStorage get _secureStorage => ref.watch(secureStorageProvider);
  AsyncValue get _profileState =>
      ref.watch(profile_provider.profileProvider);

  Future<void> signInWithGoogle() async {
    state = const AsyncLoading();

    final result = await _authenticationService.authenticateUser();

    if (result is Success<AuthenticateUserResult?, Exception>) {
      final mockEmail = result.value?.mockGoogleEmail;

      if (mockEmail != null) {
        final userAccount = UserAccount.mock(email: mockEmail, token: result.value?.jwtToken ?? '');
        state = AsyncValue.data(userAccount);

        await _secureStorage.setUserAccountState(userAccount);
        await ref.read(profile_provider.profileProvider.notifier).getProfile();
      } else {
        state = AsyncError('Mock Google account is null', StackTrace.current);
      }
    } else if (result is Failure<AuthenticateUserResult?, Exception>) {
      state = AsyncError(result.exception.toString(), StackTrace.current);
    }
  }

  Future<void> signOut() async {
    final result = await _authenticationService.logoutUser();

    if (result is Success) {
      state = AsyncValue.data(UserAccount.defaultAccount());
      await _secureStorage.clearStorage();
    } else if (result is Failure) {
      state = AsyncError(result.exception.toString(), StackTrace.current);
    }
  }

  @override
  Future<UserAccount> build() async {
    final result = await _secureStorage.getUserAccountState();

    if (result is Success<UserAccount?, Exception>) {
      final account = result.value ?? UserAccount.defaultAccount();
      return account;
    } else {
      return UserAccount.defaultAccount();
    }
  }
}
