import 'dart:convert';
import '../../features/authentication/models/user_account.dart';
import '../errors/result.dart';

/// Mock version for UI testing: uses in-memory Map
class SecureStorage {
  final Map<String, String> _mockStorage = {};

  final String _accessUserAccountStateKey = "accessUserAccountState";

  Future<Result<void, Exception>> setUserAccountState(UserAccount userAccountState) async {
    try {
      _mockStorage[_accessUserAccountStateKey] = jsonEncode({
        'displayName': userAccountState.displayName,
        'email': userAccountState.email,
        'id': userAccountState.id,
        'token': userAccountState.token,
        'serverAuthCode': userAccountState.serverAuthCode,
        'isAuthenticated': userAccountState.isAuthenticated,
      });
      return const Success(null);
    } catch (e) {
      return Failure(Exception("Unable to set user account"));
    }
  }

  Future<Result<UserAccount?, Exception>> getUserAccountState() async {
    try {
      final userAccountStateString = _mockStorage[_accessUserAccountStateKey];
      if (userAccountStateString == null) {
        return const Success(null);
      }
      final decoded = jsonDecode(userAccountStateString);
      return Success(UserAccount(
        displayName: decoded['displayName'] ?? '',
        email: decoded['email'] ?? '',
        id: decoded['id'] ?? '',
        token: decoded['token'] ?? '',
        serverAuthCode: decoded['serverAuthCode'] ?? '',
        isAuthenticated: decoded['isAuthenticated'] ?? false,
      ));
    } catch (e) {
      return Failure(Exception("Unable to get user account"));
    }
  }

  Future<Result<void, Exception>> clearStorage() async {
    try {
      _mockStorage.clear();
      return const Success(null);
    } catch (e) {
      return Failure(Exception("Unable to clear storage"));
    }
  }
}
