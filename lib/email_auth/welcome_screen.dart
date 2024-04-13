import 'package:flutter/material.dart';
import 'package:demo/email_auth/login_page.dart';
import 'package:demo/email_auth/signup_page.dart';
import 'package:hexcolor/hexcolor.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 400,
            height: 300,
            margin: EdgeInsets.only(top: 70),
            child: Image.asset("assets/images/welcome.png"),
          ),
          SizedBox(height: 20),
          Text(
            "Welcome",
            style: TextStyle(
              fontSize: 30,
              decoration: TextDecoration.underline,
            ),
          ),
          SizedBox(height: 10),
          Container(
            width: 300,
            child: Text(
              "Raise public awareness, streamline police access, combat digital fraud effectively, safeguard individuals and businesses.",
              style: TextStyle(fontSize: 17),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 60),
          SizedBox(
            width: 300,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const sign_up()));
              },
              child: Text(
                'Create New Account',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(HexColor("146c94")),
              ),
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            width: 300,
            height: 60,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const login_page()));
              },
              child: Text(
                'Login',
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(HexColor("146c94")),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
