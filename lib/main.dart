import 'package:flutter/material.dart';
import 'package:mavazi/model/cart.dart';
import 'package:mavazi/screens/login_screen.dart';
import 'package:mavazi/screens/redirect.dart';
import 'package:mavazi/screens/signup_screen.dart';
import 'package:mavazi/screens/home_screen.dart';
import 'package:mavazi/view_model/auth_viewmodel.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartModel()),
        ChangeNotifierProvider(create: (_) => AuthViewmodel()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home:Redirect(),
    
    );
  }
}
