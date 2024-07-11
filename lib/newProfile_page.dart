import 'package:flutter/material.dart';
import 'package:simple_login/newChat_screens/models/new_chat_user.dart';

class NewProfileScreen extends StatefulWidget {
  final newChatUser user;
  const NewProfileScreen({super.key, required this.user});

  @override
  State<NewProfileScreen> createState() => _NewProfileScreenState();
}

class _NewProfileScreenState extends State<NewProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
