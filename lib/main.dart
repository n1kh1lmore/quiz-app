import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'services/auth/auth_gate.dart';
import 'services/auth/auth_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
              apiKey: 'AIzaSyAUbLddhJlcCTVZa0SHTzg79TGUf-pVTq8',
              appId: "1:235353604058:android:d0988599e6ada44c6b8ae3",
              messagingSenderId: "235353604058",
              projectId: "quiz-app-f9333"))
      : await Firebase.initializeApp();
  runApp(ChangeNotifierProvider(
    create: (context) => AuthService(),
    child: const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuthGate(),
    );
  }
}
