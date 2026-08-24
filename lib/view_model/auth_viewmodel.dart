

import 'package:flutter/material.dart';
import 'package:mavazi/model/api_error.dart';
import 'package:mavazi/model/user.dart';
import 'package:mavazi/services/auth_api.dart';
import 'package:shared_preferences/shared_preferences.dart';


enum AuthStatus{
  unauthenticated,
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

  }

  Future<bool> login(String username, String password)async {
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

  Future<bool> tokensPresent() async{
    final prefs = await SharedPreferences.getInstance();
    final access =  prefs.getString(ACCESS_TOKEN_KEY);
    final refresh = prefs.getString(REFRESH_TOKEN_KEY);

    return access!= null && refresh != null;
  }
}