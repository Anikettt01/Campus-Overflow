import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_login/newChat_screens/apis/apis.dart';
import 'package:simple_login/newChat_screens/screens/chatHome_page.dart';
import 'package:simple_login/newChat_screens/models/new_chat_user.dart';
import 'package:simple_login/newProfile_page.dart';
import 'Question_Screens/add_question.dart';
import 'Question_Screens/Tab_bar.dart';
import 'Chat_Screens/Screens/chatting_page.dart';
import 'LeaderBoard_Screens/leaderboard.dart';
import 'navigation_screens/navigation_bar.dart';
import 'navigation_screens/profile_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('users');

  List<Question> questions = [];
  int currentPage = 0;
  List<Widget> pages = [
    TabBarPage(),
    ChatHomePage(),
    LeaderboardScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.withOpacity(0.2),
      drawer: const NavBar(),
      appBar: AppBar(
        title: Center(
          child: Text(
            "CampusOverflow",
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage(user: apis.me,)),
              );
            }, child:Image.asset('Assets/Images/Profile_Page_Images/main_profile.jpg',
            width: 50,height: 50,)
            ),
          )
        ],
      ),
      body: IndexedStack(
        index: currentPage,
        children: pages,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Theme.of(context).brightness == Brightness.dark ? Colors.transparent : Colors.white,
        onTap: (value) {
          setState(() {
            currentPage = value;
          });
        },
        color: Colors.black,
        animationDuration: const Duration(milliseconds: 300),
        items: const [
          Icon(
            Icons.home,
            color: Colors.white,
          ),
          Icon(
            Icons.chat,
            color: Colors.white,
          ),
          Icon(
            Icons.leaderboard,
            color: Colors.white,
          ),
        ],
      ),
    );
  }
}
