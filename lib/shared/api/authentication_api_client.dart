import '../../features/authentication/models/get_auth_token_request.dart';
import '../errors/result.dart';

class AuthenticationApiClient {
  AuthenticationApiClient(); // no arguments for mock

  Future<Result<String?, Exception>> getAuthenticationToken(
      GetAuthTokenRequest getAuthTokenRequest) async {
    await Future.delayed(const Duration(milliseconds: 300)); // simulate network delay

    if (getAuthTokenRequest.idToken == 'valid-mock-token') {
      return const Success('mock-auth-token');
    } else {
      return Failure(Exception('Invalid token'));
    }
  }
}
