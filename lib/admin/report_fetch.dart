import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:demo/police/police_action.dart';
import 'package:intl/intl.dart';

class AdminComplaintsPage extends StatelessWidget {
  const AdminComplaintsPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Complaints'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('complaints').snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;
              Timestamp timestamp =
                  data['timeofComplaint']; // Get the timestamp
              DateTime dateTime = timestamp.toDate();
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ComplaintDetailsPage(data: data),
                    ),
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      child: Text(data['username']
                          [0]), // Displaying first character of username
                    ),
                    title: Text("Username : ${data['username']}"),
                    subtitle: Text('Complaint Id : ${data['complaintId']}'),
                    trailing: Icon(Icons.arrow_forward_ios),
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class ComplaintDetailsPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const ComplaintDetailsPage({required this.data});

  void _deleteComplaint(BuildContext context, String documentId) async {
    // Show confirmation dialog
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this complaint?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(true); // Return true to confirm deletion
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // Return false to cancel deletion
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );

    // Check user's choice
    if (confirmDelete == true) {
      // User confirmed deletion, proceed with deletion
      try {
        await FirebaseFirestore.instance
            .collection('complaints')
            .doc(documentId)
            .delete();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Complaint deleted successfully.'),
            duration: Duration(seconds: 2),
          ),
        );
        Navigator.pop(context); // Go back to previous page after deletion
      } catch (error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting complaint: $error'),
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DataTable(
                columns: [
                  DataColumn(label: Text('Field')),
                  DataColumn(label: Text('Value')),
                ],
                rows: [
                  DataRow(cells: [
                    DataCell(Text('Time of Complaint')),
                    DataCell(Text('timeofComplaint')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Username')),
                    DataCell(Text(data['username'])),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Email Address')),
                    DataCell(Text(data['email'])),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Mobile')),
                    DataCell(Text(data['phoneNumber'])),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Address')),
                    DataCell(Text(data['address'])),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('City')),
                    DataCell(Text(data['city'] ??
                        'N/A')), // Display 'N/A' if city is null
                  ]),
                  DataRow(cells: [
                    DataCell(Text('State')),
                    DataCell(Text(data['state'] ??
                        'N/A')), // Display 'N/A' if state is null
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Account No')),
                    DataCell(Text(data['bankAccountNo'])),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Aadhar No')),
                    DataCell(Text(data['aadharNumber'])),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Evidence Details')),
                    DataCell(Text(data['evidenceDescription'])),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Suspect Details')),
                    DataCell(Text(data['suspectMedia'])),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Suspect Media')),
                    DataCell(Text(data['suspectDetails'])),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Date')),
                    DataCell(Text('date')),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Time')),
                    DataCell(Text(data['time'])),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Transaction ID')),
                    DataCell(Text(data['transactionId'])),
                  ]),
                  DataRow(cells: [
                    DataCell(Text('Complaint Id')),
                    DataCell(Text(data['complaintId'] ??
                        'N/A')), // Display 'N/A' if uniqueId is null
                  ]),
                ],
              ),
              SizedBox(height: 20),
              Text(
                'Evidence Image:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _showFullImage(context, data['reportImage']);
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: data['reportImage'] != null
                      ? Image.network(
                          data['reportImage'],
                          fit: BoxFit.cover,
                        )
                      : Placeholder(),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Id Proof:',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              GestureDetector(
                onTap: () {
                  _showFullImage(
                      context,
                      data[
                          'idProof']); // Assuming 'aadharPhoto' key for Aadhar photo
                },
                child: Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: data['idProof'] != null
                      ? Image.network(
                          data['idProof'],
                          fit: BoxFit.cover,
                        )
                      : Placeholder(),
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => const Police_Action()),
            //     );
            //     // You can use Firestore update to update the status of the complaint
            //   },
            //   child: Text('Action'),
            // ),
            ElevatedButton(
              onPressed: () {
                _deleteComplaint(context, data['complaintId']);
              },
              child: const Text('Delete Complaint'),
            ),
          ],
        ),
      ),
    );
  }
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
                    // _downloadImage(context, imageUrl);
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