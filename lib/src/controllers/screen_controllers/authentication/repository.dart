part of '../../../views/screens/authentication/authentication_wrapper_screen.dart';

class _AuthenticationScreenRepository extends HttpRepository {
  // Mock credentials for testing
  static const String _mockEmail = 'test@news.com';
  static const String _mockPassword = 'Test@1234';

  /// [login] - Uses mock credentials for testing
  Future<UserModel?> login({
    required String email,
    required String password,
  }) async {
    UserModel? result;

    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Mock login validation
    if (email == _mockEmail && password == _mockPassword) {
      result = const UserModel(token: 'mock_access_token_12345');
    } else {
      showToast(message: 'Invalid credentials. Use: $_mockEmail / $_mockPassword');
      return null;
    }

    return result;
  }

  /// [signup] - Mock signup that always succeeds
  Future<UserModel?> signup({
    required String email,
    required String password,
  }) async {
    // Simulate network delay
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Mock signup - always succeeds
    showToast(message: 'Account created! You can now login.');
    return const UserModel(token: 'mock_signup_token_12345');
  }
}
