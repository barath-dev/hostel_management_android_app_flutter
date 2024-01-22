// ignore_for_file: file_names, use_build_context_synchronously, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hostel_ease/resources/DBmethods.dart';
import 'package:hostel_ease/screens/student/student_menu.dart';

class ChooseRoom extends StatefulWidget {
  final List<dynamic> rooms;
  final String hid;
  final String name;
  const ChooseRoom(
      {super.key, required this.rooms, required this.hid, required this.name});

  @override
  State<ChooseRoom> createState() => _ChooseRoomState();
}

class _ChooseRoomState extends State<ChooseRoom> {
  @override
  void initState() {
    super.initState();
  }

  _confirmBook(
    String room,
    String floor,
    String name,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Confirm Booking'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(15),
                child: RichText(
                    text: TextSpan(
                  text: 'Room No: ',
                  style: const TextStyle(color: Colors.black, fontSize: 20),
                  children: [
                    TextSpan(
                      text: room,
                      style: const TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    const TextSpan(
                      text: '\nFloor No: ',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    TextSpan(
                      text: floor,
                      style: const TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    const TextSpan(
                      text: '\nHostel Name: ',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    TextSpan(
                      text: name,
                      style: const TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                    const TextSpan(
                      text: '\nPayment:',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                    TextSpan(
                      text: 'Rs. 5000',
                      style: const TextStyle(color: Colors.blue, fontSize: 20),
                    ),
                  ],
                )),
                onPressed: () async {},
              ),
              Row(
                children: [
                  const Spacer(),
                  SimpleDialogOption(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Cancel',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(context).pop();
                      }),
                  SimpleDialogOption(
                      padding: const EdgeInsets.all(15),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(20)),
                        child: const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(
                            'Pay & Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      onPressed: () async {
                        await bookRoom(room, floor);
                        ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text(
                                    'Payment successful and Room Booked')));
                        Navigator.of(context).pop();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Studentmenu()));
                      }),
                  const Spacer(),
                ],
              ),
            ],
          );
        });
  }

  Future<void> bookRoom(room, floor) async {
    // ignore: unused_local_variable
    DBmethods db = DBmethods();
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    Object snapshot =
        await db.getStudentDetails(uid: FirebaseAuth.instance.currentUser!.uid);

    if (snapshot is String) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error Occured\n$snapshot')));
    } else {
      Map<String, dynamic> studentDetails = snapshot as Map<String, dynamic>;
      if (studentDetails['room no'] != null) {
        await firestore
            .collection('hostels')
            .doc(studentDetails['hid'])
            .update({
          'available rooms':
              FieldValue.arrayUnion(['${studentDetails['room no']}'])
        });
      }
    }

    await firestore
        .collection('students')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({
      'room no': room,
      'hid': widget.hid,
      'floor no': floor,
    });
    await firestore
        .collection('hostels')
        .doc(widget.hid)
        .update({'student count': FieldValue.increment(1)});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Choose Room'),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                },
                icon: Icon(Icons.refresh_rounded))
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              widget.rooms.isNotEmpty
                  ? ListView.builder(
                      itemCount: widget.rooms.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        // print(widget.rooms[index]['room no'])
                        // print(widget.rooms[index]);
                        var room = widget.rooms[index]['room no'];
                        var floor = widget.rooms[index]['available beds'];
                        var availableBeds =
                            widget.rooms[index]['available beds'];
                        return ListTile(
                          tileColor:
                              availableBeds == 0 ? Colors.orange : Colors.white,
                          leading: const Icon(Icons.home_rounded),
                          title: const Text('Room No:'),
                          subtitle: Text(room),
                          trailing: Text('Floor:$floor'),
                          onTap: () {
                            !(availableBeds == 0)
                                ? _confirmBook(room.toString(),
                                    floor.toString(), widget.name.toString())
                                : ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Room Full')));
                          },
                        );
                      },
                    )
                  : Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 2 - 100),
                      child: const Center(
                        child: Text(
                          'No Rooms Available',
                          style: TextStyle(
                              fontSize: 32,
                              color: Colors.blue,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
            ],
          ),
        ));
  }
}
