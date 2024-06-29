import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../components/my_button.dart';
import '../components/text_field.dart';
import '../services/auth/auth_service.dart';

class Login extends StatefulWidget {
  const Login({Key? key, required this.onTap}) : super(key: key);
  final void Function()? onTap;

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login() async {
    final authService = Provider.of<AuthService>(context, listen: false);
    try {
      await authService.signInWithEmailAndPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  void forgotPassword() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _resetEmailController =
            TextEditingController();
        String errorMessage = '';

        return AlertDialog(
          title: Text("Reset Password"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _resetEmailController,
                decoration: InputDecoration(hintText: "Enter your email"),
              ),
              SizedBox(height: 10),
              Text(errorMessage, style: TextStyle(color: Colors.red)),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text("Send Reset Link"),
              onPressed: () async {
                try {
                  Navigator.pop(context); 
                  final authService =
                      Provider.of<AuthService>(context, listen: false);
                  await authService.resetPassword(_resetEmailController.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                          "Password reset link sent to ${_resetEmailController.text}"),
                    ),
                  );
                } catch (e) {
                  setState(() {
                    if (e is Exception) {
                      errorMessage = e.toString();
                    } else {
                      errorMessage = 'Failed to send reset email. Please try again.';
                    }
                  });
                }
              },
            ),
            TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context); 
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                SizedBox(height: 10),
                Icon(Icons.account_circle, size: 100, color: Colors.blue),
                SizedBox(height: 10),
                Text(
                  'Welcome to the app',
                  style: TextStyle(fontSize: 24),
                ),
                SizedBox(height: 15),
                TextFieldComponent(
                  hintText: "example@gmail.com",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                ),
                SizedBox(height: 15),
                TextFieldComponent(
                  hintText: "Password",
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                SizedBox(height: 15),
                ButtonComponent(
                  onTap: login,
                  text: "Login",
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Forgot your password?"),
                    TextButton(
                      onPressed: forgotPassword,
                      child: Text("Reset"),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Don't have an account?"),
                    TextButton(
                      onPressed: () {
                        widget.onTap!();
                      },
                      child: Text("Register"),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
