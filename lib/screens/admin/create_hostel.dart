// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';
import 'package:hostel_ease/widgets/textfiled.dart';

class CreateHostel extends StatelessWidget {
  const CreateHostel({super.key});

  @override
  Widget build(BuildContext context) {
    TextEditingController numberofFloors = TextEditingController();
    TextEditingController hostelName = TextEditingController();
    TextEditingController hostelID = TextEditingController();

    Future<void> create() async {
      if (hostelName.text.isNotEmpty && numberofFloors.text.isNotEmpty) {
        String result = await DBmethods().addHostel(
            hostelName: hostelName.text,
            hostelId: hostelID.text,
            numberOfFloors: numberofFloors.text);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(result),
        ));
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Please fill all the fields'),
        ));
      }
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Hostel Ease'),
        ),
        body: Column(
          children: [
            const Spacer(),
            const Text(
              'Create Hostel',
              style: TextStyle(fontSize: 54, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInput(hint: 'Hostel Name', controller: hostelName),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInput(
                  hint: 'Number of Floors',
                  controller: numberofFloors,
                  keybordType: TextInputType.number),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextInput(
                hint: 'Hostel ID',
                controller: hostelID,
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
                  'Create Hostel',
                  style: TextStyle(fontSize: 20, color: Colors.white),
                )),
            const Spacer()
          ],
        ));
  }
}
