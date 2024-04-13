import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:gap/gap.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:demo/admin/congratulation.dart';

class Police_Signup extends StatefulWidget {
  const Police_Signup({Key? key}) : super(key: key);

  @override
  State<Police_Signup> createState() => _Police_SignupState();
}

class _Police_SignupState extends State<Police_Signup> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _numberController = TextEditingController();
  final _emailController = TextEditingController();
  final _cityController = TextEditingController();
  final _policeIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _loading = false;

  void _addPoliceData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _loading = true;
      });

      try {
        await FirebaseFirestore.instance.collection('polices').doc(_policeIdController.text).set({
          'name': _nameController.text,
          'number': _numberController.text,
          'email': _emailController.text.trim().toLowerCase(),
          'city': _cityController.text.trim().toLowerCase(),
          'policeId': _policeIdController.text,
          'password': _passwordController.text,
        });


        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Police details added successfully'),
        ));
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Congratulation()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error: $e'),
        ));
      }

      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: HexColor("C7F5F5"),
        toolbarHeight: 30,
      ),
      backgroundColor: HexColor("C7F5F5"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              "assets/images/emp_login.png",
            ),
            Gap(20),
            Text(
              "Member Details",
              style: TextStyle(fontSize: 22, color: HexColor("000000")),
            ),
            Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      hintText: "Enter Name",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter name';
                      }
                      return null;
                    },
                  ),
                  Gap(10),
                  TextFormField(
                    controller: _numberController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.phone),
                      hintText: "Enter Number",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter phone number';
                      }
                      return null;
                    },
                  ),
                  Gap(10),
                  TextFormField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      hintText: "Enter Email Id",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter email';
                      }
                      return null;
                    },
                  ),
                  Gap(10),
                  TextFormField(
                    controller: _cityController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.location_city),
                      hintText: "Enter City",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter city';
                      }
                      return null;
                    },
                  ),
                  Gap(10),
                  TextFormField(
                    controller: _policeIdController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.badge),
                      hintText: "Code/Id of Department",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter department ID';
                      }
                      return null;
                    },
                  ),
                  Gap(10),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: !_passwordVisible,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_passwordVisible
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _passwordVisible = !_passwordVisible;
                          });
                        },
                      ),
                      hintText: "Create Password",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  Gap(10),
                ],
              ),
            ),
            Container(
              width: 300,
              height: 50,
              margin: EdgeInsets.only(left: 0, top: 20),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  elevation: 3,
                  shadowColor: Colors.black,
                  backgroundColor: HexColor("008FDC"),
                ),
                onPressed: _loading ? null : _addPoliceData,
                child: _loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text('Add Police Credentials',
                    style: TextStyle(color: Colors.white, fontSize: 19)),
              ),
            ),
            Gap(10),
          ],
        ),
      ),
    );
  }
}
