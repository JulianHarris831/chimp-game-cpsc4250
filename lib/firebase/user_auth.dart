import 'dart:io';
import 'package:chimp_game/alerts.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class UserAuth {
  final FirebaseAuth auth;
  User? _user;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;
  final ImagePicker _imagePicker = ImagePicker();
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  UserAuth(this.auth);

  //User get user => _user ?? FirebaseAuth.instance.currentUser!;

  Future<bool> signIn(
      BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      //for last auto-login
      await _secureStorage.write(key: 'email', value: email);
      await _secureStorage.write(key: 'password', value: password);
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

      _user = FirebaseAuth.instance.currentUser;
      await _user?.updateDisplayName(fullName);
      //for last auto-login
      await _secureStorage.write(key: 'email', value: email);
      await _secureStorage.write(key: 'password', value: password);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('last_login', DateTime.now().millisecondsSinceEpoch);
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

  Future<void> saveProfilePicture(
      CroppedFile croppedFile, BuildContext context) async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user == null) {
      return;
    }

    final String fileName = "${_user!.uid}_profile_picture";

    try {
      await _firebaseStorage
          .ref('profile_pictures/$fileName')
          .putFile(File(croppedFile.path));

      final String downloadURL = await _firebaseStorage
          .ref('profile_pictures/$fileName')
          .getDownloadURL();
      await _user!.updatePhotoURL(downloadURL);

      await _user!.reload();
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Image updated successfully')),
      );
    } catch (e) {
      print('Error saving profile picture: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving profile picture: $e')),
      );
    }
  }

  Future<String> retrieveProfilePicture() async {
    _user = FirebaseAuth.instance.currentUser;
    if (_user == null) {
      return " ";
    }

    try {
      final String? photoURL = _user!.photoURL;

      if (photoURL != null) {
        final Reference reference = _firebaseStorage.refFromURL(photoURL);
        final String downloadURL = await reference.getDownloadURL();
        return downloadURL;
      } else {
        print('No profile picture available');
        return " ";
      }
    } catch (e) {
      print('Error retrieving profile picture: $e');
      return " ";
    }
  }
}
