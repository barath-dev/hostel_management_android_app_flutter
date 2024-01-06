// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';
import 'package:hostel_ease/widgets/textfiled.dart';

class CreateWarden extends StatefulWidget {
  final String hostelId;
  final String hostelName;
  final String hid;

  const CreateWarden(
      {super.key,
      required this.hostelId,
      required this.hostelName,
      required this.hid});

  @override
  State<CreateWarden> createState() => _CreateWardenState();
}

class _CreateWardenState extends State<CreateWarden> {
  TextEditingController wardenMail = TextEditingController();
  TextEditingController wardenName = TextEditingController();
  TextEditingController age = TextEditingController();
  TextEditingController password = TextEditingController();

  Future<void> create() async {
    if (wardenName.text.isNotEmpty &&
        wardenMail.text.isNotEmpty &&
        age.text.isNotEmpty &&
        password.text.isNotEmpty) {
      String result = await DBmethods().createWarden(
          wardensName: wardenName.text,
          wardensEmail: wardenMail.text,
          age: age.text,
          password: password.text,
          hId: widget.hid);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(result),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please fill all the fields'),
      ));
    }
  }

  @override
  void dispose() {
    wardenMail.dispose();
    wardenName.dispose();
    age.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Hostel Ease'),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 85,
              ),
              Text(
                'Create Warden account \n Hostel Name:${widget.hostelName} \n Hostel ID:${widget.hostelId}',
                // ignore: prefer_const_constructors
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(hint: 'Warden Name', controller: wardenName),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(hint: 'Warden Mail', controller: wardenMail),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(
                  hint: 'Age',
                  controller: age,
                  keybordType: TextInputType.number,
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextInput(
                  hint: 'Password',
                  controller: password,
                  isPassword: true,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                  onPressed: () {
                    create();
                  },
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blue[900])),
                  child: const Text(
                    'Create Warden',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  )),
            ],
          ),
        ));
  }
}
