import 'package:flutter/material.dart';
import 'package:simple_login/navigation_screens/profile_page.dart';
import 'package:simple_login/newChat_screens/apis/apis.dart';
import 'package:simple_login/newChat_screens/helper/date.dart';
import 'package:simple_login/newChat_screens/models/message_model.dart';
import 'package:simple_login/newChat_screens/screens/newUserChat_screen.dart';
import 'package:simple_login/newChat_screens/widget/newMessage_card.dart';
import '../models/new_chat_user.dart';

class NewChatUserCard extends StatefulWidget {
  final newChatUser user;
  const NewChatUserCard({Key? key, required this.user}) : super(key: key);

  @override
  State<NewChatUserCard> createState() => _NewChatUserCardState();
}

class _NewChatUserCardState extends State<NewChatUserCard> {
  Message? _message;
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
          Navigator.push(context, MaterialPageRoute(builder: (_) => NewUserChatScreen( user:widget.user)));
        },
        child: StreamBuilder(
          stream: apis.getLastMessage(widget.user),
          builder: (context, snapshot) {
            final data = snapshot.data?.docs;
            final list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
            if(list.isNotEmpty){
              _message=list[0];
            }
            return Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                image: DecorationImage(
                  image: AssetImage('Assets/Images/chatting_images/card_bg.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.darken),
                ),
              ),
              child: ListTile(
                leading: ProfileImage(size: 18, username: widget.user.FullName,),
                title: Text(
                  widget.user.FullName,
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
                        _message != null ? _message!.msg :
                        widget.user.ProgrammingInterest,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
                trailing: _message == null ? null :
                _message!.read.isEmpty && _message!.fromId != apis.user.uid?Container(
                  width: 15,
                  height: 15,
                  decoration: BoxDecoration(
                    color: Colors.greenAccent.shade400,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ): Text(
                MyDateUtil.getLastMessageTime(context: context, time: _message!.sent)
                ,style: TextStyle(color: Colors.white,fontSize: 13),)
              ),
            );
          }
        ),
      ),
    );
  }
}
