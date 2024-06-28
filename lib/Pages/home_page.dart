import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:animate_do/animate_do.dart'; // Import animate_do package
import '../services/auth/auth_service.dart';
import 'result_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  int score = 0;
  List<String> selectedOptions = [];
  List<Map<String, dynamic>> questions = [];

  // Instance of auth
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    var fetchedQuestions = await getQuestions();
    if (fetchedQuestions.length < 3) {
      setState(() {
        questions = [];
      });
    } else {
      setState(() {
        questions = fetchedQuestions.take(5).toList();
        selectedOptions = List<String>.filled(questions.length, '');
      });
    }
  }

  Future<List<Map<String, dynamic>>> getQuestions() async {
    var snapshot = await FirebaseFirestore.instance.collection('Test').get();
    return snapshot.docs.map((doc) => doc.data()).toList();
  }

  void signOut() {
    // Get auth service
    final authService = Provider.of<AuthService>(context, listen: false);
    authService.signOut();
  }

  void goToNextPage() {
    setState(() {
      if (currentPage < questions.length - 1) {
        currentPage++;
        _pageController.nextPage(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ResultPage(score: score, total: questions.length),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quiz App'),
        backgroundColor: Colors.blueAccent,
      ),
      body: questions.isEmpty
          ? const Center(
              child: Text(
                'Not enough questions available',
                style: TextStyle(fontSize: 20, color: Colors.red),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(16.0),
              child: PageView.builder(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: questions.length,
                itemBuilder: (context, index) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: child,
                      );
                    },
                    child: buildQuestionPage(index),
                  );
                },
              ),
            ),
    );
  }

  Widget buildQuestionPage(int questionIndex) {
    var question = questions[questionIndex];
    var options = question['options'] as Map<String, dynamic>;

    return FadeInDown(
            duration: const Duration(milliseconds: 500),

      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Question ${questionIndex + 1} of ${questions.length}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              question['title'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            for (var option in options.keys)
              buildOptionTile(questionIndex, option, options[option]),
          ],
        ),
      ),
    );
  }

  Widget buildOptionTile(int questionIndex, String optionKey, String optionValue) {
    Color tileColor = Colors.transparent;
    IconData? icon;
    if (selectedOptions[questionIndex] != '') {
      tileColor = optionKey == questions[questionIndex]['correctOption']
          ? Colors.green[100]!
          : selectedOptions[questionIndex] == optionKey
              ? Colors.red[100]!
              : Colors.transparent;
      icon = optionKey == questions[questionIndex]['correctOption']
          ? Icons.check
          : selectedOptions[questionIndex] == optionKey
              ? Icons.close
              : null;
    }

    return FadeInDown(
      duration: const Duration(milliseconds: 500),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: tileColor,
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: selectedOptions[questionIndex] == optionKey
                ? Colors.blueAccent
                : Colors.grey,
            width: 2.0,
          ),
        ),
        child: ListTile(
          leading: icon != null ? Icon(icon, color: icon == Icons.check ? Colors.green : Colors.red) : null,
          title: Text(
            optionValue,
            style: const TextStyle(fontSize: 18),
          ),
          onTap: (selectedOptions[questionIndex] == '')
              ? () {
                  setState(() {
                    selectedOptions[questionIndex] = optionKey;
                    if (selectedOptions[questionIndex] == questions[questionIndex]['correctOption']) {
                      score++;
                    }
                    Future.delayed(const Duration(milliseconds: 500), goToNextPage);
                  });
                }
              : null,
        ),
      ),
    );
  }
}
