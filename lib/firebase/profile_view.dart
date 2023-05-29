import 'package:chimp_game/firebase/user_auth.dart';
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
  final ImageHelper imageHelper = ImageHelper();

  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('Players');
  late DocumentReference playerDocRef;
  final UserAuth _userAuth = UserAuth();
  String profilePictureUrl =
      'https://firebasestorage.googleapis.com/v0/b/cpsc4250-game.appspot.com/o/profile_pictures%2Fprofile.png?alt=media&token=c8495e34-f82f-4fa6-a6b1-7b1f3f16a501';

  Future<void> retrieveProfilePicture() async {
    String url = await _userAuth.retrieveProfilePicture();
    if (url != " ") {
      setState(() {
        profilePictureUrl = url;
      });
    }
  }

  void refreshPage() {
    setState(() {});
  }

  @override
  void initState() {
    retrieveProfilePicture();
    super.initState();
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
                  Container(
                    height: large,
                    width: large,
                    decoration: BoxDecoration(
                        color: black,
                        borderRadius: BorderRadius.circular(100),
                        image: DecorationImage(
                            image: NetworkImage(profilePictureUrl),
                            fit: BoxFit.cover)),
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfileEditPage(
                            userAuth: _userAuth,
                            user: widget.user,
                            retrieveProfilePicture: retrieveProfilePicture,
                          ),
                        ),
                      );
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
              SizedBox(height: large),
              Logout(),
              SizedBox(height: small),
              //RefreshProfilePage(refreshPage: refreshPage)
            ],
          );
        }
      },
    );
  }
}

class ProfileEditPage extends StatefulWidget {
  ProfileEditPage(
      {super.key,
      required this.userAuth,
      required this.user,
      required this.retrieveProfilePicture});
  UserAuth userAuth;
  User user;
  Function retrieveProfilePicture;
  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  TextEditingController _newNickName = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;
  final ImageHelper imageHelper = ImageHelper();

  _cropImage(XFile? file) async {
    if (file != null) {
      final CroppedFile? croppedFile = await imageHelper.crop(
        file: file,
        cropStyle: CropStyle.circle,
      );
      if (croppedFile != null) {
        // ignore: use_build_context_synchronously
        await widget.userAuth.saveProfilePicture(croppedFile, context);
        widget.retrieveProfilePicture();
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No image was selected')),
      );
    }
  }

  void showPicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
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
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                      await _cropImage(file);
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: Text('Take a Picture using Camera', style: heading2),
                    onTap: () async {
                      final file = await imageHelper.pickImage(
                          source: ImageSource.camera);
                      // ignore: use_build_context_synchronously
                      Navigator.of(context).pop();
                      await _cropImage(file);
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

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
      appBar: AppBar(title: Text('Edit Profile', style: heading2)),
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
                  InputDecoration(hintText: 'New Nickname', hintStyle: hint1),
            ),
            TextButton(
              child: Text('Save nickname', style: textButton1),
              onPressed: () async {
                if (_newNickName == null || _newNickName.text.isEmpty) {
                  displayErrorMsg(context, "Nickname cannot be empty!");
                } else {
                  await user!.updateDisplayName(_newNickName.text);
                  updateNicknameByID(user!.uid, _newNickName.text);
                  // ignore: use_build_context_synchronously
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Nickname updated successfully')),
                  );
                }
              },
            ),
            SizedBox(height: large),
            ElevatedButton(
              onPressed: () => showPicker(context),
              style: ElevatedButton.styleFrom(
                  backgroundColor: blue // Set the background color to blue
                  ),
              child: const Text('Change Profile Picture'),
            ),
            SizedBox(height: large),
            ElevatedButton(
              onPressed: () => context.pushReplacementNamed("home_page",
                  pathParameters: {'index': 2.toString()}),
              child: const Text("Back to profile page"),
            )
          ]),
        ),
      ),
    );
  }
}
