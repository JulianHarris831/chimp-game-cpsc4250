import 'package:chimp_game/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chimp_game/home_page.dart';
import 'package:chimp_game/providers.dart';

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
                  try {
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: password);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(pageIndex: 0)));
                  } on FirebaseAuthException catch (e) {
                    temp = e.code;
                    if (temp == 'user-not-found') {
                      displayErrorMsg(context, 'User not found!');
                    } else if (e.code == 'wrong-password') {
                      displayErrorMsg(context, 'Wrong password!');
                    } else {
                      displayErrorMsg(context, e.code);
                    }
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
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          '/register/', (route) => false);
                    },
                    child: Text('Click here to register!', style: textButton1),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
