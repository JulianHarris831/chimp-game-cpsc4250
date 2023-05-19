import 'package:chimp_game/firebase/user_auth.dart';
import 'package:chimp_game/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chimp_game/alerts.dart';
import 'package:go_router/go_router.dart';
import 'profile_view.dart';

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
  final UserAuth _userAuth = UserAuth(FirebaseAuth.instance);
  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('Players');

  void addUserWithCustomID(String id, String nickname, String email,
      String password, int highscore) {
    playersCollection.doc(id).set({
      'nickname': nickname,
      'email': email,
      'password': password,
      'highscore': highscore,
    }).then((value) {
      print('User added successfully!');
    }).catchError((error) {
      print('Failed to add user: $error');
    });
  }

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
      body: SingleChildScrollView(
        child: SafeArea(
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
                      String nickName = _nickName.text;

                      bool registered = await _userAuth.registerUser(
                          context, email, password, nickName);

                      if (registered) {
                        setState(() {
                          isGuest = false;
                        });

                        const Duration(seconds: 1);
                        User? user = FirebaseAuth.instance.currentUser;

                        addUserWithCustomID(
                            user!.uid, nickName, email, password, 0);

                        int i = 0;
                        context.pushReplacementNamed("home_page",
                            pathParameters: {'index': i.toString()});
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
                        context.pushReplacementNamed("login_view");
                      },
                      child: Text('Click here to login!', style: textButton1),
                    )
                  ],
                ),
                SizedBox(height: large),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      isGuest = true;
                    });
                    int i = 0;
                    context.pushReplacementNamed("home_page",
                        pathParameters: {'index': i.toString()});
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
      ),
    );
  }
}
