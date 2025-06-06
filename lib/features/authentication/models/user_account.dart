class UserAccount {
  final String displayName;
  final String email;
  final String id;
  final String token;
  final String serverAuthCode;
  final bool isAuthenticated;

  UserAccount({
    this.displayName = '',
    this.email = '',
    this.id = '',
    this.serverAuthCode = '',
    this.isAuthenticated = false,
    this.token = '',
  });

  /// Use this in your UI tests instead of relying on GoogleSignIn
  factory UserAccount.mock({
    String displayName = 'Test User',
    String email = 'test@example.com',
    String id = 'mock-id',
    String token = 'mock-token',
  }) {
    return UserAccount(
      displayName: displayName,
      email: email,
      id: id,
      serverAuthCode: 'mock-auth-code',
      isAuthenticated: true,
      token: token,
    );
  }

  factory UserAccount.defaultAccount() {
    return UserAccount();
  }
}
