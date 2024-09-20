import 'package:flutter/material.dart';
import 'add_question.dart';

class AnswerDetailsPage extends StatefulWidget {
  final Question question;
  final List<String> answers;

  const AnswerDetailsPage({Key? key, required this.question, required this.answers}) : super(key: key);

  @override
  State<AnswerDetailsPage> createState() => _AnswerDetailsPageState();
}

class _AnswerDetailsPageState extends State<AnswerDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height:70),
            Text(
              'Answers for ${widget.question.title}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.question.description,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 16),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: widget.answers.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(widget.answers[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
