import 'package:chimp_game/firebase/register_view.dart';
import 'package:chimp_game/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/animation.dart';
import 'profile_view.dart';
import 'user_auth.dart';

class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder:
              (_, Animation<double> animation, __, Widget child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            );
          },
        );
}

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
  final UserAuth _userAuth = UserAuth();

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
          title: Text('Welcome!', style: heading3), backgroundColor: orange),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(medium),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  child: Text('Login:', style: heading3),
                ),
                SizedBox(height: small),
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
                    Text("Don't have an account?", style: textButton2),
                    TextButton(
                      onPressed: () {
                        context.pushNamed("register_view");
                        // Navigator.of(context)
                        //     .push(SlidePageRoute(page: RegisterView()));
                      },
                      child:
                          Text('Click here to register!', style: textButton1),
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
