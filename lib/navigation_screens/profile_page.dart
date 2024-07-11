import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_login/Chat_Screens/models/chat_user.dart';
import 'package:simple_login/newChat_screens/models/new_chat_user.dart';

class ProfilePage extends StatefulWidget {
  final newChatUser user;
  const ProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('users');

  Future<void> editField(String field) async {
    String newValue = "";
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          "Edit " + field,
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          autofocus: true,
          style: TextStyle(
            color: Colors.white,
          ),
          minLines: 1,
          maxLines: 10,
          decoration: InputDecoration(
            hintText: "Enter new $field",
            hintStyle: TextStyle(color: Colors.grey),
          ),
          onChanged: (value) {
            newValue = value;
          },
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(newValue),
            child: Text(
              'Save',
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
    if (newValue.trim().length > 0) {
      await userCollection.doc(currentUser.email).update({field: newValue});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(currentUser.email)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            // final userData = snapshot.data!.data() as Map<String, dynamic>;
            // final String username = userData['Full Name'];
            return SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(60.0),
                    child: Container(
                      child: Center(
                        child: ProfileImage(username: widget.user.FullName),
                      ),
                    ),
                  ),
                  MyTextBox(text: widget.user.userName, sectionName: 'username', onPressed: null),
                  MyTextBox(
                      text: widget.user.FullName,
                      sectionName: 'Full Name',
                      onPressed: () => editField('Full Name')),
                  MyTextBox(
                      text: widget.user.Email,
                      sectionName: 'Email',
                      onPressed: () => editField('Email')),
                  MyTextBox(
                      text: widget.user.CollegeName,
                      sectionName: 'College Name',
                      onPressed: () => editField('College Name')),
                  MyTextBox(
                      text: widget.user.ProgrammingInterest,
                      sectionName: 'Programming Interest',
                      onPressed: () => editField('Programming Interest')),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error${snapshot.error}'));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class MyTextBox extends StatelessWidget {
  final String text;
  final String sectionName;
  final void Function()? onPressed;
  const MyTextBox(
      {super.key, required this.text, required this.sectionName, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[200], borderRadius: BorderRadius.circular(8)),
      padding: EdgeInsets.only(left: 15, bottom: 15),
      margin: EdgeInsets.only(left: 20, right: 20, top: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                sectionName,
                style: TextStyle(color: Colors.grey[500]),
              ),
              IconButton(
                  onPressed: onPressed,
                  icon: Icon(Icons.edit, color: Colors.black))
            ],
          ),
          Text(text),
        ],
      ),
    );
  }
}
class ProfileImage extends StatelessWidget {
  final String username;
  final double size;

  const ProfileImage({Key? key, required this.username, this.size = 70}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Colors.blueGrey, // Customize the background color as needed
      child: Text(
        username.isNotEmpty ? username[0].toUpperCase() : '',
        style: TextStyle(fontSize: size, color: Colors.white), // Adjust font size based on the size of the circle avatar
      ),
    );
  }
}

