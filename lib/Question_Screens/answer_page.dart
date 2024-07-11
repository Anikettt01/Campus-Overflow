import 'package:flutter/material.dart';
import 'add_question.dart';

class AnswerPage extends StatefulWidget {
  final Question question;

  const AnswerPage({Key? key, required this.question}) : super(key: key);

  @override
  State<AnswerPage> createState() => _AnswerPageState();
}

class _AnswerPageState extends State<AnswerPage> {
  TextEditingController answerController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Answer',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.question.title,
              style: TextStyle(
                fontSize: 25,
                fontWeight: FontWeight.bold, // Title color
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16),
            Text(
              widget.question.description,
              style: TextStyle(
                fontSize: 18,
                color: Colors.black87, // Description color
              ),
            ),
            if (widget.question.codeDescription.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 24),
                  Text(
                    'Code:',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue, // Code label color
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.question.codeDescription,
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.black87, // Code description color
                    ),
                  ),
                ],
              ),
            SizedBox(height: 32),
            TextField(
              controller: answerController,
              decoration: InputDecoration(
                hintText: 'Enter your answer...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.grey[200], // Text field background color
              ),
              minLines: 5,
              maxLines: null,
            ),
            SizedBox(height: 24),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  String answer = answerController.text.trim();
                  if (answer.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.red,
                        content: Text('Answer cannot be empty'),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  } else {
                    // Show confirmation dialog
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Confirmation'),
                          content: Text('Are you sure you want to submit your answer?'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(false); // Dismiss the dialog and return false
                              },
                              child: Text('Cancel'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(true); // Dismiss the dialog and return true
                              },
                              child: Text('Submit'),
                            ),
                          ],
                        );
                      },
                    ).then((value) {
                      if (value == true) {
                        // Show snackbar indicating successful submission
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Answer submitted successfully'),
                            duration: Duration(seconds: 2), // Adjust duration as needed
                          ),
                        );

                        // Implement logic to save the answer
                        String answer = answerController.text.trim();
                        // You can use this answer variable to do something with the provided answer
                      }
                    });
                  }
                },
                child: Text(
                  'Submit Answer',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

            ),
          ],
        ),
      ),
    );
  }
}
