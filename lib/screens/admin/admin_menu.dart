// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/screens/admin/View_hostels.dart';
import 'package:hostel_ease/screens/admin/create_hostel.dart';
import 'package:hostel_ease/screens/admin/create_student_screen.dart';
import 'package:hostel_ease/screens/common/choose_role.dart';

class Adminmenu extends StatefulWidget {
  const Adminmenu({super.key});

  @override
  State<Adminmenu> createState() => _AdminmenuState();
}

class _AdminmenuState extends State<Adminmenu> {
  List<String> list = <String>['Add Hostel', 'View Hostels', 'Create Student', 'Logout'];
  @override
  Widget build(BuildContext context) {
    void logout() async {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const ChooseRole(
                    isLogin: true,
                  )));
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostel Ease'),
      ),
        body: Container(
      decoration: const BoxDecoration(
          image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                'assets/images/img.jpeg',
              ))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ListView.builder(
              shrinkWrap: true,
              itemCount: list.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(20)),
                    child: ListTile(
                      title: Center(
                          child: Text(
                        list[index],
                        style: const TextStyle(color: Colors.white),
                      )),
                      onTap: () {
                        if (index == 0) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateHostel()));
                        } else if (index == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ViewHostels()));
                        } else if (index == 2) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreateStudent()));
                        } else if (index == 3) {
                          logout();
                        }
                      },
                    ),
                  ),
                );
              }),
        ],
      ),
    ));
  }
}
