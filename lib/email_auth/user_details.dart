import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:demo/email_auth/congratulations.dart';
import 'package:demo/email_auth/fingerprint_add.dart';


class UserProfilePage extends StatefulWidget {
  const UserProfilePage({Key? key});

  @override
  _UserProfilePageState createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController _fullNameController = TextEditingController();
  TextEditingController _occupationController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _dobController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  String _gender = 'Male'; // Default gender
  File? _userImage;
  bool _isSaving = false;

  // Function to handle image selection
  Future<void> _selectImage() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _userImage = File(pickedImage.path);
      });
    }
  }

  // Function to validate email format
  bool _isValidEmail(String value) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  // Function to upload user image to Firebase Storage
  Future<String> _uploadUserImage() async {
    Reference storageReference = FirebaseStorage.instance.ref().child('user_images/${FirebaseAuth.instance.currentUser!.uid}');
    UploadTask uploadTask = storageReference.putFile(_userImage!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    String imageUrl = await taskSnapshot.ref.getDownloadURL();
    return imageUrl;
  }

  // Function to save user profile details to Firestore
  Future<void> _saveUserProfile() async {
    setState(() {
      _isSaving = true;
    });
    if (_userImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please select a user image.'),
        duration: Duration(seconds: 3),
      ));
      setState(() {
        _isSaving = false;
      });
      return;
    }
    String imageUrl = await _uploadUserImage();
    String uid = FirebaseAuth.instance.currentUser!.uid;
    await FirebaseFirestore.instance.collection('users').doc(uid).set({
      'fullName': _fullNameController.text,
      'occupation': _occupationController.text,
      'email': _emailController.text,
      'dob': _dobController.text,
      'phoneNumber': _phoneNumberController.text,
      'gender': _gender,
      'imageUrl': imageUrl,
    });
    setState(() {
      _isSaving = false;
    });
    // Navigate to the next page
    Navigator.push(context, MaterialPageRoute(builder: (context) =>  SetFingerprintPage(),));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Profile'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              GestureDetector(
                onTap: _selectImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundImage: _userImage != null ? FileImage(_userImage!) : AssetImage('assets/images/default_user_image.jpeg') as ImageProvider,
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _fullNameController,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your full name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _occupationController,
                decoration: InputDecoration(
                  labelText: 'Occupation',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your occupation';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else if (!_isValidEmail(value)) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _dobController,
                decoration: InputDecoration(
                  labelText: 'Date of Birth',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your date of birth';
                  }
                  return null;
                },
                onTap: () async {
                  // Show date picker dialog
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (selectedDate != null) {
                    setState(() {
                      _dobController.text = selectedDate.toString();
                    });
                  }
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneNumberController,
                decoration: InputDecoration(
                  labelText: 'Phone Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              DropdownButtonFormField(
                value: _gender,
                onChanged: (value) {
                  setState(() {
                    _gender = value.toString();
                  });
                },
                items: ['Male', 'Female', 'Other'].map((gender) {
                  return DropdownMenuItem(
                    value: gender,
                    child: Text(gender),
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Gender',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSaving
                    ? null
                    : () async {
                  if (_formKey.currentState!.validate()) {
                    await _saveUserProfile();
                  }
                },
                child: _isSaving
                    ? CircularProgressIndicator()
                    : Text('Save Profile & Continue'),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
