import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:simple_login/navigation_screens/bookmarks.dart';
import 'package:simple_login/navigation_screens/my_questions.dart';
import '../Themes/theme_provider.dart';
import 'about_us.dart';
import 'help_page.dart';

class NavBar extends StatefulWidget {
  const NavBar({
    Key? key,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  late String fullName = '';
  late String email = '';

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      final userDoc = await FirebaseFirestore.instance.collection('users').doc(currentUser.uid).get();
      setState(() {
        fullName = userDoc['Full_Name'];
        email = userDoc['Email'];
      });
    }
  }

  Future<void> _showLogoutDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, 
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Log Out'),
          content: Text('Are you sure you want to log out?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.of(dialogContext).pop(); 
              },
            ),
          ],
        );
      },
    );
  }

  Widget buildDrawerItem({
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          size: 22,
          color: Colors.black,
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    Brightness currentBrightness = Theme.of(context).brightness;

    return Drawer(
      child: Column(
        children: [
          Container(
            color: Colors.black,
            alignment: Alignment.topRight,
            padding: EdgeInsets.only(top: 15.0, right: 4.0, bottom: 4.0),
            child: IconButton(
              icon: currentBrightness == Brightness.dark
                  ? Icon(
                Icons.nightlight_round,
                color: Colors.white,
              )
                  : Icon(
                Icons.wb_sunny,
                color: Colors.white,
              ),
              onPressed: () {
                Provider.of<ThemeProvider>(context, listen: false).toggleTheme();
              },
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(
                    fullName,
                    style: TextStyle(fontSize: 25),
                  ),
                  accountEmail: Text(
                    email,
                    style: TextStyle(fontSize: 18),
                  ),
                  decoration: BoxDecoration(color: Colors.black),
                ),
                buildDrawerItem(
                  title: "My Questions",
                  icon: Icons.question_answer_outlined,
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyQuestionsPage()
                        ),
                    );
                  },
                ),
                buildDrawerItem(
                  title: "Bookmarks",
                  icon: Icons.bookmark,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookmarksPage(),
                      ),
                    );
                  },
                ),
                buildDrawerItem(
                  title: "Help",
                  icon: Icons.help,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpPage(),
                      ),
                    );
                  },
                ),
                buildDrawerItem(
                  title: "About Us",
                  icon: Icons.groups_outlined,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AboutUs(),
                      ),
                    );
                  },
                ),
                SizedBox(
                  height: h * 0.275,
                ),
                Divider(),
                buildDrawerItem(
                  title: "LogOut",
                  icon: Icons.logout,
                  onTap: () {
                    _showLogoutDialog(context);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
