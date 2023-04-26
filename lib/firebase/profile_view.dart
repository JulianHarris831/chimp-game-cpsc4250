import 'package:chimp_game/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final user = FirebaseAuth.instance.currentUser;
String? fullName = user?.displayName;

class ProfilePage extends StatelessWidget {
  final user = FirebaseAuth.instance.currentUser;
  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(30),
        child: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 50,
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(100),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/profile.png'))),
                  ),
                  const SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(fullName!,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.bold)),
                      Text("uid: ${user?.uid}",
                          style: const TextStyle(
                              fontSize: 10, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(width: 30),
                  IconButton(
                    icon: const Icon(Icons.settings,
                        color: Colors.grey, size: 28),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfileEditPage()));
                    },
                  ),
                ],
              ),
              const Divider(
                height: 50,
                color: Colors.black,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Email:   ${user?.email}",
                  style: const TextStyle(fontSize: 15),
                ),
              ),
              const Divider(
                height: 15,
                color: Colors.transparent,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Highest Score:   not set yet",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Divider(
                height: 15,
                color: Colors.transparent,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Region:   Washington, USA",
                  style: TextStyle(fontSize: 15),
                ),
              ),
              const Divider(
                height: 15,
                color: Colors.transparent,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Leaderboard Rank:   not set yet",
                  style: TextStyle(fontSize: 15),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileEditPage extends StatefulWidget {
  final user = FirebaseAuth.instance.currentUser;
  ProfileEditPage({super.key});
  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  String? name = user!.displayName;
  List<String> fullname = [];
  TextEditingController _newFirstName = TextEditingController();
  TextEditingController _newLastName = TextEditingController();

  @override
  void initState() {
    super.initState();
    List<String> fullname = name!.split(" ");
    _newFirstName = TextEditingController(text: fullname[0]);
    _newLastName = TextEditingController(text: fullname[1]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Edit Profile Name')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(children: [
            Divider(
              height: 50,
              color: Colors.transparent,
            ),
            TextField(
              //text field/box for user to enter
              controller: _newFirstName, //store email
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress, //keyboard type with @
              decoration: //hint text
                  const InputDecoration(hintText: 'New First Name'),
            ), //make text field for user to fill
            TextField(
              //text field/box for user to enter
              controller: _newLastName, //store email
              enableSuggestions: false,
              autocorrect: false,
              keyboardType: TextInputType.emailAddress, //keyboard type with @
              decoration: //hint text
                  const InputDecoration(hintText: 'New Last Name'),
            ), //make text field for user to fill
            TextButton(
              child: Text('Save'),
              onPressed: () async {
                String firstName = _newFirstName.text;
                String lastName = _newLastName.text;
                setState(() {
                  fullName = '$firstName $lastName';
                });

                print(fullName);
                await user?.updateDisplayName(fullName);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MyHomePage(pageIndex: 2)),
                );
              },
            )
          ]),
        ),
      ),
    );
  }
}
