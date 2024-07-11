import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'forgot_password_screen.dart';

class SignInPage extends StatefulWidget {
  final VoidCallback showSignupPage;
  const SignInPage({Key? key, required this.showSignupPage}) : super(key: key);
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _emailErrorMessage;
  String? _passwordErrorMessage;
  String? _authErrorMessage;

  void Signinuser() async {

    if (_emailController.text.isEmpty) {
      setState(() {
        _emailErrorMessage = 'Email field is empty';
      });
      return;
    }

    if (_passwordController.text.isEmpty) {
      setState(() {
        _passwordErrorMessage = 'Password field is empty';
      });
      return;
    }

    // Clear any previous error messages
    setState(() {
      _emailErrorMessage = null;
      _passwordErrorMessage = null;
      _authErrorMessage = null;
    });

    try {
      // Sign in user
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Sign in successful, display success message
      setState(() {
        _authErrorMessage = 'Sign in successful';
      });
    } catch (e) {
      // Sign in failed, display error message
      setState(() {
        _authErrorMessage = 'Either email or password is incorrect';
      });
      print('Error signing in: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            TweenAnimationBuilder(
              tween: Tween(begin: Offset(-1, 0), end: Offset(0, 0)),
              duration: Duration(seconds: 1),
              builder: (context, Offset offset, child) {
                return FractionalTranslation(
                  translation: offset,
                  child: Container(
                    height: h * 0.3,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xffE6E6FA),
                          Color(0xffC0C0C0),
                        ],
                      ),
                    ),
                    child:
                    Image(image: AssetImage('Assets/Images/Login_Screen_Images/logo.png')),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(45),
                    topRight: Radius.circular(45),
                  ),
                  color: Colors.white,
                ),
                height: h * 0.75,
                width: w,
                child: Padding(
                  padding: const EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        child: const Text(
                          'Welcome Back!',
                          style: TextStyle(
                              fontSize: 30,
                              color: Colors.black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Gmail",
                          hintStyle: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          errorText: _emailErrorMessage,
                        ),
                      ),
                      SizedBox(
                        height: 25,
                      ),
                      TextField(
                        controller: _passwordController,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          hintText: "Password",
                          hintStyle: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: Color(0xff555555),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          errorText: _passwordErrorMessage,
                        ),
                      ),
                      SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerRight,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ForgetPasswordScreen()));
                          },
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Color(0xff555555),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      if (_authErrorMessage != null)
                        Text(
                          _authErrorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 16
                          ),
                        ),
                      SizedBox(height: 80),
                      GestureDetector(
                        onTap: Signinuser,
                        child: Container(
                          height: 55,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                              colors: [
                                Colors.black,
                                Colors.grey.shade800,
                              ],
                            ),
                          ),
                          child: Center(
                            child: Text(
                              'SIGN IN',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 100),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Don't have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.showSignupPage,
                              child: Text(
                                "Sign up",
                                style: TextStyle(
                                  ///done login page
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
