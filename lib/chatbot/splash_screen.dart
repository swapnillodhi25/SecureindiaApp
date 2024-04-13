import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:demo/chatbot/chatbot.dart';

class SpalshScreen extends StatefulWidget {
  const SpalshScreen({super.key});

  @override
  State<SpalshScreen> createState() => _SpalshScreenState();
}

class _SpalshScreenState extends State<SpalshScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2)).then((value) {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) =>  ChatPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset("assets/lottie/sp_chat.json",),
            Text(
              'Secure India',
              style: TextStyle(
                fontFamily: 'Cera Pro',
                color: Color.fromRGBO(28, 82, 126, 1),
                fontSize: 45,
              ),
            ),
            Text(
              'A chatting assistant for Secure India',
              style: TextStyle(
                fontFamily: 'Cera Pro',
                color: Color.fromRGBO(28, 82, 126, 1),
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 50,
            ),
            SpinKitFadingCircle(
              color: Color.fromRGBO(28, 82, 126, 1),
              size: 50.0,
            ),

          ],
        ),
      ),
    );
  }
}