// ignore_for_file: unnecessary_import
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:demo/Navbar/nav_bar.dart';
import 'package:demo/email_auth/forgot_password_page.dart';
import 'package:demo/home_page/home_page.dart';
import 'package:demo/email_auth/signup_page.dart';

import 'fingerprint_add.dart';

// ignore: camel_case_types
class login_page extends StatefulWidget {
  const login_page({super.key});

  @override
  State<login_page> createState() => _login_pageState();
}

// ignore: camel_case_types
class _login_pageState extends State<login_page> {
  bool passwordVisible = false;
  bool? isChecked = false;

  String email = "", password = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  userLogin() async {
    if ( emailController.text != "" && passwordController.text != "") {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Login Successfully",
              style: TextStyle(fontSize: 20.0),
            )));
        // Navigator.push(
          // context,
        //   MaterialPageRoute(
        //     builder: (context) => PostWidget(
        //       username: 'John Doe',
        //       text: 'This is a sample post.',
        //       likes: 10,
        //       postImage: 'https://firebasestorage.googleapis.com/v0/b/india-7bec1.appspot.com/o/postPictures%2Feb986470-f0d4-11ee-8986-999cacecd0f9?alt=media&token=aaa24524-efe3-414f-9946-f31939d52754',
        //     ),
        //   ),
        // );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context)=> const Nav_Bar(),
          )
        );
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "No User Found for that Email",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        } else if (e.code == 'invalid-credential') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Wrong Email/Password Provided by User",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        }
        else if(e.code=='too-many-requests'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Too-many-Requests",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        }
        else if(e.code=='invalid-email'){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            backgroundColor: Colors.orangeAccent,
            content: Text(
              "Invalid Email Address.",
              style: TextStyle(fontSize: 18.0),
            ),
          ));
        }
        print(e.code);

      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Image.asset("assets/images/login.png"),
        toolbarHeight: 150,
      ),
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 30),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(top: 110),
                          child: Image.asset("assets/images/login_cont.png"),
                        ),
                        Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.only(
                              left: 120, bottom: 0, top: 20),
                          child: Image.asset("assets/images/boy_login.png"),
                        ),
                        Container(
                          width: 350,
                          margin: const EdgeInsets.only(top: 200, left: 30),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextFormField(
                                controller: emailController,
                                autocorrect: true,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: const InputDecoration(
                                  label: Text("Email"),
                                ),
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your email address';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  email = value!;
                                },
                              ),
                              TextFormField(
                                controller: passwordController,
                                obscureText: passwordVisible,
                                autocorrect: true,
                                textAlign: TextAlign.left,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400,
                                ),
                                decoration: InputDecoration(
                                  label: const Text("Password"),
                                  suffixIcon: IconButton(
                                    icon: Icon(passwordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off),
                                    onPressed: () {
                                      setState(() {
                                        passwordVisible = !passwordVisible;
                                      });
                                    },
                                  ),
                                  alignLabelWithHint: false,
                                ),
                                keyboardType: TextInputType.visiblePassword,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter your password';
                                  }
                                  // You can add more sophisticated password validation logic here if needed
                                  return null;
                                },
                                onSaved: (value) {
                                  password = value!;
                                },
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                autofocus: true,
                                splashRadius: 20,
                                value: isChecked,
                                checkColor: Colors.white,
                                activeColor: Colors.black,
                                onChanged: (newBlue) {
                                  setState(() {
                                    isChecked = newBlue;
                                  });
                                }),
                            const Text(
                              "Remember Me",
                              style: TextStyle(fontSize: 17),
                            )
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Forgot_Password_Page(),
                                ),
                              );
                            },
                            child: const Text(
                              "Forgot Password?",
                              style: TextStyle(fontSize: 17),
                            ))
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          userLogin();
                        }
                      },
                      style: ButtonStyle(
                        animationDuration: const Duration(seconds: 2),
                        backgroundColor:
                        MaterialStateProperty.all(HexColor("146c94")),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have Account ?"),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const sign_up(),
                                  ),
                                );
                              },
                              child: const Text("Sign up"))
                        ],
                      ),
                    )
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
