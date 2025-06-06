class AuthenticateUserResult {
  final String? jwtToken;
  final String? mockGoogleEmail; // Simulate account data

  AuthenticateUserResult(this.jwtToken, this.mockGoogleEmail);
}
