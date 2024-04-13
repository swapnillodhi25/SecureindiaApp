import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:demo/Community/discussion_page.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class PostWidget extends StatefulWidget {
  @override
  _PostWidgetState createState() => _PostWidgetState();
}

class _PostWidgetState extends State<PostWidget> {
  Future<List<Map<String, dynamic>>> _fetchPosts() async {
    QuerySnapshot snapshot =
    await FirebaseFirestore.instance.collection('posts').get();
    List<Map<String, dynamic>> postsData = [];
    for (var doc in snapshot.docs) {
      Map<String, dynamic> postData = doc.data() as Map<String, dynamic>;
      postsData.add(postData);
    }
    return postsData;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Posts'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchPosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  Map<String, dynamic> postData = snapshot.data![index];
                  return _buildPostItem(context, postData);
                },
              );
            } else {
              return Center(
                child: Text('No posts available'),
              );
            }
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const PostCreationScreen()),
          ).then((_) {
            // Refresh the widget after returning from PostCreationScreen
            setState(() {});
          });
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPostItem(BuildContext context, Map<String, dynamic> postData) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            leading: CircleAvatar(
              child: Text(
                postData['username'][0] ?? 'J',
                style: TextStyle(color: Colors.white),
              ),
              backgroundColor: Colors.blue,
            ),
            title: Text(postData['username'] ?? "John Doe"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(postData['text']),
          ),
          if (postData['postImage'] != null)
            InkWell(
              onTap: () {
                _showFullImage(context, postData['postImage']);
              },
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network(
                    postData['postImage'],
                    height: 300,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ButtonBar(
            alignment: MainAxisAlignment.start,
            children: [
              IconButton(
                icon: Icon(Icons.thumb_up),
                onPressed: () {
                  // Implement like functionality
                },
              ),
              Text('${postData['likes'] ?? 0}'),
              IconButton(
                icon: Icon(Icons.share),
                onPressed: () {
                  // Implement share functionality
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showFullImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: PhotoView(
                    imageProvider: NetworkImage(imageUrl),
                    minScale: PhotoViewComputedScale.contained * 0.8,
                    maxScale: PhotoViewComputedScale.covered * 2,
                    enableRotation: true,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Icon(Icons.download),
                    onPressed: () {
                      _downloadImage(context, imageUrl);
                    },
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _downloadImage(BuildContext context, String imageUrl) async {
    final response = await http.get(Uri.parse(imageUrl));
    final bytes = response.bodyBytes;
    final directory = await getExternalStorageDirectory();
    final imagePath = '${directory!.path}/image.png';
    final File imageFile = File(imagePath);
    await imageFile.writeAsBytes(bytes);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        'Image downloaded successfully',
        style: TextStyle(fontSize: 20.0),
      ),
    ));
  }
}
