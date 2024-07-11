import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddQuestionScreen extends StatefulWidget {
  @override
  _AddQuestionScreenState createState() => _AddQuestionScreenState();
}

class _AddQuestionScreenState extends State<AddQuestionScreen> {
  final TextEditingController _titleController = TextEditingController();
  final List<String> _topics = [
    'Competitive Programming', 'Flutter', 'Firebase', 'Python', 'C/C++', 'JavaScript', 'Machine Learning', 'Data Science', 'Algorithms', 'Dart'
  ];
  List<String> _selectedTopics = [];
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // For form validation

  void _addQuestion() async {
    if (!_formKey.currentState!.validate() || _selectedTopics.isEmpty) {
      // Validate returns false if form is invalid
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Error'),
          content: Text('Please enter a title and select at least one topic for the question.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    String userId = FirebaseAuth.instance.currentUser!.uid;
    String title = _titleController.text.trim();
    DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    String userName = userSnapshot['username'];

    // Add the question with related topics
    await FirebaseFirestore.instance.collection('questions').add({
      'title': title,
      'upvotes': 0,
      'posted_date': DateTime.now(),
      'user_id': userId,
      'username': userName,
      'question_related': _selectedTopics,
    });

    Navigator.pop(context); // Close the AddQuestionScreen after adding the question
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add a Question'),
      ),
      body: SingleChildScrollView( // Avoids overflow when keyboard is visible
        padding: EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Enter the Question',
                ),
                maxLines: null, // Allows multiple lines
                validator: (value) { // Validates the input
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a question title';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: List<Widget>.generate(_topics.length, (int index) {
                  return ChoiceChip(
                    label: Text(_topics[index]),
                    selected: _selectedTopics.contains(_topics[index]),
                    onSelected: (bool selected) {
                      setState(() {
                        if (selected) {
                          _selectedTopics.add(_topics[index]);
                        } else {
                          _selectedTopics.removeWhere((String name) => name == _topics[index]);
                        }
                      });
                    },
                  );
                }),
              ),
              if (_selectedTopics.isEmpty) // Conditional display of error message
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    'Please select at least one topic',
                    style: TextStyle(color: Colors.orangeAccent, fontSize: 12),
                  ),
                ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _addQuestion,
                child: Text('Add Question'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
