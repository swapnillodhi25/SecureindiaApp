import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo/home_page/home_page.dart';
import 'package:demo/email_auth/login_page.dart';
import 'package:demo/Community/posts.dart';
import 'package:demo/email_auth/user_details.dart';
import 'package:demo/email_auth/fingerprint_add.dart';
import 'package:demo/Navbar/profile_page.dart';



// ignore: camel_case_types
class sign_up extends StatefulWidget {
  const sign_up({Key? key}) : super(key: key);
  @override
  State<sign_up> createState() => _sign_upState();
}

// ignore: camel_case_types
class _sign_upState extends State<sign_up> {
  String name = "", email = "", password = "";
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  registration() async {
    if (nameController.text != "" && emailController.text != "") {
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Registered Successfully",
              style: TextStyle(fontSize: 20.0),
            )));
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const UserProfilePage(),));
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Password Provided is too Weak",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Account Already exists",
                style: TextStyle(fontSize: 18.0),
              )));
        } else if (e.code == 'invalid-email') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              backgroundColor: Colors.orangeAccent,
              content: Text(
                "Invalid Email Address",
                style: TextStyle(fontSize: 18.0),
              )));
        }
        print(e.code);
      }
    }

  }

  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
      await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //       "Registered Successfully",
      //       style: TextStyle(fontSize: 20.0),
      //     )));
      // Navigator.push(
      //     context, MaterialPageRoute(builder: (context) => const UserProfilePage(),));
      // // Use the user object for further operations or navigate to a new screen.
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        flexibleSpace: Image.asset("assets/images/sign.png"),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(top: 185),
                    child: Image.asset("assets/images/sign_up.png"),
                  ),
                  Container(
                    width: 200,
                    height: 200,
                    margin: const EdgeInsets.only(left: 120, bottom: 0, top: 0),
                    child: Image.asset("assets/images/sign_up_boy.png"),
                  ),
                  Container(
                    width: 350,
                    margin: const EdgeInsets.only(top: 200, left: 30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: nameController,
                          autocorrect: true,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            labelText: "Full Name",
                            alignLabelWithHint: false,
                          ),
                          keyboardType: TextInputType.name,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your full name';
                            }
                            return null;
                          },
                        ),
                        TextFormField(
                          controller: emailController,
                          autocorrect: true,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            labelText: "Email",
                          ),
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email address';
                            }

                            return null;
                          },
                        ),
                        TextFormField(
                          controller: passwordController,
                          autocorrect: true,
                          textAlign: TextAlign.left,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                          ),
                          decoration: const InputDecoration(
                            labelText: "Password",
                          ),
                          keyboardType: TextInputType.visiblePassword,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }

                            return null;
                          },
                        ),
                        Container(
                          height: 50,
                          width: 380,
                          margin: const EdgeInsets.only(top: 50),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  email = emailController.text;
                                  name = nameController.text;
                                  password = passwordController.text;
                                });
                              }
                              registration();
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(
                                HexColor("146c94"),
                              ),
                            ),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                fontSize: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          " -- or continue  with --",
                          style: TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            signInWithGoogle();
                          },
                          child: Text("Sign in with Google"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => login_page(),
                          ),
                        );
                      },
                      child: const Text("Sign in"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}