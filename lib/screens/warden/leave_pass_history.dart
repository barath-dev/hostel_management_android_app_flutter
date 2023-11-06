import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class LeavePassHistory extends StatefulWidget {
  const LeavePassHistory({super.key});

  @override
  State<LeavePassHistory> createState() => _LeavePassHistoryState();
}

class _LeavePassHistoryState extends State<LeavePassHistory> {
  @override
  Widget build(BuildContext context) {
    Color color;
    Color choose(String status) {
      if (status == 'accepted') {
        color = Colors.green;
      } else if (status == 'rejected') {
        color = Colors.red;
      } else {
        color = Colors.yellow;
      }
      return color;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Ease'),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('leavePass')
            .where('status', isNotEqualTo: 'pending')
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: Container(
                      decoration: BoxDecoration(
                          color: choose(snapshot.data!.docs[index]['status']),
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        title: Text(
                          // ignore: prefer_interpolation_to_compose_strings
                          "${"Reason: " + snapshot.data!.docs[index]['reason']}\n",
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          "${"From Date: ${snapshot.data!.docs[index]['from date'].toString().substring(0, 10)}"}\n"
                          "status:  ${snapshot.data!.docs[index]['status']}",
                          style: const TextStyle(color: Colors.white),
                        ),
                        trailing: TextButton(
                          onPressed: () {},
                          child: const Text(
                            'View',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  );
                });
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
