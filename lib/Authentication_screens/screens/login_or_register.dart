import 'package:flutter/material.dart';
import 'package:simple_login/Authentication_screens/screens/signin_page.dart';
import 'package:simple_login/Authentication_screens/screens/signup_page.dart';

class LoginOrRegsiter extends StatefulWidget {
  const LoginOrRegsiter({super.key});

  @override
  State<LoginOrRegsiter> createState() => _LoginOrRegsiterState();
}

class _LoginOrRegsiterState extends State<LoginOrRegsiter> {
  bool showLoginpage = true;

  void toggleScreens(){
    setState(() {
      showLoginpage = !showLoginpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(showLoginpage){
      return SignInPage(showSignupPage:toggleScreens);
    }
    else{
      return SignupScreen(showLoginPage:toggleScreens);
    }
  }
}
