import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({super.key});

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    double h = MediaQuery.of(context).size.height;
    return Scaffold(
      body:SingleChildScrollView(
        child: Container(
          child: Column(
            mainAxisAlignment:MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50.0,left: 15),
                child: Text("Get In Touch",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 35,
                  color: Colors.indigo
                ),),
              ),
              SizedBox(height: h*0.05,),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Text("We are here for you! How can we help?",
                style: TextStyle(
                  fontSize: 19,
                ),),
              ),
              SizedBox(height: h*0.04,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Enter your name",
                    hintStyle: TextStyle(
                      color:Color(0xff555555),
                      fontSize: 18
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10)
                    )
                  ),
                ),
              ),
              SizedBox(height: h*0.04,),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                      hintText: "Enter your email address",
                      hintStyle: TextStyle(
                          color:Color(0xff555555),
                          fontSize: 18
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                      )
                  ),
                ),
              ),
              SizedBox(height: h * 0.04),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Go ahead, we are listening...",
                    hintStyle: TextStyle(
                      color: Color(0xff555555),
                      fontSize: 18,
                    ),
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  minLines: 6,
                  maxLines: null,
                ),
              ),
              SizedBox(height: h*0.055,),
              Center(
                child: GestureDetector(
                  onTap: (){},
                  child: Container(
                    height: 55,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        colors: [
                          Colors.black,
                          Colors.grey.shade800,
                        ],
                      ),
                    ),
                    child: Center(
                      child: Text(
                        "SUBMIT",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                          fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
