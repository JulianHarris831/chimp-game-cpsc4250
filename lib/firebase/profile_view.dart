import 'package:chimp_game/home_page.dart';
import 'package:chimp_game/styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chimp_game/alerts.dart';
import 'logout.dart';

final user = FirebaseAuth.instance.currentUser;
String? fullName = user?.displayName;
bool isGuest = false;

class ProfilePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(medium),
        child: SafeArea(
          child:
              isGuest ? const GuestProfile() : const FireBaseAccountProfile(),
        ),
      ),
    );
  }
}

class GuestProfile extends StatelessWidget {
  const GuestProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: large,
              width: large,
              decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(100),
                  image: const DecorationImage(
                      image: AssetImage('assets/images/profile.png'))),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Guest", style: heading2),
              ],
            ),
            SizedBox(width: xsmall),
            SizedBox(width: xsmall),
            SizedBox(width: xsmall),
            SizedBox(width: xsmall),
          ],
        ),
        Divider(height: large, color: Colors.black),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Not registered yet?", style: textButton2),
            TextButton(
              onPressed: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/register/', (route) => false);
              },
              child: Text('Click here to register!', style: textButton1),
            )
          ],
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
    );
  }
}

class FireBaseAccountProfile extends StatelessWidget {
  const FireBaseAccountProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              height: large,
              width: large,
              decoration: BoxDecoration(
                  color: black,
                  borderRadius: BorderRadius.circular(100),
                  image: const DecorationImage(
                      image: AssetImage('assets/images/profile.png'))),
            ),
            SizedBox(width: xsmall),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(fullName!, style: heading2),
                Text("uid: ${user?.uid}", style: form2),
              ],
            ),
            SizedBox(width: xsmall),
            IconButton(
              icon: Icon(Icons.settings, color: grey, size: 28),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(
                    builder: (context) => const ProfileEditPage()));
              },
            ),
          ],
        ),
        Divider(height: large, color: Colors.black),
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Email:   ${user?.email}", style: form1),
        ),
        SizedBox(height: small),
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Highest Score:   not set yet", style: form1),
        ),
        SizedBox(height: small),
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Region:   Washington, USA", style: form1),
        ),
        SizedBox(height: small),
        Container(
          alignment: Alignment.centerLeft,
          child: Text("Leaderboard Rank:   not set yet", style: form1),
        ),
        SizedBox(height: small),
        const Logout()
      ],
    );
  }
}

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({super.key});
  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController _newNickName = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    _newNickName = TextEditingController(text: user!.displayName);
  }

  @override
  void dispose() {
    _newNickName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile Name', style: heading2)),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(medium),
          child: Column(children: [
            TextField(
              maxLength: 12,
              style: form1,
              controller: _newNickName,
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.name,
              decoration:
                  InputDecoration(hintText: 'New First Name', hintStyle: hint1),
            ),
            TextButton(
              child: Text('Save', style: textButton1),
              onPressed: () async {
                if (_newNickName == null || _newNickName.text.isEmpty) {
                  displayErrorMsg(context, "Nickname cannot be empty!");
                } else {
                  setState(() {
                    fullName = _newNickName.text;
                  });
                  await user?.updateDisplayName(_newNickName.text);

                  Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) => const MyHomePage(pageIndex: 2)),
                  );
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}
