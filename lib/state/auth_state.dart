import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_molkky_mobile/model/user.dart';
import 'package:my_molkky_mobile/service/user.dart';

class AuthState {
  User? user;
  UserModel? loginedUser;
  UserRepo userRepo = UserRepo();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  void googleLogin() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        throw Exception('Google login cancelled by user');
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      final user =
          (await FirebaseAuth.instance.signInWithCredential(credential)).user;
      loginedUser = await userRepo.get(user!.uid);
    } catch (error) {
      debugPrint('error: $error');
    }
  }
}
