import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'add_answer_page.dart';

class QuestionDetailsPage extends StatefulWidget {
  final String questionId;
  final String questionTitle;

  QuestionDetailsPage({required this.questionId, required this.questionTitle});

  @override
  _QuestionDetailsPageState createState() => _QuestionDetailsPageState();
}

class _QuestionDetailsPageState extends State<QuestionDetailsPage> {
  List<Answer> answers = [];
  String questionPostedBy = '';
  bool isLoading = true;
  List<String> questionTags = [];

  @override
  void initState() {
    super.initState();
    fetchQuestionAndAnswers();
  }

  Future<void> fetchQuestionAndAnswers() async {
    await fetchQuestionDetails();
    await fetchAnswers();
  }

  Future<void> fetchQuestionDetails() async {
    DocumentSnapshot questionSnapshot = await FirebaseFirestore.instance.collection('questions').doc(widget.questionId).get();
    if (questionSnapshot.exists) {
      Map<String, dynamic> data = questionSnapshot.data() as Map<String, dynamic>;
      setState(() {
        questionPostedBy = data['full_name'] ?? 'Unknown';
        questionTags = List<String>.from(data['question_related'] ?? []);
      });
    }
  }

  Future<void> fetchAnswers() async {
    final querySnapshot = await FirebaseFirestore.instance.collection('answers').where('question_id', isEqualTo: widget.questionId).get();
    final List<Answer> fetchedAnswers = querySnapshot.docs.map((doc) {
      return Answer.fromFirestore(doc.id, doc.data() as Map<String, dynamic>);
    }).toList();

    setState(() {
      answers = fetchedAnswers;
      isLoading = false;
    });
  }

  Future<void> toggleUpvote(Answer answer) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userId = user.uid;
      int newUpvotes = answer.upvotes;
      bool isCurrentlyUpvoted = answer.upvotedUsers.contains(userId);
      List<String> newUpvotedUsers = List.from(answer.upvotedUsers);

      if (isCurrentlyUpvoted) {
        newUpvotes--;
        newUpvotedUsers.remove(userId);
      } else {
        newUpvotes++;
        newUpvotedUsers.add(userId);
      }

      setState(() {
        answer.upvotes = newUpvotes;
        answer.upvotedUsers = newUpvotedUsers;
      });

      final answerRef = FirebaseFirestore.instance.collection('answers').doc(answer.id);
      await answerRef.update({
        'upvotes': newUpvotes,
        'upvoted_users': newUpvotedUsers,
      });

      // Update total_upvotes in the user's document
      final userRef = FirebaseFirestore.instance.collection('users').doc(answer.userId);
      await userRef.update({
        'total_upvotes': FieldValue.increment(isCurrentlyUpvoted ? -1 : 1),
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    answers.sort((a, b) {
      if (a.upvotes == b.upvotes) {
        // If upvotes are equal, sort by time
        return b.postedDate.compareTo(a.postedDate); // Sort by reverse date
      } else {
        // Sort by upvotes in descending order
        return b.upvotes.compareTo(a.upvotes);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('Question Details'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : RefreshIndicator(
        onRefresh: fetchAnswers,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.questionTitle,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Posted by $questionPostedBy',
                    style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Wrap(
                spacing: 8.0,
                runSpacing: 4.0,
                children: [
                  for (var tag in questionTags)
                    Chip(
                      label: Text(tag),
                    ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Answers',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: answers.length,
                itemBuilder: (context, index) {
                  Answer answer = answers[index];
                  return Card(
                    elevation: 2,
                    margin: EdgeInsets.all(10),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            answer.content,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'Posted by ${answer.userName}',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[600],
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            DateFormat('MMM dd, yyyy').format(answer.postedDate),
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Upvotes: ${answer.upvotes}',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green[700],
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  answer.upvotedUsers.contains(FirebaseAuth.instance.currentUser?.uid) ? Icons.thumb_up : Icons.thumb_up_alt_outlined,
                                  color: Theme.of(context).primaryColor,
                                ),
                                onPressed: () {
                                  toggleUpvote(answer);
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AddAnswerScreen(questionId: widget.questionId)),
                  );
                },
                child: Text('Add Answer'),
              ),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}

class Answer {
  final String id;
  final String content;
  final DateTime postedDate;
  final String userId;
  final String userName;
  int upvotes;
  List<String> upvotedUsers;

  Answer({
    required this.id,
    required this.content,
    required this.postedDate,
    required this.userId,
    required this.userName,
    required this.upvotes,
    required this.upvotedUsers,
  });

  factory Answer.fromFirestore(String id, Map<String, dynamic> data) {
    return Answer(
      id: id,
      content: data['content'] ?? '',
      postedDate: (data['date_posted'] as Timestamp).toDate(),
      userId: data['user_id'] ?? '',
      userName: data['username'] ?? 'Anonymous',
      upvotes: data['upvotes'] ?? 0,
      upvotedUsers: List<String>.from(data['upvoted_users'] ?? []),
    );
  }
}
