import 'package:cloud_firestore/cloud_firestore.dart';

class Question {
  final String id;
  final String title;
  final DateTime postedDate;
  final int upvotes;
  final List<dynamic> upvotedUsers;
  final List<dynamic> bookmarkedUsers;
  final String userId;
  final String userName;

  Question({
    required this.id,
    required this.title,
    required this.postedDate,
    required this.upvotes,
    required this.upvotedUsers,
    required this.bookmarkedUsers,
    required this.userId,
    required this.userName,
  });

  factory Question.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Question(
      id: doc.id,
      title: data['title'] ?? '',
      postedDate: (data['posted_date'] as Timestamp).toDate(),
      upvotes: data['upvotes'] ?? 0,
      upvotedUsers: List<dynamic>.from(data['upvoted_users'] ?? []),
      bookmarkedUsers: List<dynamic>.from(data['bookmarked_users'] ?? []),
      userId: data['user_id'] ?? '',
      userName: data['username'] ?? 'Anonymous',
    );
  }
}