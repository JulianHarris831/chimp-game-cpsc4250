import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/login_register_page.dart';
import 'firebase/auto_login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  bool autoLogin = false;
  if (await isAutoLogin()) {
    autoLogin = true;
  }

  runApp(LoginOrRegister(autoLogin: autoLogin));
}
