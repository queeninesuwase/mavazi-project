import 'dart:convert';

import 'package:mavazi/model/api_error.dart';
import 'package:mavazi/model/login_result.dart';
import 'package:mavazi/model/user.dart';
import 'package:http/http.dart' as http;

class AuthApi {
  static const baseurl= 'https://dummyjson.com';


  Future<LoginResult> login(String username, String password) async{
    final response = await http.post(Uri.parse('$baseurl/auth/login'),
    headers: {'Content-Type': 'application/JSON'},
    body: jsonEncode({'username': username,'password': password}),
    );
    if(response.statusCode!= 200){
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
}