import 'dart:io';

import 'package:chimp_game/image_helper.dart';
import 'package:chimp_game/leaderboard/update_firestore_data.dart';
import 'package:chimp_game/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chimp_game/alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'logout.dart';

bool isGuest = false;
final imageHelper = ImageHelper();

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(medium),
        child: SafeArea(
          child: isGuest
              ? const GuestProfile()
              : FireBaseAccountProfile(user: user!),
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
                context.pushReplacementNamed("register_view");
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
                context.pushReplacementNamed("login_view");
              },
              child: Text('Click here to login!', style: textButton1),
            )
          ],
        )
      ],
    );
  }
}

class FireBaseAccountProfile extends StatefulWidget {
  FireBaseAccountProfile({super.key, required this.user});
  User user;

  @override
  State<FireBaseAccountProfile> createState() => _FireBaseAccountProfileState();
}

class _FireBaseAccountProfileState extends State<FireBaseAccountProfile> {
  File? _profileImage;

  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('Players');
  late DocumentReference playerDocRef;

  Future<int?> getPlayerHighscore(String playerId) async {
    try {
      DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
          .collection('Players')
          .doc(playerId)
          .get();

      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      int? highscore = data['highscore'] as int?;
      return highscore;
    } catch (error) {
      print('Error retrieving player highscore: $error');
      return null;
    }
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(context: context, builder: (BuildContext buildContext) {
      return SafeArea(
        child: SizedBox(
          height: 150,
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text('Choose from Photo Gallery', style: heading2),
                onTap: () async {
                  final file = await imageHelper.pickImage();
                  await _cropImage(file);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera),
                title: Text('Take a Picture using Camera', style: heading2),
                onTap: () async {
                  final file = await imageHelper.pickImage(source: ImageSource.camera);
                  await _cropImage(file);
                  // ignore: use_build_context_synchronously
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      );
    });
  }

  _cropImage(XFile? file) async {
    if (file != null) {
      final croppedFile = await imageHelper.crop(
        file: file,
        cropStyle: CropStyle.circle,
      );
      if (croppedFile != null) {
        setState(() => _profileImage = File(croppedFile.path));
      }
    }
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    playerDocRef = playersCollection.doc(widget.user.uid);
    return StreamBuilder<DocumentSnapshot>(
      stream: playerDocRef.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading data: ${snapshot.error}');
        } else {
          Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
          int highscore = data['highscore'] as int;

          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*Container(
                    height: large,
                    width: large,
                    decoration: BoxDecoration(
                        color: black,
                        borderRadius: BorderRadius.circular(100),
                        image: const DecorationImage(
                            image: AssetImage('assets/images/profile.png'))),
                  ),*/
                  Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: CircleAvatar(
                        backgroundColor: Colors.grey[300],
                        radius: 28,
                        foregroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                        child: Icon(Icons.person_rounded, size: large),
                      ),
                    ),
                  ),
                  SizedBox(width: xsmall),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.user.displayName!, style: heading2),
                      Text("uid: ${widget.user.uid}", style: form3),
                    ],
                  ),
                  SizedBox(width: xsmall),
                  IconButton(
                    icon: Icon(Icons.settings, color: grey, size: 28),
                    onPressed: () {
                      context.pushNamed("profile_edit");
                    },
                  ),
                ],
              ),
              Divider(height: large, color: Colors.black),
              Container(
                alignment: Alignment.centerLeft,
                child: Text("Email:   ${widget.user.email}", style: form1),
              ),
              SizedBox(height: small),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Highest Score: $highscore",
                  style: form1,
                ),
              ),
              SizedBox(height: small),
              Container(
                alignment: Alignment.centerLeft,
                child: Text("Region:   Washington, USA", style: form1),
              ),
              SizedBox(height: small),
              ElevatedButton(
                onPressed: () => showPicker(context),
                child: const Text('Change Profile Picture'),
              ),
              SizedBox(height: small),
              Logout(),
              SizedBox(height: small),
              RefreshProfilePage(refreshPage: refreshPage)
            ],
          );
        }
      },
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
                  await user!.updateDisplayName(_newNickName.text);
                  updateNicknameByID(user!.uid, _newNickName.text);
                  int i = 2;
                  context.pushReplacementNamed("home_page",
                      pathParameters: {'index': i.toString()});
                }
              },
            )
          ]),
        ),
      ),
    );
  }
}

class RefreshProfilePage extends StatelessWidget {
  RefreshProfilePage({super.key, required this.refreshPage});
  Function refreshPage;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {},
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("Name not updated?", style: textButton2),
          TextButton(
            onPressed: () => refreshPage,
            child: Text('Click here to refresh!', style: textButton1),
          )
        ],
      ),
    );
  }
}
