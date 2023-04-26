import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'profile_view.dart';
import 'package:chimp_game/main.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  String? temp = null;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        // User is not signed in
        setState(() {
          _user = null;
        });
      } else {
        // User is signed in
        setState(() {
          _user = user;
        });
      }
    });
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
      appBar: AppBar(title: Text('Login'), backgroundColor: Colors.orange),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              TextField(
                controller: _email,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration:
                    const InputDecoration(hintText: 'Enter your email here!'),
              ),
              TextField(
                controller: _password,
                obscureText: true,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(
                    hintText: 'Enter your password here!'),
              ),
              TextButton(
                onPressed: () async {
                  temp = null;
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    final userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email, password: password);
                    print(userCredential);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(pageIndex: 0)));
                  } on FirebaseAuthException catch (e) {
                    temp = e.code;
                    if (temp == 'user-not-found') {
                      print('User not found!');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password!');
                    } else {
                      print('An error occurred!');
                      print(e.code);
                    }
                  }

                  if (temp != null) {
                    // User is not signed in
                    print("please try again!");
                  } else {
                    // User is signed in
                    print("logged in as: " + email);
                  }
                },
                child: const Text('Login'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/register/', (route) => false);
                },
                child:
                    const Text('Not registered yet? Click here to register!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
