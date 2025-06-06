import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../api/authentication_api_client.dart';

final authenticationApiClientProvider = Provider<AuthenticationApiClient>((ref) {
  return AuthenticationApiClient(); // uses the mock version
});
