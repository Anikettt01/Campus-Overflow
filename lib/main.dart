

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_login/Authentication_screens/screens/auth_page.dart';
import 'package:simple_login/Authentication_screens/screens/landing_screen.dart';
import 'package:simple_login/Themes/theme_provider.dart';
import 'Authentication_screens/firebase/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child:  MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CampusOverflow',
      theme: Provider.of<ThemeProvider>(context).themeData,
      home: AuthPage(),
    );
  }
}