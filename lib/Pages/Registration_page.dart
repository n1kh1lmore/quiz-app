import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/my_button.dart';
import '../components/text_field.dart';
import '../services/auth/auth_service.dart';

class RegistrationPage extends StatefulWidget {
  final void Function()? onTap;
  const RegistrationPage({super.key, required this.onTap});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void signUp() async {
    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Password not match')));
      return;
    }

    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);

    try {
      await authService.signUpWithEmailAndPassword(
          _emailController.text, _passwordController.text);
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
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
                //logo
                const SizedBox(
                  height: 10,
                ),
                const Icon(Icons.account_circle, size: 100, color: Colors.blue),
                const SizedBox(
                  height: 10,
                ),
                //welcome message
                const Text(
                  'Welcome to the app',
                  style: TextStyle(fontSize: 24),
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFieldComponent(
                  hintText: "example@gmail.com",
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  obscureText: false,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFieldComponent(
                  hintText: "Password",
                  controller: _passwordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),
                TextFieldComponent(
                  hintText: "Password",
                  controller: _confirmPasswordController,
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                ),
                const SizedBox(
                  height: 15,
                ),

                ButtonComponent(
                    onTap: () {
                      signUp();
                    },
                    text: "Sing Up"),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text("Already have an account?"),
                    TextButton(
                      onPressed: () {
                        widget.onTap!();
                      },
                      child: const Text("Login"),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
