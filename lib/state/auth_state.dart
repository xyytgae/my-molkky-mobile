import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:my_molkky_mobile/model/user.dart';
import 'package:flutter/services.dart';
import 'package:my_molkky_mobile/service/user.dart';

class AuthState {
  UserModel? loginedUser;
  UserRepo userRepo = UserRepo();
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> googleLogin() async {
    debugPrint('--------googleLogin--------');
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
    } on PlatformException catch (error) {
      debugPrint('--PlatformException--');
      debugPrint('error: $error');
    } on Exception catch (error) {
      debugPrint('--Exception--');
      debugPrint('error: $error');
    } catch (error) {
      debugPrint('--catch--');
      debugPrint('error: $error');
    }
  }

  Future<void> logout() async {
    debugPrint('--------logout--------');
    try {
      await _googleSignIn.signOut();
      await FirebaseAuth.instance.signOut();
      loginedUser = null;
    } on PlatformException catch (error) {
      debugPrint('--PlatformException--');
      debugPrint('error: $error');
    } on Exception catch (error) {
      debugPrint('--Exception--');
      debugPrint('error: $error');
    } catch (error) {
      debugPrint('--catch--');
      debugPrint('error: $error');
    }
  }
}
