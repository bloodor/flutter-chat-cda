import 'package:flutter/material.dart';
import 'auth_service.dart';

class LoginRegisterScreen extends StatefulWidget {
  final AuthService authService;
  final Function(String userId, String streamToken) onAuthenticated;

  const LoginRegisterScreen({
    super.key,
    required this.authService,
    required this.onAuthenticated,
  });

  @override
  _LoginRegisterScreenState createState() => _LoginRegisterScreenState();
}

class _LoginRegisterScreenState extends State<LoginRegisterScreen> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLogin = true;

  void _authenticate() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    try {
      final streamToken = _isLogin
          ? await widget.authService.login(username, password)
          : await widget.authService.register(username, password);

      widget.onAuthenticated(username, streamToken);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Authentication failed: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _authenticate,
              child: Text(_isLogin ? 'Login' : 'Register'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  _isLogin = !_isLogin;
                });
              },
              child: Text(_isLogin ? 'Don\'t have an account? Register' : 'Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}