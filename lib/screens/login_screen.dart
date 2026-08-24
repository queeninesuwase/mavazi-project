import 'package:flutter/material.dart';
import 'package:mavazi/screens/home_screen.dart';
import 'package:mavazi/screens/signup_screen.dart';
import 'package:mavazi/view_model/auth_viewmodel.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() {
    return _LoginScreenState();
  }
}

class _LoginScreenState extends State<LoginScreen> {
  final _loginFormKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _hidePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Form(
            key: _loginFormKey,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 40), 
                  Image.asset(
                    'assets/images/logo.png',
                    width: 160,
                    height: 160,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  TextFormField(
                    controller: _usernameController,
                    keyboardType: TextInputType.name,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.person_2_outlined),
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                      isDense: true, 
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _hidePassword,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.lock_outline),
                      labelText: 'Password',
                      border: const OutlineInputBorder(),
                      isDense: true, 
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 14,
                        horizontal: 16,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _hidePassword
                              ? Icons.visibility_off_outlined
                              : Icons.lock_outlined,
                        ),
                        onPressed: () {
                          setState(() {
                            _hidePassword = !_hidePassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      if (value.length < 6) {
                        return 'Password must be at least 6 characters long';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 24), 

                  Consumer<AuthViewmodel>
                  (builder: (context, authViewModel,child){
                    return ElevatedButton(
                    onPressed: ()async {
                      if (_loginFormKey.currentState!.validate()) {
                        var success = await authViewModel.login(
                          _usernameController.text,
                          _passwordController.text,
                          );

                          if(!context.mounted) return;
                          if(!success){
                            final snackBar = SnackBar(
                              content: Text(authViewModel.errorMessage!),
                              );
                              ScaffoldMessenger.of(
                                context,
                              ).showSnackBar(snackBar);
                          }

                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple, 
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: authViewModel.isloading 
                    ? CircularProgressIndicator()
                    :Text(
                      "Login", style: TextStyle(color: Colors.white)),  
                  );
                  }),
                  
                  const SizedBox(height: 16), 
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account?"),
                      TextButton(
                        onPressed: () {
                          Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>SignupScreen())
                          );
                        },
                        child: const Text("Sign Up", style: TextStyle(color: Colors.deepPurple)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
@override
void dispose(){
  _usernameController.dispose();
  _passwordController.dispose();
  super.dispose();
}
}