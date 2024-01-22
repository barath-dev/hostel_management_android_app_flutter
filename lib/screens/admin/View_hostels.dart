// ignore_for_file: prefer_interpolation_to_compose_strings, unused_element, non_constant_identifier_names

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/screens/admin/create_warden.dart';

class ViewHostels extends StatefulWidget {
  const ViewHostels({super.key});

  @override
  State<ViewHostels> createState() => _ViewHostelsState();
}

class _ViewHostelsState extends State<ViewHostels> {
  TextEditingController floorController = TextEditingController();

  addFloor(String floors, String hid) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text("Add Floors"),
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Enter the number of floors',
                ),
                controller: floorController,
              ),
              Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Cancel"),
                  ),
                  GestureDetector(
                    child: const Text("Add Floors"),
                    onTap: () async {
                      var list = [];
                      for (int i = 1;
                          i <= int.parse(floorController.text.toString());
                          i++) {
                        for (int j = 1; j <= 10; j++) {
                          list.add(i.toString() + '0' + j.toString());
                          debugPrint("in list");
                        }
                      }
                      log("$list");
                      log("crossed");
                      await FirebaseFirestore.instance
                          .collection('hostels')
                          .doc(hid)
                          .update({
                        'numberOfFloors': (int.parse(floorController.text) +
                                int.parse(floors))
                            .toString(),
                        'available rooms': FieldValue.arrayUnion(list)
                      });
                    },
                  )
                ],
              )
            ],
          );
        });
  }

  _selectOption(BuildContext context, String hostel, String HostelID,
      String hid, String floors) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('create a account in hostel $hostel'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(10),
                child: const Text(''),
                onPressed: () async {
                  Navigator.of(context).pop();
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(15),
                child: const Text('Create Warden Account'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateWarden(
                              hostelId: HostelID,
                              hostelName: hostel,
                              hid: hid)));
                },
              ),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(15),
                  child: const Text('Add floors to the selected Hostel'),
                  onPressed: () async {
                    addFloor(floors, hid);
                  }),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(15),
                  child: const Text('View Students in the selected Hostel'),
                  onPressed: () async {}),
              SimpleDialogOption(
                  padding: const EdgeInsets.all(15),
                  child: const Text('View Warden in the selected Hostel'),
                  onPressed: () async {}),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            'View Hostels',
            style: TextStyle(color: Colors.black),
          ),
        ),
        body: StreamBuilder(
            stream:
                FirebaseFirestore.instance.collection('hostels').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () async {
                          await _selectOption(
                            context,
                            snapshot.data!.docs[index]['name'],
                            snapshot.data!.docs[index]['hostelId'],
                            snapshot.data!.docs[index]['hId'],
                            snapshot.data!.docs[index]['numberOfFloors'],
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.blue[900],
                                borderRadius: BorderRadius.circular(20)),
                            child: ListTile(
                              title: Text(
                                "Hostel Name: " +
                                    snapshot.data!.docs[index]['name'] +
                                    "\n",
                                style: const TextStyle(color: Colors.white),
                              ),
                              subtitle: Text(
                                "${"Number of Floors: " + snapshot.data!.docs[index]['numberOfFloors']} \n\n Hostel ID: " +
                                    snapshot.data!.docs[index]['hostelId'] +
                                    "\n\n Student count: " +
                                    snapshot.data!.docs[index]['student count']
                                        .toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                              trailing: IconButton(
                                  onPressed: () {
                                    FirebaseFirestore.instance
                                        .collection('hostels')
                                        .doc(snapshot.data!.docs[index].id)
                                        .delete();
                                    const SnackBar(
                                        content: Text(
                                            'Hostel Deleted Successfully'));
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    color: Colors.white,
                                  )),
                            ),
                          ),
                        ),
                      );
                    });
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            }));
  }
}
