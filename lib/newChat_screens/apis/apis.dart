import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:simple_login/Chat_Screens/models/chat_user.dart';
import 'package:simple_login/newChat_screens/models/message_model.dart';
import 'package:simple_login/newChat_screens/models/new_chat_user.dart';

class apis {
  static FirebaseAuth auth = FirebaseAuth.instance;

  static FirebaseFirestore firestore = FirebaseFirestore.instance;

  static late newChatUser me;

  static User get user => auth.currentUser!;

  static Future<bool> userExists() async {
    return (await firestore.collection('users').doc(user.uid).get()).exists;
  }

  // static Future<bool> addChatUser(String fullname) async {
  //   final data = await firestore
  //       .collection('users')
  //       .where('FullName', isEqualTo: fullname)
  //       .get();
  //
  //   // log('data: ${data.docs}');
  //
  //   if (data.docs.isNotEmpty && data.docs.first.id != user.uid) {
  //     //user exists
  //
  //     // log('user exists: ${data.docs.first.data()}');
  //
  //     firestore
  //         .collection('users')
  //         .doc(user.uid)
  //         .collection('my_users')
  //         .doc(data.docs.first.id)
  //         .set({});
  //
  //     return true;
  //   } else {
  //     //user doesn't exists
  //
  //     return false;
  //   }
  // }

  // static Stream<QuerySnapshot<Map<String, dynamic>>> getMyUsersId() {
  //   return firestore
  //       .collection('users')
  //       .doc(user.uid)
  //       .collection('my_users')
  //       .snapshots();
  // }

  static Future<void> getSelfInfo() async {
    return await firestore.collection('users').doc(user.uid).get().then((user) {
      if (user.exists) {
        me = newChatUser.fromJson(user.data()!);
      }
      // else{
      //   await createUser().then((value) => getSelfInfo());
      // }
    });
  }

  static Future<void> createUser(String name, String mail, String Collegename,
      String ProgrammingInterests, String username) async {
    final newchatuser = newChatUser(
      FullName: name,
      userName: username,
      // image: user.photoURL.toString(),
      Email: user.email.toString(),
      CollegeName: Collegename,
      ProgrammingInterest: ProgrammingInterests,
      id: user.uid,
      pushToken: '',
      total_upvotes: 0,
    );
    return await firestore
        .collection('users')
        .doc(user.uid)
        .set(newchatuser.toJson());
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllUsers() {
    return firestore
        .collection('users')
        .where('id', isNotEqualTo: user.uid)
        .snapshots();
  }

  static String getconversationid(String id) => user.uid.hashCode <= id.hashCode
      ? '${user.uid}_$id'
      : '${id}_${user.uid}';

  static Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(
      newChatUser user) {
    return firestore
        .collection('chats/${getconversationid(user.id)}/messages')
        .orderBy('sent', descending: false)
        .snapshots();
  }

  static Future<void> sendMessage(newChatUser chatuser, String msg) async {
    final time = DateTime.now().millisecondsSinceEpoch.toString();
    final Message message = Message(
        toId: chatuser.id,
        msg: msg,
        read: '',
        type: Type.text,
        fromId: user.uid,
        sent: time);
    final ref = firestore
        .collection('chats/${getconversationid(chatuser.id)}/messages');
    await ref.doc(time).set(message.toJson());
  }

  static Future<void> updateMessageStatus(Message message) async {
    firestore
        .collection('chats/${getconversationid(message.fromId)}/messages')
        .doc(message.sent)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getLastMessage(
      newChatUser user) {
    return firestore
        .collection('chats/${getconversationid(user.id)}/messages/')
        .orderBy('sent', descending: true)
        .limit(1)
        .snapshots();
  }


}
