import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/login_register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const LoginOrRegister());
}
