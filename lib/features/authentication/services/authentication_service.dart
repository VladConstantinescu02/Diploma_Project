import '../../../shared/api/authentication_api_client.dart';
import '../../../shared/errors/result.dart';
import '../models/authenticate_user_result.dart';
import '../models/get_auth_token_request.dart';

class AuthenticationService {
  final AuthenticationApiClient _authenticationApiClient;

  AuthenticationService({required AuthenticationApiClient authenticationApiClient})
      : _authenticationApiClient = authenticationApiClient;

  Future<Result<AuthenticateUserResult, Exception>> authenticateUser() async {
    // Simulate a UI login delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Simulate an "idToken" retrieved from UI input
    const fakeIdToken = 'valid-mock-token';

    final apiJwtTokenResult =
    await _authenticationApiClient.getAuthenticationToken(GetAuthTokenRequest(fakeIdToken));

    return switch (apiJwtTokenResult) {
      Success<String?, Exception>() =>
          Success(AuthenticateUserResult(apiJwtTokenResult.value, 'mockuser@example.com')),
      Failure<String?, Exception>() =>
          Failure(Exception(apiJwtTokenResult.exception.toString())),
    };
  }

  Future<Result<void, Exception>> logoutUser() async {
    await Future.delayed(const Duration(milliseconds: 150));
    return const Success(null); // no-op for UI testing
  }
}
