import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'profile_view.dart';
import 'package:chimp_game/main.dart';

String? getDisplayName() {
  User? user = FirebaseAuth.instance.currentUser;
  return user?.displayName;
}

void printError(bool registered) {
  if (!registered) {
    Text('please try again!');
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  late final TextEditingController _email;
  late final TextEditingController _password;
  late final TextEditingController _firstName;
  late final TextEditingController _lastName;
  String? temp = null;
  String? name = null;
  bool registered = true;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    _firstName = TextEditingController();
    _lastName = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _firstName.dispose();
    _lastName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register'), backgroundColor: Colors.orange),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: ListView(
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
              Divider(
                height: 45,
                color: Colors.transparent,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Profile Information: ',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              Divider(
                height: 15,
                color: Colors.transparent,
              ),
              TextField(
                controller: _firstName,
                enableSuggestions: false,
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(hintText: 'First Name'),
              ),
              TextField(
                controller: _lastName,
                enableSuggestions: false,
                autocorrect: false,
                decoration: const InputDecoration(hintText: 'Last Name'),
              ),
              Divider(
                height: 10,
                color: Colors.transparent,
              ),
              if (temp != null)
                Text(
                  temp!,
                  style: TextStyle(color: Colors.red),
                ),
              Divider(
                height: 20,
                color: Colors.transparent,
              ),
              TextButton(
                onPressed: () async {
                  setState(() {
                    temp = null;
                  });
                  final email = _email.text;
                  final password = _password.text;

                  try {
                    final UserCredential = await FirebaseAuth.instance
                        .createUserWithEmailAndPassword(
                            email: email, password: password);

                    print("registered as: " + email);

                    String firstName = _firstName.text;
                    String lastName = _lastName.text;
                    String fullName = '$firstName $lastName';
                    print(fullName);

                    final user = FirebaseAuth.instance.currentUser;
                    await user?.updateDisplayName(fullName);

                    print(UserCredential);

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MyHomePage(pageIndex: 0)));
                  } on FirebaseAuthException catch (e) {
                    setState(() {
                      temp = e.code;
                    });
                    if (temp == 'email-already-in-use') {
                      print('Email already in use!');
                    } else if (temp == 'weak-password') {
                      print('Weak password!');
                    } else if (temp == 'invalid-email') {
                      print('Invalid email!');
                    } else {
                      print('An error occurred!');
                      print(e.code);
                    }
                    print("please try again!");
                  }
                },
                child: const Text('Register'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/login/', (route) => false);
                },
                child:
                    const Text('Already have an account? Click here to login!'),
              )
            ],
          ),
        ),
      ),
    );
  }
}
