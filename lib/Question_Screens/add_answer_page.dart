import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddAnswerScreen extends StatefulWidget {
  final String questionId;

  AddAnswerScreen({required this.questionId});

  @override
  _AddAnswerScreenState createState() => _AddAnswerScreenState();
}

class _AddAnswerScreenState extends State<AddAnswerScreen> {
  final TextEditingController _contentController = TextEditingController();

  void _addAnswer() async {
    String userId = FirebaseAuth.instance.currentUser!.uid;
    String content = _contentController.text.trim();

    if (content.isNotEmpty) {
      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
      String userName = userSnapshot['username'];

      await FirebaseFirestore.instance.collection('answers').add({
        'content': content,
        'upvotes': 0,
        'date_posted': DateTime.now(),
        'user_id': userId,
        'username': userName,
        'question_id': widget.questionId,
      });
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter content for the answer.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add an Answer'),
      ),
      body: Padding(
        padding: EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _contentController,
              decoration: InputDecoration(
                labelText: 'Answer Content',
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _addAnswer,
              child: Text('Add Answer'),
            ),
          ],
        ),
      ),
    );
  }
}
