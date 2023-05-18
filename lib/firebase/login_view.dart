import 'package:chimp_game/main.dart';
import 'package:chimp_game/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chimp_game/home_page.dart';
import 'package:chimp_game/alerts.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'profile_view.dart';
import 'user_auth.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

//FORM WIDGET, MORE THAN 100 LINES ALLOWED
class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  String? temp;
  final UserAuth _userAuth = UserAuth(FirebaseAuth.instance);

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Login', style: heading3), backgroundColor: orange),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(medium),
          child: Column(
            children: [
              TextField(
                //key: Key("EmailField"),
                style: form1,
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                    hintText: 'Enter your email here!', hintStyle: hint1),
              ),
              TextField(
                style: form1,
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: InputDecoration(
                    hintText: 'Enter your password here!', hintStyle: hint1),
              ),
              SizedBox(height: small),
              TextButton(
                onPressed: () async {
                  temp = null;
                  final email = _email.text;
                  final password = _password.text;

                  bool loggedIn =
                      await _userAuth.signIn(context, email, password);

                  const Duration(seconds: 2);

                  if (loggedIn) {
                    setState(() {
                      isGuest = false;
                    });
                    //context.pushReplacementNamed("home_page");
                    int i = 0;
                    context.pushReplacementNamed("home_page",
                        pathParameters: {'index': i.toString()});
                  }
                },
                child: Text('Login', style: textButton1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Not registered yet?", style: textButton2),
                  TextButton(
                    onPressed: () {
                      context.pushReplacementNamed("register_view");
                    },
                    child: Text('Click here to register!', style: textButton1),
                  )
                ],
              ),
              SizedBox(height: large),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isGuest = true;
                  });
                  context.pushReplacementNamed("home_page");
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(orange),
                ),
                child: Text('Continue as Guest', style: form1),
              )
            ],
          ),
        ),
      ),
    );
  }
}
