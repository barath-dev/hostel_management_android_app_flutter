// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';

class LeavePassList extends StatefulWidget {
  const LeavePassList({super.key});

  @override
  State<LeavePassList> createState() => _LeavePassListState();
}

class _LeavePassListState extends State<LeavePassList> {
  @override
  void initState() {
    getWarden();
    super.initState();
  }

  String wardenId = '';

  void getWarden() async {
    wardenId = await DBmethods().getWardenHid();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Leave Pass'),
        ),
        body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('leavePass')
              .where('status', isEqualTo: 'pending')
              .where('warden email',
                  isEqualTo: FirebaseAuth.instance.currentUser!.email)
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    if (snapshot.data!.docs.isEmpty) {
                      return const Center(
                        child: Text('No Leave Pass'),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(20)),
                        child: ListTile(
                          title: Text(
                            "${"Reason: " + snapshot.data!.docs[index]['reason']}\n",
                            style: const TextStyle(color: Colors.white),
                          ),
                          subtitle: Text(
                            "${"From: " + snapshot.data!.docs[index]['from date'].toString().substring(0, 10)}\n"
                            "${"To: " + snapshot.data!.docs[index]['to date'].toString().substring(0, 10)}\n"
                            "${"Status: " + snapshot.data!.docs[index]['status']}\n",
                            style: const TextStyle(color: Colors.white),
                          ),
                          trailing: IconButton(
                            onPressed: () {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text('Accept or Reject'),
                                      content: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: [
                                          ElevatedButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('leavePass')
                                                    .doc(snapshot
                                                        .data!.docs[index].id)
                                                    .update(
                                                        {'status': 'accepted'});
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Accept')),
                                          ElevatedButton(
                                              onPressed: () {
                                                FirebaseFirestore.instance
                                                    .collection('leavePass')
                                                    .doc(snapshot
                                                        .data!.docs[index].id)
                                                    .update(
                                                        {'status': 'rejected'});
                                                Navigator.pop(context);
                                              },
                                              child: const Text('Reject')),
                                        ],
                                      ),
                                    );
                                  });
                            },
                            icon: const Icon(Icons.edit),
                          ),
                        ),
                      ),
                    );
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
