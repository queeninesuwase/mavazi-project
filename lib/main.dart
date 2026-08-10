import 'package:flutter/material.dart';
import 'package:mavazi/model/cart.dart';
import 'package:mavazi/screens/login_screen.dart';
import 'package:mavazi/screens/signup_screen.dart';
import 'package:mavazi/screens/home_screen.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create:(context) => CartModel(),
      child:MyApp(),
    )
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,

      home:HomeScreen(),
    
    );
  }
}
