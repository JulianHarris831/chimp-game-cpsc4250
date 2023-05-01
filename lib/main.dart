import 'package:chimp_game/game_state_view_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase/login_register_page.dart';
import 'firebase/auto_login.dart';
import 'main_menu_page.dart';

void main() async {
  /*
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  bool autoLogin = false;
  if (await isAutoLogin()) {
    autoLogin = true;
  }

   */

  runApp(const MyApp());
}

///* //FOR TESTING WITHOUT FIREBASE, USE THIS MYAPP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameStateViewModel(),
      child: MaterialApp(
        home: const MainMenuPage()
      ),
    );
  }
}
 //*/
