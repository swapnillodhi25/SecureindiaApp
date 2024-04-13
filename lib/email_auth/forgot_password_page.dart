import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:demo/email_auth/forgot_password_recovery.dart';


class Forgot_Password_Page extends StatefulWidget {
  const Forgot_Password_Page({super.key});

  @override
  State<Forgot_Password_Page> createState() => _Forgot_Password_PageState();
}

class _Forgot_Password_PageState extends State<Forgot_Password_Page> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Center(
        child: Column(
          children: [
            Image.asset(
              "assets/images/forgot_im.png",
              width: 300,
              height: 300,
            ),
            Container(
              width: 350,
              child: Text(
                "Select which contact details should we use to Reset Your Password",
                style: TextStyle(
                  fontSize: 18,
                ),
                softWrap: true,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ListTile(
                title: Text("Via Email"),
                tileColor: Colors.white,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) =>const Forgot_Password_Recovery(),));
                  },
                subtitle: Text("johndoe@gmail.com"),
                leading: Icon(
                  Icons.email_outlined,
                ),
                selected: false,
                selectedColor: Colors.cyan,
                trailing: Icon(Icons.arrow_forward_ios_outlined),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: ListTile(
                title: Text("Via Phone Number"),
                tileColor: Colors.white,
                onTap: () {

                  // handle to forgot with mobile otp
                },
                subtitle: Text("+91 1234567890"),
                leading: Icon(
                  Icons.sms,
                  size: 30, // Use size property to set the size of the icon
                ),
                selected: false,
                selectedColor: Colors.cyan,
                selectedTileColor: Colors.cyan,
                enabled: true,
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
