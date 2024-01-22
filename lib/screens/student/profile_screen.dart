import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Account"),
      ),
      body: FutureBuilder(
          future: FirebaseFirestore.instance
              .collection('students')
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get(),
          builder:
              (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            return Column(
              children: [
                const Spacer(),
                const Text("Student Details"),
                const SizedBox(
                  height: 20,
                ),
                const Text("Name"),
                const SizedBox(
                  height: 20,
                ),
                const Text("Student Mail"),
                const SizedBox(
                  height: 20,
                ),
                Text(snapshot.data!.get('student mail')),
                const SizedBox(
                  height: 20,
                ),
                const Text("Department"),
                const SizedBox(
                  height: 20,
                ),
                Text(snapshot.data!.get('department')),
                const SizedBox(
                  height: 20,
                ),
                const Text("Hostel"),
                const SizedBox(
                  height: 20,
                ),
                const Text("")
              ],
            );
          }),
    );
  }
}
