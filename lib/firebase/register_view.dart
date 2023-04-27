import 'package:chimp_game/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chimp_game/home_page.dart';
import 'package:chimp_game/providers.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

//FORM WIDGET, MORE THAN 100 LINES ALLOWED
class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _nickName;
  String? temp;
  String? name;
  bool registered = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _nickName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _nickName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'Register',
            style: heading3,
          ),
          backgroundColor: orange),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(medium),
          child: ListView(
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
              SizedBox(height: large),
              Container(
                alignment: Alignment.centerLeft,
                child: Text('Profile Information: ', style: heading2),
              ),
              SizedBox(height: xsmall),
              TextField(
                style: form1,
                controller: _nickName,
                maxLength: 12,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.name,
                decoration:
                    InputDecoration(hintText: 'Nickname', hintStyle: hint1),
              ),
              SizedBox(height: small),
              TextButton(
                onPressed: () async {
                  if (_nickName == null || _nickName.text.isEmpty) {
                    displayErrorMsg(context, "Nickname cannot be empty!");
                  } else {
                    setState(() {
                      temp = null;
                    });
                    final email = _email.text;
                    final password = _password.text;

                    try {
                      final UserCredential = await FirebaseAuth.instance
                          .createUserWithEmailAndPassword(
                              email: email, password: password);
                      String fullName = _nickName.text;

                      final user = FirebaseAuth.instance.currentUser;
                      await user?.updateDisplayName(fullName);

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MyHomePage(pageIndex: 0)));
                    } on FirebaseAuthException catch (e) {
                      setState(() {
                        temp = e.code;
                      });
                      if (temp == 'email-already-in-use') {
                        displayErrorMsg(context, 'Email already in use!');
                      } else if (temp == 'weak-password') {
                        displayErrorMsg(context, 'Weak password!');
                      } else if (temp == 'invalid-email') {
                        displayErrorMsg(context, 'Invalid email!');
                      } else {
                        displayErrorMsg(context, e.code);
                      }
                    }
                  }
                },
                child: Text('Register', style: textButton1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have an account?", style: textButton2),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamedAndRemoveUntil('/login/', (route) => false);
                    },
                    child: Text('Click here to login!', style: textButton1),
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
