import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simple_login/Chat_Screens/Screens/userChatScreen.dart';
import 'package:simple_login/GPT_Screens/Screens/chat_screen.dart';
import 'package:simple_login/navigation_screens/profile_page.dart';

import '../models/chat_user.dart';

class ChatUserCard extends StatefulWidget {
  final ChatUser user;
  const ChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<ChatUserCard> createState() => _ChatUserCardState();
}

class _ChatUserCardState extends State<ChatUserCard> {
  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Card(
      margin: EdgeInsets.symmetric(horizontal: h * 0.01, vertical: 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 1,
      child: InkWell(
        onTap: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => UserChatScreen(user: widget.user,)));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            image: DecorationImage(
              image: AssetImage('Assets/Images/chatting_images/card_bg.jpg'),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
            ),
          ),
          child: ListTile(
            // leading: ProfileImage(size: 18,),
            title: Text(
              widget.user.Username,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            subtitle: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text(
                    widget.user.programming_intrests,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),
            // trailing: Text(
            //   '12.00 PM',
            //   style: TextStyle(
            //     fontSize: 13,
            //     color: Colors.white.withOpacity(0.8),
            //   ),
            // ),
          ),
        ),
      ),
    );
  }
}
