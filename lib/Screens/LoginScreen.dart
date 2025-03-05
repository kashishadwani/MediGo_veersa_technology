
import 'package:flutter/material.dart';
import 'package:appointment_scheduling_app/services/auth_services.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void _login() async {
    var user = await _authService.login(
      emailController.text,
      passwordController.text,
    );
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Login failed! Check credentials.")));
    }
  }

  void _googleLogin() async {
    var user = await _authService.googleSignIn();
    if (user != null) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Login", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: _login, child: Text("Login")),
            OutlinedButton(onPressed: _googleLogin, child: Text("Login with Google")),
            TextButton(onPressed: () => Navigator.pushNamed(context, '/signup'), child: Text("Don't have an account? Sign up"))
          ],
        ),
      ),
    );
  }
}
