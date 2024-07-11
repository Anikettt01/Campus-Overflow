import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_login/newChat_screens/apis/apis.dart';
import 'package:simple_login/newChat_screens/helper/dialogue.dart';
import 'package:simple_login/newChat_screens/models/new_chat_user.dart';
import 'package:simple_login/newChat_screens/widget/newChat_usercard.dart';

import '../../Chat_Screens/models/chat_user.dart';

class ChatHomePage extends StatefulWidget {
  const ChatHomePage({Key? key});

  @override
  State<ChatHomePage> createState() => _ChatHomePageState();
}

class _ChatHomePageState extends State<ChatHomePage> {
  List<newChatUser> list = [];

  @override
  void initState() {
    super.initState();
    apis.getSelfInfo();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
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
          stream: apis.getAllUsers(),
          builder: (context, snapshot) {

            switch (snapshot.connectionState){
              case ConnectionState.waiting:
              case ConnectionState.none:
                return const Center(child: CircularProgressIndicator(),);
            //   if data is loaded
              case ConnectionState.active:
              case ConnectionState.done:

                final data = snapshot.data?.docs;
                list = data?.map((e) => newChatUser.fromJson(e.data())).toList() ?? [];
                if(list.isNotEmpty){
                  return ListView.builder(
                      itemCount: list.length,
                      padding: EdgeInsets.only(top: h * 0.01),
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return NewChatUserCard(user: list[index],);
                        // return Text('Full_Name: ${list[index]}');
                      });
                }
                else{
                  return Center(
                    child: Text("No Connection Found!!!",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold
                      ),),
                  );
                }
            }

          }),
    );
  }
}


