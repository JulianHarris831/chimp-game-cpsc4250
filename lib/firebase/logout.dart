import 'package:chimp_game/firebase/user_auth.dart';
import 'package:chimp_game/main.dart';
import 'package:chimp_game/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_register_page.dart';

class Logout extends StatelessWidget {
  Logout({super.key, required this.userAuth});

  final UserAuth userAuth;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        autoLogin = false;
        await userAuth.signOut();
        context.pushReplacementNamed("login_or_register");
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text('Logout', style: form1),
    );
  }
}
