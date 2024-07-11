import 'package:flutter/material.dart';
import 'package:simple_login/Chat_Screens/api/apis.dart';
import 'package:simple_login/Chat_Screens/widgets/chat_userCard.dart';
import '../models/chat_user.dart';

class ChattingHomePage extends StatefulWidget {
  const ChattingHomePage({Key? key}) : super(key: key);

  @override
  State<ChattingHomePage> createState() => _ChattingHomePageState();
}

class _ChattingHomePageState extends State<ChattingHomePage> {
   List<ChatUser> list = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        onPressed: () {},
        child: Icon(
          Icons.add_comment_rounded,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder(
        stream: APIs.getAllUsers(),
        builder: (context,snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            final data = snapshot.data?.docs;
            // list.clear(); // Clear the list before adding new items
            list = data?.map((e) => ChatUser.fromJson(e.data())).toList() ??[];
            if(list.isNotEmpty){
              return ListView.builder(
                itemCount: list.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  // return Text('Name: ${list[index]}');
                  return ChatUserCard(user: list[index]);
                },
              );
            }
            else{
              return Center(child: Text('No Connection Found!',style: TextStyle(fontSize: 20),));
            }
          }
            return CircularProgressIndicator();
        },

      ),
    );
  }
}
