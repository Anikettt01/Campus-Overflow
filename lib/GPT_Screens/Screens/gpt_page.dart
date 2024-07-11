import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/chat_provider.dart';
import '../providers/model_provider.dart';
import 'chat_screen.dart';


class GptPage extends StatelessWidget {
  const GptPage({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => ModelsProvider(),
          ),
          ChangeNotifierProvider(
            create:(_) => ChatProvider(),
          ),
        ],
        child: Scaffold(
          body: ChatScreen(),
        )
    );
  }
}

