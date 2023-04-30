import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'login_view.dart';
import 'register_view.dart';
import 'package:chimp_game/home_page.dart';
import 'package:chimp_game/game_state_view_model.dart';

class LoginOrRegister extends StatelessWidget {
  const LoginOrRegister({Key? key, required this.autoLogin}) : super(key: key);
  final bool autoLogin;
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => GameStateViewModel(),
      child: MaterialApp(
        title: 'Chimp Game',
        routes: {
          '/login/': (context) => const LoginView(),
          '/register/': (context) => const RegisterView(),
        },
        home: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                if (autoLogin) {
                  return const MyHomePage(pageIndex: 0);
                } else {
                  return const LoginView();
                }
              default:
                return const Text('Loading...');
            }
          },
        ),
      ),
    );
  }
}
