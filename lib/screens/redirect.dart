import 'package:flutter/material.dart';
import 'package:mavazi/screens/home_screen.dart';
import 'package:mavazi/screens/login_screen.dart';
import 'package:mavazi/view_model/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class Redirect  extends StatelessWidget {
  const Redirect({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewmodel>(builder: (context, authViewModel, child){
      var status = authViewModel.authStatus;
      switch(status){
        case AuthStatus.unauthenticated:
          return LoginScreen();
        case AuthStatus.authenticated:
          return HomeScreen();
        
        }
    });
  }

}