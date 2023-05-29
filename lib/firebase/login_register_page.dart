import 'package:chimp_game/difficulty_page.dart';
import 'package:chimp_game/firebase/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import '../main.dart';
import '../styles.dart';
import 'firebase_options.dart';
import 'login_view.dart';
import 'register_view.dart';
import 'package:chimp_game/home_page.dart';
import 'package:chimp_game/game_page.dart';
import 'package:chimp_game/game_state_view_model.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(initialLocation: "/login_or_register", routes: [
  GoRoute(
    path: "/login_or_register",
    name: "login_or_register",
    builder: (context, state) => LoginOrRegister(autoLogin: autoLogin),
  ),
  GoRoute(
    path: "/login_view",
    name: "login_view",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
          transitionDuration: Duration(seconds: 2),
          child: const LoginView(),
          transitionsBuilder: ((context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity:
                  CurveTween(curve: Curves.easeInOutCirc).animate(animation),
              child: child,
            );
          }));
    },
  ),
  GoRoute(
    path: "/register_view",
    name: "register_view",
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        transitionDuration: Duration(seconds: 1),
        child: const RegisterView(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween =
              Tween<Offset>(begin: const Offset(1.0, 0.0), end: Offset.zero);
          var curveTween = CurveTween(curve: Curves.ease);

          return SlideTransition(
            position: animation.drive(curveTween).drive(tween),
            child: child,
          );
        },
      );
    },
  ),
  GoRoute(
    path: "/home_page/:index",
    name: "home_page",
    builder: (context, state) {
      final index = int.parse(state.pathParameters['index']!);
      return MyHomePage(pageIndex: index);
    },
  ),
  GoRoute(
    path: "/leaderboard_page",
    name: "leaderboard_page",
    builder: (context, state) => const MyHomePage(pageIndex: 1),
  ),
  GoRoute(
    path: "/difficulty_page",
    name: "difficulty_page",
    builder: (context, state) => const DifficultyPage(),
  ),
  // GoRoute(
  //   path: "/profile_edit",
  //   name: "profile_edit",
  //   builder: (context, state) => const ProfileEditPage(),
  // ),
  GoRoute(
    path: "/game_page",
    name: "game_page",
    builder: (context, state) => const GamePage(),
  )
]);

class ChimpGame extends StatelessWidget {
  const ChimpGame({super.key, required this.autoLogin});
  final bool autoLogin;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (context) => GameStateViewModel(),
          ),
        ],
        child: MaterialApp.router(
          title: 'Chimp Game',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: orange,
          ),
          routerConfig: router,
        ));
  }
}

class LoginOrRegister extends StatelessWidget {
  const LoginOrRegister({Key? key, required this.autoLogin}) : super(key: key);
  final bool autoLogin;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
    );
  }
}
