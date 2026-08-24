import 'package:mavazi/model/user.dart';

class LoginResult {
  final User user;
  final String accessToken, refreshToken;

  LoginResult({
    required this.user,
    required this.accessToken,
    required this.refreshToken,
  });
}