import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:simple_login/newChat_screens/apis/apis.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback showLoginPage;

  const SignupScreen({Key? key, required this.showLoginPage}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _fullnameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _collegenameController = TextEditingController();
  final _interestController = TextEditingController();

  final user = FirebaseAuth.instance.currentUser;
  bool _isPasswordVisible = false;
  String? _authErrorMessage;
  String _selectedCollege = 'PICT'; 
  List<String> _selectedInterests = []; 

  final List<String> _colleges = ['PICT', 'VIT', 'COEP', 'MIT', 'PCCOE'];
  final List<String> _interests = [
    'Competitive Programming',
    'Flutter',
    'Frontend',
    'Backend',
    'DevOps',
    'AWS',
    'Django',
    'Python',
    'C/C++'
  ];

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _fullnameController.dispose();
    _usernameController.dispose();
    _collegenameController.dispose();
    _interestController.dispose();
    super.dispose();
  }

  Future signUp() async {
    // Check if username is unique
    bool isUsernameUnique = await checkUsernameUnique(_usernameController.text.trim());

    if (!isUsernameUnique) {
      setState(() {
        _authErrorMessage = 'Username already taken';
      });
      return;
    }

    // Create user
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      // Add user details
      await apis.createUser(
        _fullnameController.text,
        _emailController.text,
        _selectedCollege,
        _selectedInterests.join(','),
        _usernameController.text,
      );
    } on FirebaseAuthException catch (e) {
      setState(() {
        _authErrorMessage = e.message;
      });
    }
  }

  Future<bool> checkUsernameUnique(String username) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where('username', isEqualTo: username)
        .get();
    return querySnapshot.docs.isEmpty;
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
                    child: Image(
                      image: AssetImage('Assets/Images/Login_Screen_Images/logo.png'),
                    ),
                  ),
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.only(top: 200.0),
              child: Container(
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  color: Colors.white,
                ),
                height: h * 0.75,
                width: w,
                child: Padding(
                  padding: EdgeInsets.only(left: 18.0, right: 18),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 35,
                      ),
                      const Text(
                        "Let's Get Started!",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextField(
                        controller: _fullnameController,
                        decoration: InputDecoration(
                          hintText: "Full Name",
                          hintStyle: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          hintText: "Username",
                          hintStyle: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: _selectedCollege,
                        onChanged: (String? newValue) {
                          setState(() {
                            _selectedCollege = newValue!;
                          });
                        },
                        items: _colleges.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          hintText: "College Name",
                          hintStyle: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      DropdownButtonFormField<String>(
                        value: null,
                        onChanged: (String? value) {
                          setState(() {
                            if (_selectedInterests.contains(value!)) {
                              _selectedInterests.remove(value);
                            } else {
                              _selectedInterests.add(value);
                            }
                          });
                        },
                        items: _interests.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Row(
                              children: <Widget>[
                                Checkbox(
                                  value: _selectedInterests.contains(value),
                                  onChanged: (bool? newValue) {
                                    setState(() {
                                      if (newValue!) {
                                        _selectedInterests.add(value);
                                      } else {
                                        _selectedInterests.remove(value);
                                      }
                                    });
                                  },
                                ),
                                Text(value),
                              ],
                            ),
                          );
                        }).toList(),
                        decoration: InputDecoration(
                          hintText: "Programming Interests",
                          hintStyle: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "Email",
                          hintStyle: TextStyle(
                            color: Color(0xff555555),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
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
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Color(0xff555555),
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ), 
                      if (_authErrorMessage != null)
                        Text(
                          _authErrorMessage!,
                          style: TextStyle(
                            color: Colors.red,
                          ),
                        ),
                      SizedBox(
                        height: 15,
                      ),
                      GestureDetector(
                        onTap: signUp,
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
                              'SIGN UP',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "Already have an account?",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            GestureDetector(
                              onTap: widget.showLoginPage,
                              child: Text(
                                "Sign in",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 17,
                                  color: Colors.black,
                                ),
                              ),
                            )
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
}
