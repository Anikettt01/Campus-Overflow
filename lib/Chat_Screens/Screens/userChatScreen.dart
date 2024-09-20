import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_login/Chat_Screens/models/chat_user.dart';
import 'package:simple_login/newChat_screens/models/message_model.dart';
import 'package:simple_login/navigation_screens/profile_page.dart';

import '../api/apis.dart';
import '../widgets/message_card.dart';

class UserChatScreen extends StatefulWidget {
  final ChatUser user;
  const UserChatScreen({super.key, required this.user});

  @override
  State<UserChatScreen> createState() => _UserChatScreenState();
}

class _UserChatScreenState extends State<UserChatScreen> {

  List<Message>_list = [];
  final _textController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          automaticallyImplyLeading: false,
          flexibleSpace: _appBar(),
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.grey[850]!,
                Colors.grey[900]!,
                // Adjust as needed
              ],
            ),
          ),
          child: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: APIs.getAllMessages(widget.user),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: SizedBox());
                    }
                    if (snapshot.hasData) {
                      final data = snapshot.data?.docs;
                      // log('Data: ${jsonEncode(data![0].data())}');
                      _list = data?.map((e) => Message.fromJson(e.data())).toList() ??[];

                      if (_list.isNotEmpty) {
                        return ListView.builder(
                          itemCount: _list.length,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            // return Text('Message: ${_list[index]}');
                            return MessageCard(message: _list[index],);
                          },
                        );
                      }
                      else {
                        return Center(child: Text(
                          'Say Hi!👋', style: TextStyle(fontSize: 20,color: Colors.white),));
                      }
                    }
                    return CircularProgressIndicator();
                  },
                ),
              ),
              _chatInput()
            ],
          ),
        ),
      ),
    );
  }

  Widget _appBar() {
    return InkWell(
      onTap: () {},
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.Username,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 3),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Text(
                    widget.user.programming_intrests,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _chatInput() {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 5),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: Colors.black,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.emoji_emotions,
                        color: Color.fromRGBO(229, 77, 76, 1)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          hintText: 'Type something...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(
                        Icons.image, color: Color.fromRGBO(229, 77, 76, 1)),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.camera_alt,
                        color: Color.fromRGBO(229, 77, 76, 1)),
                  ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if(_textController.text.isNotEmpty){
                APIs.sendMessage(widget.user, _textController.text);
                _textController.text = '';
              }
            },
            minWidth: 0,
            padding: EdgeInsets.all(10),
            shape: CircleBorder(),
            color: Color.fromRGBO(229, 77, 76, 1),
            child: Icon(Icons.send, color: Colors.white, size: 24),
          ),
        ],
      ),
    );
  }
}
