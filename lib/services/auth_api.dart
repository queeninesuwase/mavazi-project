import 'dart:convert';

import 'package:mavazi/model/api_error.dart';
import 'package:mavazi/model/login_result.dart';
import 'package:http/http.dart' as http;
import 'package:mavazi/model/token_response.dart';
import 'package:mavazi/model/user.dart';

class AuthApi {
  static const baseUrl = 'https://dummyjson.com';
  late http.Client _client;

  AuthApi({http.Client? client}) {
    _client = client ?? http.Client();
  }

  Future<LoginResult> login(String username, String password) async {
    final response = await _client.post(
      Uri.parse('$baseUrl/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 1,
      }),
    );
    if (response.statusCode != 200) {
      var errorBody = jsonDecode(response.body);
      throw ApiError(message: errorBody['message'] ?? 'Login Failed');
    }

    var responseJson = jsonDecode(response.body);
    return LoginResult(
      user: User.fromJson(responseJson),
      accessToken: responseJson['accessToken'],
      refreshToken: responseJson['refreshToken'],
    );
  }

  Future<User> fetchCurrentUser(String accessToken) async {
    final response = await _client.get(
      Uri.parse("$baseUrl/auth/me"),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      var errorBody = jsonDecode(response.body);
      throw ApiError(message: errorBody['message'] ?? 'Token expired');
    }

    var json = jsonDecode(response.body);
    return User.fromJson(json);
  }

  Future<TokenResponse> refresh(String refreshToken) async {
    final response = await _client.post(
      Uri.parse("$baseUrl/auth/refresh"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'refreshToken': refreshToken}),
    );

    if (response.statusCode != 200) {
      var errorBody = jsonDecode(response.body);
      throw ApiError(message: errorBody['message'] ?? 'Token refresh failed');
    }

    var json = jsonDecode(response.body);
    return TokenResponse(json['accessToken'], json['refreshToken']);
  }
}
