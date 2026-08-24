

import 'package:flutter/material.dart';
import 'package:mavazi/model/api_error.dart';
import 'package:mavazi/model/token_response.dart';
import 'package:mavazi/model/user.dart';
import 'package:mavazi/services/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum AuthStatus{
  unauthenticated,
  authenticating,
  authenticated
}

class AuthViewmodel  extends ChangeNotifier{
  late final AuthApi _authApi;
  bool isloading = false;



  User? user;
  String? errorMessage;
  static const String ACCESS_TOKEN_KEY = "access_token_key";
  static const String REFRESH_TOKEN_KEY = "refresh_token_key";
  AuthStatus authStatus = AuthStatus.unauthenticated;

  AuthViewmodel({AuthApi? authApi}) {
    _authApi = authApi ?? AuthApi();
    autologin();

  }

  Future<bool> login(String username, String password)async {
    authStatus = AuthStatus.authenticating;
    isloading = true;
    try{
      var result = await _authApi.login(username, password);
      user = result.user;
      await saveUserTokens(result.accessToken, result.refreshToken);
      authStatus = AuthStatus.authenticated;
      return true;
    }on ApiError catch(e){
      errorMessage = e.message;
      authStatus = AuthStatus.unauthenticated;

      return false;
    }catch(e){
      errorMessage = e.toString();
      authStatus = AuthStatus.unauthenticated;
      return false;
    }finally{
      isloading = false;
      notifyListeners();
    }
  }

  Future<void> saveUserTokens(String accessToken, String refreshToken) async{
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(ACCESS_TOKEN_KEY, accessToken);
    await prefs.setString(REFRESH_TOKEN_KEY, refreshToken);

  }

  Future<void> autologin() async{
    authStatus = AuthStatus.authenticating;
    final prefs = await SharedPreferences.getInstance();
    String? accessToken = prefs.getString(ACCESS_TOKEN_KEY);
    String? refreshToken = prefs.getString(REFRESH_TOKEN_KEY);
    if(accessToken !=null || refreshToken !=null){
      authStatus = AuthStatus.unauthenticated;
      notifyListeners();
      return;
    }
    
    try {
      final user = await _authApi.fetchCurrentUser(accessToken!);
      authStatus = AuthStatus.authenticated;
    }catch(_) {
     try {
      final tokenResponse = await _authApi.refresh(refreshToken!);
      accessToken = tokenResponse.accessToken;
      refreshToken = tokenResponse.refreshToken;
      await saveUserTokens(accessToken, refreshToken);
      authStatus = AuthStatus.authenticated;
     } catch (_) {
      logout();
     }
    }
  }
  
  Future<void> logout() async{
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(ACCESS_TOKEN_KEY);
    prefs.remove(REFRESH_TOKEN_KEY);
    authStatus = AuthStatus.unauthenticated;
    notifyListeners();
  }


  
}