import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
//instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signOut() {
    // get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Homepage'),
        actions: [
          IconButton(
              onPressed: () {
                signOut();
              },
              icon: const Icon(Icons.logout))
        ],
      ),
      body: const Center(
        child: Column(children: [
          SizedBox(
            height: 20,
          ),
          Text('Welcome to the app'),
          SizedBox(
            height: 20,
          ),
          Text('This is the home page'),
          SizedBox(
            height: 20,
          ),
        
        ],),
      ),
    );
  }
}
