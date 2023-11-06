import 'package:flutter/material.dart';

// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:hostel_ease/screens/common/choose_role.dart';
import 'package:hostel_ease/screens/warden/leavePass_list.dart';
import 'package:hostel_ease/screens/warden/query_list.dart';
import 'package:hostel_ease/screens/warden/query_screen.dart';

class WardenMenu extends StatefulWidget {
  const WardenMenu({super.key});

  @override
  State<WardenMenu> createState() => _WardenMenuState();
}

class _WardenMenuState extends State<WardenMenu> {
  List<String> list = <String>[
    'Accept or Reject LeavePass',
    'Manage Queries',
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
                                  builder: (context) => const LeavePassList()));
                        } else if (index == 1) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const QueryList()));
                        } else if (index == 2) {
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
