import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:demo/Community/posts.dart';

class PostCreationScreen extends StatefulWidget {
  const PostCreationScreen({Key? key}) : super(key: key);

  @override
  _PostCreationScreenState createState() => _PostCreationScreenState();
}

class _PostCreationScreenState extends State<PostCreationScreen> {
  String text = "";
  String userName="";
  File? postImage;
  TextEditingController textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Future<void> getUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String uid = user.uid;
      if (uid.isNotEmpty) {
        DocumentSnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
        if (snapshot.exists) {
          setState(() {
            userName = snapshot.data()?['name'] ?? 'John Doe'; // If name is null, set to 'John Doe'
          });
        }
      }
    } else {
      // Set username to 'John Doe' if user is null
      setState(() {
        userName = 'John Doe';
      });
    }
  }


  Future<void> addPostToFirebase() async {
    // Show a loading indicator
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent user from dismissing the dialog
      builder: (BuildContext context) {
        return const AlertDialog(
          title: Text('Creating Post'),
          content: CircularProgressIndicator(),
        );
      },
    );

    if (text.isNotEmpty && postImage != null) {
      try {
        UploadTask uploadTask = FirebaseStorage.instance
            .ref()
            .child("postPictures/${Uuid().v1()}")
            .putFile(postImage!);
        TaskSnapshot taskSnapshot = await uploadTask;
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        Map<String, dynamic> postData = {
          "username": userName,
          "text": text,
          "likes": 0,
          "postImage": downloadUrl
        };

        await FirebaseFirestore.instance.collection("posts").add(postData);
        print("Post created!");

        print("going back to posts screen");
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => PostWidget(),));


      } catch (e) {
        print("Error uploading post: $e");
        // Close the dialog
        Navigator.pop(context);
        // Show an error message
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Failed to create post. Please try again.'),
          duration: Duration(seconds: 1), // Show for 2 seconds
        ));
      }
    } else {
      // Close the dialog
      Navigator.pop(context);
      // Show an error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please fill all the fields!'),
        duration: Duration(seconds: 1), // Show for 2 seconds
      ));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: AlertDialog(
        title: Text('Create Post'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: textController,
              maxLines: null,
              onChanged: (value) {
                setState(() {
                  text = value;
                });
              },
              decoration: InputDecoration(
                hintText: "Write about your digital Fraud?",
              ),
            ),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                XFile? selectedImage =
                await ImagePicker().pickImage(source: ImageSource.gallery);

                if (selectedImage != null) {
                  File convertedFile = File(selectedImage.path);
                  setState(() {
                    postImage = convertedFile;
                  });
                  print("Image Selected");
                } else {
                  print("No image selected");
                }
              },
              child: Text('Select Photo'),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    await addPostToFirebase();
                    Navigator.of(context).pop();
                  },
                  child: Text('Tweet'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Cancel'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
