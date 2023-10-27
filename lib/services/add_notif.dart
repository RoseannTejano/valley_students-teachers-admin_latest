import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

Future addNotif(name, type) async {
  final docUser = FirebaseFirestore.instance.collection('Notif').doc();

  final json = {
    'name': name,
    'type': type,
    'userId': FirebaseAuth.instance.currentUser!.uid,
    'dateTime': DateTime.now(),
  };

  await docUser.set(json);
}
