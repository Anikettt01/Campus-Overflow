import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'question_model.dart';
import 'question_add_page.dart';
import 'question_detailed_view.dart';
import 'add_answer_page.dart';

class QuestionPage extends StatefulWidget {
  @override
  _QuestionPageState createState() => _QuestionPageState();
}

class _QuestionPageState extends State<QuestionPage> {
  late String currentUserId;
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    getCurrentUserId().then((userId) {
      setState(() {
        currentUserId = userId;
      });
    });
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<String> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  void toggleUpvote(Question question, bool isUpvoted) {
    if (isUpvoted) {
      FirebaseFirestore.instance.collection('questions').doc(question.id).update({
        'upvoted_users': FieldValue.arrayRemove([currentUserId]),
        'upvotes': FieldValue.increment(-1),
      });
    } else {
      FirebaseFirestore.instance.collection('questions').doc(question.id).update({
        'upvoted_users': FieldValue.arrayUnion([currentUserId]),
        'upvotes': FieldValue.increment(1),
      });
    }
  }

  void toggleBookmark(Question question, bool isBookmarked) {
    if (isBookmarked) {
      FirebaseFirestore.instance.collection('questions').doc(question.id).update({
        'bookmarked_users': FieldValue.arrayRemove([currentUserId]),
      });
    } else {
      FirebaseFirestore.instance.collection('questions').doc(question.id).update({
        'bookmarked_users': FieldValue.arrayUnion([currentUserId]),
      });
    }
  }

  Widget buildQuestionList(List<Question> questions) {
    return ListView.builder(
      itemCount: questions.length,
      itemBuilder: (context, index) {
        Question question = questions[index];
        bool isUpvoted = question.upvotedUsers.contains(currentUserId);
        bool isBookmarked = question.bookmarkedUsers.contains(currentUserId);
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => QuestionDetailsPage(questionId: question.id, questionTitle: question.title)),
            );
          },
          child: Card(
            elevation: 5,
            margin: EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          question.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          toggleBookmark(question, isBookmarked);
                        },
                        child: Icon(
                          isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                          color: isBookmarked ? Colors.orange : null,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.person, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(question.userName, style: TextStyle(fontSize: 14, color: Colors.grey)),
                      Spacer(),
                      Icon(Icons.calendar_today, size: 16, color: Colors.grey),
                      SizedBox(width: 4),
                      Text(
                        DateFormat.yMMMd().format(question.postedDate),
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(color: Colors.grey),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () {
                          toggleUpvote(question, isUpvoted);
                        },
                        child: Row(
                          children: [
                            Icon(
                              Icons.arrow_upward,
                              color: isUpvoted ? Colors.blue : null,
                              size: 20,
                            ),
                            SizedBox(width: 4),
                            Text(
                              question.upvotes.toString(),
                              style: TextStyle(fontSize: 16, color: isUpvoted ? Colors.blue : Colors.grey),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AddAnswerScreen(questionId: question.id)),
                          );
                        },
                        child: Row(
                          children: [
                            Icon(Icons.add_comment, size: 20),
                            SizedBox(width: 4),
                            Text('Add Answer', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Questions'),
        actions: [
          IconButton(
            icon: Icon(Icons.add_circle),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddQuestionScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by question title...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  // Perform search based on value
                });
              },
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance.collection('questions').orderBy('posted_date', descending: true).snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                List<Question> questions = snapshot.data!.docs.map((doc) => Question.fromFirestore(doc)).toList();

                if (_searchController.text.isNotEmpty) {
                  questions = questions.where((q) => q.title.toLowerCase().contains(_searchController.text.toLowerCase())).toList();
                }

                return buildQuestionList(questions);
              },
            ),
          ),
        ],
      ),
    );
  }
}
