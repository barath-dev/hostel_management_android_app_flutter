// ignore_for_file: use_build_context_synchronously, unused_element

import 'package:flutter/material.dart';
import 'package:hostel_ease/resources/DBmethods.dart';
import 'package:hostel_ease/screens/student/student_menu.dart';

class ApplyLeave extends StatefulWidget {
  const ApplyLeave({super.key});

  @override
  State<ApplyLeave> createState() => _ApplyLeaveState();
}

class _ApplyLeaveState extends State<ApplyLeave> {
  TextEditingController reason = TextEditingController();
  TextEditingController contact = TextEditingController();
  TextEditingController address = TextEditingController();

  DateTime selectedTodate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime selectedFromDate =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  @override
  Widget build(BuildContext context) {
    Future<DateTime?> pickDate() => showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        initialDate: DateTime.now());

    Future<TimeOfDay?> pickTime() =>
        showTimePicker(context: context, initialTime: TimeOfDay.now());

    Future<void> upload() async {
      if (reason.text.isNotEmpty &&
          contact.text.isNotEmpty &&
          address.text.isNotEmpty) {
        String res = await DBmethods().applyLeavePass(
            reason: reason.text,
            contact: contact.text,
            address: address.text,
            Fromdate: selectedFromDate.toString(),
            Todate: selectedTodate.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(res)));
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Fill all fields')));
      }
    }

    @override
    void dispose() {
      reason.dispose();
      contact.dispose();
      address.dispose();
      super.dispose();
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 50,
            ),
            const Text(
              'Apply Leave',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: reason,
                decoration: InputDecoration(
                  hintText: 'Reason',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Text(
                    'From :',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () async {
                        final date = await pickDate();
                        // final time = await pickTime();
                        if (date == null) return;
                        // if (time == null) return;

                        setState(() {
                          selectedFromDate = date;
                          selectedFromDate = DateTime(
                            selectedFromDate.year,
                            selectedFromDate.month,
                            selectedFromDate.day,
                          );
                          // time.hour,
                          // time.minute);
                        });
                      },
                      child: Text(
                          "${selectedFromDate.year}/${selectedFromDate.month}/${selectedFromDate.day}")),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  const Text(
                    'To :',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  ElevatedButton(
                      onPressed: () async {
                        final date = await pickDate();
                        // final time = await pickTime();
                        if (date == null) return;
                        // if (time == null) return;

                        setState(() {
                          selectedTodate = date;
                          selectedTodate = DateTime(
                            selectedTodate.year,
                            selectedTodate.month,
                            selectedTodate.day,
                          );
                          // time.hour,
                          // time.minute);
                        });
                      },
                      child: Text(
                          "${selectedTodate.year}/${selectedTodate.month}/${selectedTodate.day}")),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: contact,
                decoration: InputDecoration(
                  hintText: 'Contact Number',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                controller: address,
                decoration: InputDecoration(
                  hintText: 'Stay Address or visiting place ',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            ElevatedButton(
              onPressed: () {
                upload();
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const Studentmenu()));
              },
              child: const Text('Apply Leave'),
            ),
          ],
        ),
      ),
    );
  }
}
