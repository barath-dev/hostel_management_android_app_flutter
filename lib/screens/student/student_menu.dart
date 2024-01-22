// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hostel_ease/screens/common/choose_role.dart';
import 'package:hostel_ease/screens/student/applyLeave_pass.dart';
import 'package:hostel_ease/screens/student/book_Room.dart';
import 'package:hostel_ease/screens/student/my_queries.dart';
import 'package:hostel_ease/screens/student/query_screen.dart';
import 'package:hostel_ease/screens/student/viewLeacePass.dart';

class Studentmenu extends StatefulWidget {
  const Studentmenu({super.key});

  @override
  State<Studentmenu> createState() => _StudentmenuState();
}

class _StudentmenuState extends State<Studentmenu> {
  List<String> list = <String>[
    'Book Room',
    'Raise Query',
    'View queries',
    'Apply Leave Pass',
    'View Leave Pass',
    'Logout'
  ];
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 20),
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
                                      builder: (context) =>
                                          const BookRoomScreen()));
                            } else if (index == 1) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const QuesryScreenStudent()));
                            } else if (index == 2) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const MyQueries()));
                            } else if (index == 3) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ApplyLeave()));
                            } else if (index == 4) {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const ViewLeavePass()));
                            } else if (index == 5) {
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
