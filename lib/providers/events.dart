import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Events extends ChangeNotifier {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> rdvdemande(String email, String userid,String action) async {
    await FirebaseFirestore.instance.collection("rdvdemande").add({
      'email': email,
      'uid': userid,
      'action': action,
      'date': DateTime.now(),
    });
  }
  }