import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class ResultPage extends StatefulWidget {
  final int score;
  final int total;

  const ResultPage({Key? key, required this.score, required this.total}) : super(key: key);

  @override
  State<ResultPage> createState() => _ResultPageState();
}

class _ResultPageState extends State<ResultPage> {
    final FirebaseAuth _auth = FirebaseAuth.instance;
      final FirebaseFirestore _firestore = FirebaseFirestore.instance;


  Future<void> saveOrUpdateScore() async {
    User? user = _auth.currentUser;
    if (user != null) {
      final userDoc = _firestore.collection('users').doc(user.uid);
      var userData = await userDoc.get();
      if (userData.exists && userData.data()!.containsKey('score')) {
        await userDoc.update({
          'score': widget.score,
        });
      } else {
        await userDoc.set({
          'score': widget.score,
        }, SetOptions(merge: true));
      }
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    saveOrUpdateScore();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz Result'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Your Score',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${widget.score} / ${widget.total}',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: widget.score == widget.total ? Colors.green : Colors.red,
              ),
            ),
            if (widget.score == widget.total)
        const      Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Congratulations! Perfect Score!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
              },
              child: const Text('Go Back'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                textStyle: const TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
