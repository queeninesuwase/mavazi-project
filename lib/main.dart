import 'package:flutter/material.dart';
import 'package:mavazi/model/cart.dart';
import 'package:mavazi/screens/home_screen.dart';
import 'package:mavazi/screens/login_screen.dart';
import 'package:mavazi/screens/redirect.dart';
import 'package:mavazi/screens/signup_screen.dart';
import 'package:mavazi/viewmodel/auth_viewmodel.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => AuthViewModel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Elms Sans'),
      home: Redirect(),
    );
  }
}
