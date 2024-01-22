import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_molkky_mobile/model/user.dart';
import 'package:flutter/material.dart';

class UserRepo {
  Future<UserModel?> get(String uid) async {
    try {
      final DocumentSnapshot userSnapshot =
          await FirebaseFirestore.instance.collection('user').doc(uid).get();

      if (userSnapshot.exists) {
        return UserModel.fromFirestore(userSnapshot);
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('error: $error');
      return null;
    }
  }
}
