import 'package:flutter/material.dart';
import 'package:simple_login/Chat_Screens/api/apis.dart';

import '../../newChat_screens/models/message_model.dart';

class MessageCard extends StatefulWidget {
  final Message message;
  const MessageCard({Key? key, required this.message}) : super(key: key);

  @override
  State<MessageCard> createState() => _MessageCardState();
}

class _MessageCardState extends State<MessageCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: APIs.user.uid == widget.message.fromId
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        APIs.user.uid == widget.message.fromId
            ? _orangeMessage()
            : _blackMessage(),
      ],
    );
  }

  Widget _blackMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(27, 29, 37, 1),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Text(
          widget.message.msg,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }

  Widget _orangeMessage() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Color.fromRGBO(229, 77, 76, 1),
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Text(
          widget.message.msg,
          style: TextStyle(fontSize: 15, color: Colors.white),
        ),
      ),
    );
  }
}
