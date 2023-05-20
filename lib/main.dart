import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/login_register_page.dart';
import 'firebase/auto_login.dart';

//FOR TESTING WITHOUT FIREBASE, IMPORT THIS STUFF
import 'package:provider/provider.dart';
import 'main_menu_page.dart';
import 'game_state_view_model.dart';

bool autoLogin = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  if (await isAutoLogin()) {
    autoLogin = true;
  }
  runApp(ChimpGame(autoLogin: autoLogin));

  //runApp(const MyApp());
}
