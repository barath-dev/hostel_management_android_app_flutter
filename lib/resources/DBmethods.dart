// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:uuid/uuid.dart';

class DBmethods {
  Future<String> addHostel({
    required String hostelName,
    required String numberOfFloors,
    required String hostelId,
  }) async {
    var list = [];
    for (int i = 1; i <= int.parse(numberOfFloors); i++) {
      for (int j = 1; j <= 10; j++) {
        var list1 = {
          'room no': '${i}0$j',
          'floor no': i,
          'student list': [],
          'available beds': 4,
        };
        list.add(list1);
      }
    }
    try {
      String hId = const Uuid().v4();
      FirebaseFirestore.instance.collection('hostels').doc(hId).set({
        'name': hostelName,
        'numberOfFloors': numberOfFloors,
        'hostelId': hostelId,
        'hId': hId,
        'student count': 0,
        'student List': [],
        'available rooms': list,
        'query list': [],
      });
    } catch (e) {
      return e.toString();
    }
    return 'Hostel Added';
  }

  Future<String> createStudent({
    required String studentName,
    required String studentEmail,
    required String studentDepartment,
    required String password,
  }) async {
    try {
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: studentEmail, password: password);
      String uid = cred.user!.uid;

      FirebaseFirestore.instance.collection('students').doc(uid).set({
        'name': studentName,
        'email': studentEmail,
        'sid': uid,
        'department': studentDepartment,
        'hid': '',
        'room no': '',
        'floor no': '',
        'query list': [],
        'pending leave pass': [],
        'history leave pass': [],
      });
    } catch (e) {
      return e.toString();
    }
    return 'Student  Created';
  }

  Future<String> createWarden(
      {required String wardensName,
      required String wardensEmail,
      required String age,
      required String password,
      required String hId}) async {
    try {
      if (!wardensEmail.contains("warden")) {
        return "Email should contain @warden";
      }
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: wardensEmail, password: password);
      String uid = cred.user!.uid;

      await FirebaseAuth.instance.signOut();

      FirebaseAuth.instance.signInWithEmailAndPassword(
          email: 'admin@hostelease', password: 'Admin@123');

      FirebaseFirestore.instance.collection('hostels').doc(hId).update({
        'warden name': wardensName,
        'warden email': wardensEmail,
        'warden age': age,
        'wid': uid
      });
    } catch (e) {
      return e.toString();
    }
    return 'Warden Added';
  }

  Future<List<String>> getHostels() async {
    try {
      //get the name of each hostel and append it to the list
      List<String> hostelList = [];
      FirebaseFirestore.instance.collection('hostels').get().then((value) {
        for (var element in value.docs) {
          hostelList.add(element['name']);
        }
      });
      return hostelList;
    } catch (e) {
      return ['error in getting hostels'];
    }
  }

  Future<String> addQuery({
    required String query,
    required String hid,
    required String title,
  }) async {
    String qid = const Uuid().v4();
    try {
      FirebaseFirestore.instance.collection('queries').doc(qid).set({
        'title': title,
        'query': query,
        'hid': hid,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'student email': FirebaseAuth.instance.currentUser!.email,
      });
      FirebaseFirestore.instance
          .collection('students')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'query list': FieldValue.arrayUnion([qid]),
      });
      FirebaseFirestore.instance.collection('hostels').doc(hid).update({
        'query list': FieldValue.arrayUnion([qid])
      });
    } catch (e) {
      return e.toString();
    }
    return 'Query Added';
  }

  Future<String> applyLeavePass({
    required String reason,
    required String Fromdate,
    required String Todate,
    required String contact,
    required String address,
  }) async {
    String lid = const Uuid().v4();
    try {
      String hid = await getHid();
      FirebaseFirestore.instance.collection('leavePass').doc(lid).set({
        'reason': reason,
        'hid': hid,
        'contact': contact,
        'address': address,
        'uid': FirebaseAuth.instance.currentUser!.uid,
        'student email': FirebaseAuth.instance.currentUser!.email,
        'from date': Fromdate,
        'to date': Todate,
        'status': 'pending'
      });
      FirebaseFirestore.instance
          .collection('students')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'pending leave pass': FieldValue.arrayUnion([lid]),
      });
      FirebaseFirestore.instance.collection('hostels').doc(hid).update({
        'pending leave pass': FieldValue.arrayUnion([lid])
      });
      FirebaseFirestore.instance
          .collection('students')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        'history leave pass': FieldValue.arrayUnion([lid])
      });
    } catch (e) {
      return e.toString();
    }
    return 'Leave Pass Applied';
  }

  Future<String> getHid() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String hid = '';
      await FirebaseFirestore.instance
          .collection('students')
          .doc(uid)
          .get()
          .then((value) {
        hid = value['hid'];
      });
      return hid;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> getWardenHid() async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;
      String hid = '';
      await FirebaseFirestore.instance
          .collection('hostels')
          .doc(uid)
          .get()
          .then((value) {
        hid = value['hid'];
      });
      return hid;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> getLeavePassdetails({required String lid}) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('leavePass')
          .doc(lid)
          .get();
      return doc;
    } catch (e) {
      return e.toString();
    }
  }

  Future<dynamic> getStudentDetails({required String uid}) async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('students')
          .doc(uid)
          .get();
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      return "404$e";
    }
  }
}
