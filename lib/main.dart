import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase/login_register_page.dart';
import 'firebase/auto_login.dart';
/* FOR TESTING WITHOUT FIREBASE, IMPORT THIS STUFF
import 'package:provider/provider.dart';
import 'main_menu_page.dart';
import 'game_state_view_model.dart';
 */

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  bool autoLogin = false;
  if (await isAutoLogin()) {
    autoLogin = true;
  }

  runApp(LoginOrRegister(autoLogin: autoLogin));
}

/* FOR TESTING WITHOUT FIREBASE, USE THIS MYAPP
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameStateViewModel(),
      child: MaterialApp(
        title: 'Chimp Game',
        home: const MainMenuPage(),
      ),
    );
  }
}
 */
