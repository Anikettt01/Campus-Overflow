import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class User {
  final String name;
  final int score;

  User(this.name, this.score);
}

class LeaderboardScreen extends StatefulWidget {
  LeaderboardScreen({Key? key}) : super(key: key);

  @override
  _LeaderboardScreenState createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> with TickerProviderStateMixin {
  late List<User> users = [];
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 4),
      vsync: this,
    );
    _controller.addListener(() {
      setState(() {});
    });
    _controller.forward();
    fetchUsers();
  }

  void fetchUsers() {
    FirebaseFirestore.instance.collection('users').snapshots().listen((snapshot) {
      setState(() {
        users = snapshot.docs.map((doc) => User(
          doc['Full_Name'] as String,
          doc['total_upvotes'] as int,
        )).toList();
        users.sort((a, b) => b.score.compareTo(a.score));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildTop3Bars(),
            SizedBox(height: 20),
            _buildLeaderboardList(),
          ],
        ),
      ),
    );
  }

  Widget _buildTop3Bars() {
     // ensure there are enough users
    if (users.length < 3) return Container(); 
    List<User> topThreeUsers = users.take(3).toList();
    int maxScore = topThreeUsers.map((user) => user.score).reduce((a, b) => a > b ? a : b);

    return Container(
      alignment: Alignment.center,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _buildUserBar(topThreeUsers[1], maxScore),
          _buildUserBar(topThreeUsers[0], maxScore),
          _buildUserBar(topThreeUsers[2], maxScore),
        ],
      ),
    );
  }

  Widget _buildUserBar(User user, int maxScore) {
    double barHeight = (user.score / maxScore) * 180.0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: barHeight * _controller.value,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueGrey.shade500,
                Colors.blueGrey.shade300,
              ],
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              (_controller.value * user.score).toInt().toString(),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          user.name,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildLeaderboardList() {
    return ListView.builder(
      itemCount: users.length,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blueGrey.shade100,
                Colors.blueGrey.shade50,
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade300,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: ListTile(
            leading: Text(
              (index + 1).toString(),
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            title: Text(
              users[index].name,
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
            trailing: Text(
              'Upvotes: ${(_controller.value * users[index].score).toInt()}',
              style: TextStyle(fontSize: 18, color: Colors.black87),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
