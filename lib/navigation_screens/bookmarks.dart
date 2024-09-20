import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../Question_Screens/question_model.dart';

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  late String currentUserId;

  @override
  void initState() {
    super.initState();
    getCurrentUserId().then((userId) {
      setState(() {
        currentUserId = userId;
      });
    });
  }

  Future<String> getCurrentUserId() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bookmarks'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          setState(() {
           
          });
        },
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('questions').where('bookmarked_users', arrayContains: currentUserId).snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            List<Question> bookmarkedQuestions = snapshot.data!.docs.map((doc) => Question.fromFirestore(doc)).toList();

            return ListView.builder(
              itemCount: bookmarkedQuestions.length,
              itemBuilder: (context, index) {
                Question question = bookmarkedQuestions[index];
                return Card(
                  elevation: 5,
                  margin: EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                    title: Text(question.title, style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        FutureBuilder<DocumentSnapshot>(
                          future: FirebaseFirestore.instance.collection('users').doc(question.userId).get(),
                          builder: (context, userSnapshot) {
                            if (userSnapshot.connectionState == ConnectionState.waiting) {
                              return Text(
                                'Loading...',
                                style: TextStyle(fontSize: 14),
                              );
                            }
                            if (!userSnapshot.hasData || !userSnapshot.data!.exists) {
                              return Text(
                                'Posted by Unknown',
                                style: TextStyle(fontSize: 14),
                              );
                            }
                            var userData = userSnapshot.data!.data() as Map<String, dynamic>? ?? {};
                            var fullName = userData['Full_Name'] ?? 'Unknown';
                            return Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Posted by ',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  TextSpan(
                                    text: fullName,
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Text(
                          '${DateFormat.yMMMd().format(question.postedDate)}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          'Upvotes: ${question.upvotes}',
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
