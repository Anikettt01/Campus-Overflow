import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:simple_login/newChat_screens/apis/apis.dart';

import '../helper/date.dart';
import '../models/message_model.dart';

class NewMessageCard extends StatefulWidget {
  final Message message;
  const NewMessageCard({Key? key, required this.message}) : super(key: key);

  @override
  State<NewMessageCard> createState() => _NewMessageCardState();
}

class _NewMessageCardState extends State<NewMessageCard> {
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: apis.user.uid == widget.message.fromId
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      children: [
        apis.user.uid == widget.message.fromId
            ? _orangeMessage()
            : _blackMessage(),
      ],
    );
  }

  Widget _blackMessage() {
    if(widget.message.read.isEmpty){
      apis.updateMessageStatus(widget.message);
      // log('message read updated');
    }
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 4,right: h*0.1,top: 4,bottom: 4),
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
          ),
          // Icon(Icons.done_all_rounded,size: 20,color: Colors.blue,)
          Row(
            children: [
              Icon(
                Icons.done_all_rounded,
                size: 20,
                color: Colors.blue,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  MyDateUtil.getformatedTime(context: context, time: widget.message.sent),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _orangeMessage() {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: EdgeInsets.only(right: 4,left: h*0.1,top: 4,bottom: 4),
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
          ),
          Padding(
            padding: EdgeInsets.only(right: 4,left: w*0.78,top: 4,bottom: 4),
            child: Row(
              children: [
                Text(
                  MyDateUtil.getformatedTime(context: context, time: widget.message.sent),
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(width: 4),
                if(widget.message.read.isNotEmpty)
                  Icon(
                    Icons.done_all_rounded,
                    size: 18,
                    color: Colors.blue,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

