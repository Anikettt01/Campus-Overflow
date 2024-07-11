import 'package:flutter/material.dart';

class AddQuestionPage extends StatefulWidget {
  final Function(Question) onQuestionAdded;

  const AddQuestionPage({Key? key, required this.onQuestionAdded})
      : super(key: key);

  @override
  State<AddQuestionPage> createState() => _AddQuestionPageState();
}

class _AddQuestionPageState extends State<AddQuestionPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  List<String> tags = [
    'Competitive Programming',
    'Flutter Development',
    'MERN Development',
    'Data Science',
    'Machine Learning',
    'Artificial intelligence',
    'Web Development',
    'Android Development',
    'Cyber Security',
    'Software Development',
    'Cloud Computing',
    'Frontend Development',
    'Gaming',
    'Backend Development',
    'Robotics',
    'Computer Networking',
  ];

  String? selectedTag;

  late Color chipColor = const Color.fromRGBO(245, 247, 249, 1);

  bool titleError = false;
  bool descriptionError = false;
  bool isButtonEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Add Question')),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: titleController,
                decoration: InputDecoration(
                  hintText: 'Enter the Title',
                  errorText: titleError ? 'Title cannot be empty' : null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                minLines: 2,
                maxLines: 10,
              ),
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  hintText: 'Enter Description of your question',
                  errorText: descriptionError ? 'Description cannot be empty' : null,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey),
                  ),
                ),
                minLines: 5,
                maxLines: 500,
              ),
            ),

            const SizedBox(height: 25),
            // Chip filter
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text(
                "Select Domain of your Question",
                style: TextStyle(
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 5),
            Wrap(
              spacing: 5.0,
              children: tags.map((tag) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedTag = tag;
                      isButtonEnabled = true; // Enable button when a tag is selected
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Chip(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      backgroundColor: selectedTag == tag
                          ? const Color.fromRGBO(192, 192, 216, 1)
                          : chipColor,
                      side: const BorderSide(
                        color: Color.fromRGBO(245, 247, 249, 1),
                      ),
                      label: Text(
                        tag,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                      padding: const EdgeInsets.all(10),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 25),
            Container(
              child: ElevatedButton(
                onPressed: isButtonEnabled ? _addQuestion : null, // Disable button if no tag is selected
                child: const Text('Add Question'),
              ),
            ),
            const SizedBox(height: 20,)
          ],
        ),
      ),
    );
  }

  void _addQuestion() {
    setState(() {
      titleError = titleController.text.isEmpty;
      descriptionError = descriptionController.text.isEmpty;
    });

    if (!titleError &&
        !descriptionError &&
        selectedTag != null) {
      String title = titleController.text.trim();
      String description = descriptionController.text.trim();
      widget.onQuestionAdded(
        Question(
          title: title,
          description: description,
          code: '', // No code field
          codeDescription: '', // No code description field
          tags: [selectedTag!],
        ),
      );
      Navigator.of(context).pop();
    }
  }
}

class Question {
  final String title;
  final String description;
  final String code;
  final String codeDescription;
  final List<String> tags;

  Question({
    required this.title,
    required this.description,
    required this.code,
    required this.codeDescription,
    required this.tags,
  });
}