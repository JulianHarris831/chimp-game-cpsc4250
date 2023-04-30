import 'package:chimp_game/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login_register_page.dart';

class Logout extends StatelessWidget {
  const Logout({super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await FirebaseAuth.instance.signOut();
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setInt('last_login', -1);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => LoginOrRegister(autoLogin: false)));
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      child: Text('Logout', style: form1),
    );
  }
}
