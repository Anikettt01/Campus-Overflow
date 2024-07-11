import 'package:flutter/material.dart';
import 'package:simple_login/Chat_Screens/models/chat_user.dart';
import 'package:simple_login/newChat_screens/apis/apis.dart';
import 'package:simple_login/newChat_screens/models/message_model.dart';
import 'package:simple_login/newChat_screens/models/new_chat_user.dart';
import 'package:simple_login/newChat_screens/widget/newMessage_card.dart';


class NewUserChatScreen extends StatefulWidget {
  final newChatUser user;
  const NewUserChatScreen({super.key, required this.user});

  @override
  State<NewUserChatScreen> createState() => _NewUserChatScreenState();
}

class _NewUserChatScreenState extends State<NewUserChatScreen> {

  List<Message>_list = [];
  final _textController = TextEditingController();

  bool _showEmoji = false;
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
                  stream: apis.getAllMessages(widget.user),
                  builder: (context,snapshot){
                    switch (snapshot.connectionState){
                      case ConnectionState.waiting:
                      case ConnectionState.none:
                        return Center(child: SizedBox(),);

                      case ConnectionState.active:
                      case ConnectionState.done:
                        final data = snapshot.data?.docs;
                        _list = data?.map((e) => Message.fromJson(e.data())).toList() ?? [];
                        // _list.clear();
                        // _list.add(Message(toId: 'xyz', msg: 'Hiii', read: '', type: Type.text, fromId:apis.user.uid , sent:'12.00 AM'));
                        // _list.add(Message(toId:apis.user.uid, msg: 'Hello', read: '', type: Type.text, fromId:'xyz' , sent: '12.05 AM'));
                        if(_list.isNotEmpty){
                          return ListView.builder(
                              itemCount: _list.length,
                              padding: EdgeInsets.only(top: 10),
                              physics: BouncingScrollPhysics(),
                              itemBuilder: (context,index){
                                return NewMessageCard(message: _list[index]);
                              });
                        }
                        else{
                          return Center(child: Text("Say Hi!!👋",
                          style: TextStyle(fontSize: 20,color: Colors.white),),);
                        }
                    }
                  },
                ),
              ),
              _chatInput(),

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
          // ProfileImage(size: 18),
          SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.user.FullName,
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
                    widget.user.ProgrammingInterest,
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
                  // IconButton(
                  //   onPressed: () {
                  //     setState(() {
                  //       _showEmoji = !_showEmoji;
                  //     });
                  //   },
                  //   // icon: Icon(Icons.emoji_emotions,
                  //   //     color: Color.fromRGBO(229, 77, 76, 1)),
                  // ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 4,bottom: 4,left: 10,right: 10),
                      child: TextField(
                        controller: _textController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        style: TextStyle(color: Colors.white),
                        // Set text color to white
                        decoration: InputDecoration(
                          hintText: 'Type something...',
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(
                  //       Icons.image, color: Color.fromRGBO(229, 77, 76, 1)),
                  // ),
                  // IconButton(
                  //   onPressed: () {},
                  //   icon: Icon(Icons.camera_alt,
                  //       color: Color.fromRGBO(229, 77, 76, 1)),
                  // ),
                ],
              ),
            ),
          ),
          MaterialButton(
            onPressed: () {
              if(_textController.text.isNotEmpty){
                // APIs.sendMessage(widget.user, _textController.text);
                apis.sendMessage(widget.user, _textController.text);
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
