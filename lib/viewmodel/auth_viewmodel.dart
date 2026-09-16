import 'package:flutter/material.dart';
import 'package:mavazi/model/api_error.dart';
import 'package:mavazi/model/user.dart';
import 'package:mavazi/services/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AuthStatus { unauthenticated, authenticating, authenticated }

class AuthViewModel extends ChangeNotifier {
  late final AuthApi _authApi;
  bool isLoading = false;

  String? errorMesage;
  static const String ACCESS_TOKEN_KEY = "access_token_key";
  static const String REFRESH_TOKEN_KEY = "refresh_token_key";
  AuthStatus authStatus = AuthStatus.unauthenticated;

  AuthViewModel({AuthApi? authApi}) {
    _authApi = authApi ?? AuthApi();
    _autoLogin();
  }



  Future<bool> login(String username, String password) async {
    authStatus = AuthStatus.authenticating;
    isLoading = true;
    notifyListeners();
    try {
      var result = await _authApi.login(username, password);
      await _saveUserTokens(result.accessToken, result.refreshToken);
      authStatus = AuthStatus.authenticated;
      return true;
    } on ApiError catch (e) {
      errorMesage = e.message;
      authStatus = AuthStatus.unauthenticated;
      return false;
    } catch (e) {
      errorMesage = e.toString();
      authStatus = AuthStatus.unauthenticated;
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveUserTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ACCESS_TOKEN_KEY, accessToken);
    await prefs.setString(REFRESH_TOKEN_KEY, refreshToken);
  }

  Future<void> _autoLogin() async {
    authStatus = AuthStatus.authenticating;
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString(ACCESS_TOKEN_KEY);
    String? refreshToken = prefs.getString(REFRESH_TOKEN_KEY);

    //No tokens found, user is unauthenticated
    if (accessToken == null || refreshToken == null) {
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }

    try {
      final user = await _authApi.fetchCurrentUser(accessToken);
      authStatus = AuthStatus.authenticated;
    } catch (_) {
      try {
        final tokenResponse = await _authApi.refresh(refreshToken);
        accessToken = tokenResponse.accessToken;
        refreshToken = tokenResponse.refreshToken;
        await _saveUserTokens(accessToken, refreshToken);
        authStatus = AuthStatus.authenticated;
      } catch (_) {
        logout();
      }
    }

    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(ACCESS_TOKEN_KEY);
    prefs.remove(REFRESH_TOKEN_KEY);
    authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }
}
