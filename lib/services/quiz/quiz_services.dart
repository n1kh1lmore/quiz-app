import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../model/questions_model.dart';

class ChatService extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Question>> getQuestions() async {
    try {
      var snapshot = await _firestore.collection('Test').get();
      return snapshot.docs.map((doc) => Question.fromJson(doc.data())).toList();
    } catch (e) {
      return [];
    }
  }
}
