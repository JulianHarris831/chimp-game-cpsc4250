import 'package:chimp_game/alerts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserAuth {
  final FirebaseAuth auth;
  User? _user = FirebaseAuth.instance.currentUser;

  UserAuth(this.auth);

  User get user => _user ?? FirebaseAuth.instance.currentUser!;

  Future<bool> signIn(
      BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      //for last auto-login
      final FlutterSecureStorage _storage = FlutterSecureStorage();
      await _storage.write(key: 'email', value: email);
      await _storage.write(key: 'password', value: password);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_login', DateTime.now().millisecondsSinceEpoch);
      _user = FirebaseAuth.instance.currentUser;
      return true;
      //////////////////////////
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        displayErrorMsg(context, 'User not found!');
      } else if (e.code == 'wrong-password') {
        displayErrorMsg(context, 'Wrong password!');
      } else {
        displayErrorMsg(context, e.code);
      }
      return false;
    }
  }

  Future<bool> registerUser(BuildContext context, String email, String password,
      String fullName) async {
    try {
      final UserCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = FirebaseAuth.instance.currentUser;
      await user?.updateDisplayName(fullName);
      //for last auto-login
      final FlutterSecureStorage _storage = FlutterSecureStorage();
      await _storage.write(key: 'email', value: email);
      await _storage.write(key: 'password', value: password);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_login', DateTime.now().millisecondsSinceEpoch);
      _user = FirebaseAuth.instance.currentUser;
      return true;
      ////////////////////////////////////
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        displayErrorMsg(context, 'Email already in use!');
      } else if (e.code == 'weak-password') {
        displayErrorMsg(context, 'Weak password!');
      } else if (e.code == 'invalid-email') {
        displayErrorMsg(context, 'Invalid email!');
      } else {
        displayErrorMsg(context, e.code);
      }
      return false;
    }
  }

  Future signOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('last_login', -1);
    auth.signOut();
    return Future.delayed(const Duration(seconds: 1));
  }
}
