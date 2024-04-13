import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:demo/email_auth/signup_page.dart';

class Forgot_Password_Recovery extends StatefulWidget {
  const Forgot_Password_Recovery({Key? key}) : super(key: key);

  @override
  _Forgot_Password_RecoveryState createState() => _Forgot_Password_RecoveryState();
}

class _Forgot_Password_RecoveryState extends State<Forgot_Password_Recovery> {

  TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>(); // Add form key

  resetPassword() async {
    try {
      // Email is registered, proceed with password reset
      await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text.trim().toLowerCase());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          "Password Reset Email has been sent!",
          style: TextStyle(fontSize: 20.0),
        ),
      ));
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-email") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Invalid Email Address.",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
      } else if (e.code == "user-not-found") {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "No user found for that email.",
            style: TextStyle(fontSize: 20.0),
          ),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Password Recovery"),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 30, right: 20),
        child: SingleChildScrollView(
          child: Form( // Wrap the contents with a Form widget
            key: _formKey, // Assign the form key
            child: Column(
              children: [
                Container(
                  height: 300,
                  child: Image.asset("assets/images/create_pass.png"),
                ),
                Text(
                  "Please Enter Your Email",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    height: 5,
                  ),
                ),
                TextFormField(
                  controller: _emailController,
                  autocorrect: true,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                  ),
                  decoration: InputDecoration(
                    label: Text("Email"),
                    prefixIcon: Icon(Icons.email),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(color: Colors.black45),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: const BorderSide(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 30),
                Container(
                  height: 50,
                  width: 380,
                  margin: EdgeInsets.only(top: 50, bottom: 20), // Added margin bottom
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // Validate the form before proceeding
                      if (_formKey.currentState!.validate()) {
                        resetPassword();
                      }
                    },
                    label: Text(
                      "Send Email",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                    icon: Icon(Icons.arrow_forward, color: Colors.white), // Changed arrow direction
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(HexColor("146c94")),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const sign_up(),));
                  },
                  child: Text(
                    "Don't have an account? Sign up",
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
