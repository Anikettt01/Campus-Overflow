import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_login/newChat_screens/models/message_model.dart';

import '../models/chat_user.dart';

class APIs {
  static FirebaseAuth auth = FirebaseAuth.instance;
  static FirebaseFirestore firestore = FirebaseFirestore.instance;
  static User get user => auth.currentUser!;

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers(){
    return firestore.collection('users').snapshots();
  }

  static String getConversationID(String id)=>user.uid.hashCode <= id.hashCode ? '${user.uid}_$id' : '${id}_${user.uid}';

  static  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(ChatUser user){
    return firestore.collection('chats/${getConversationID(user.email)}/messages/').snapshots();
  }

  static Future<void> sendMessage(ChatUser chatuser,String msg) async {
    final Message message = Message(toId: chatuser.email, msg: msg, read: '', type: Type.text, fromId: user.uid, sent: '');
    final ref = firestore.collection('chats/${getConversationID(chatuser.email)}/messages/');
    await ref.doc().set(message.toJson());
  }
}