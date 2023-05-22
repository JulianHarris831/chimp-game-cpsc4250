import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:screenshot/screenshot.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:chimp_game/firebase/profile_view.dart';
import 'package:chimp_game/leaderboard/update_firestore_data.dart';
import 'game_state_view_model.dart';
import 'styles.dart';

displayErrorMsg(BuildContext context, String errorMsg) {
  Alert(
      context: context,
      type: AlertType.error,
      content: Column(
        children: [
          SizedBox(height: medium),
          Text("An error occurred!", style: bold25, textAlign: TextAlign.center),
          Text(errorMsg, style: bold25, textAlign: TextAlign.center),
        ],
      ),
      buttons: [
        DialogButton(
          onPressed: () {
            Navigator.of(context, rootNavigator: true).pop();
          },
          color: orange,
          child: Text("Try again", style: bold15),
        ),
      ]).show();
}

displaySuccessMsg(BuildContext context, String successMsg) {
  Alert(
    context: context,
    type: AlertType.success,
    title: "SUCCESS",
    desc: successMsg,
    buttons: [
      DialogButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
        },
        color: Colors.orange,
        child: Text('OK', style: bold15),
      ),
    ],
  ).show();
}

Future<Widget> checkHighscore(GameStateViewModel gameStateViewModel) async {
  User? user = FirebaseAuth.instance.currentUser;
  String uid = user!.uid;
  bool isNewHighscore =
      await updateHighscoreByID(uid, gameStateViewModel.scores);

  return Text(
    'Final Score: ${gameStateViewModel.scores}${isNewHighscore ? "\nCongratulations for new high score!" : ""}',
    style: heading3,
    textAlign: TextAlign.center,
  );
}

displayGameOver(BuildContext context, ScreenshotController controller) async {
  final gameStateViewModel = context.read<GameStateViewModel>();
  int previousHighScore = 0;
  bool isNewHighscore = false;

  if (!isGuest) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;

    CollectionReference playersCollection = FirebaseFirestore.instance.collection('Players');
    DocumentSnapshot documentSnapshot = await playersCollection.doc(uid).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    previousHighScore = data['highscore'] as int;

    isNewHighscore = await updateHighscoreByID(uid, gameStateViewModel.scores);
  }

  // ignore: use_build_context_synchronously
  Alert(
    context: context,
    style: const AlertStyle(
        isCloseButton: false,
        isOverlayTapDismiss: false,
        buttonsDirection: ButtonsDirection.column),
    content: Column(
      children: [
        Text(gameStateViewModel.level,
            style: heading2, textAlign: TextAlign.center),
        SizedBox(height: medium),
        Text(
          'Final Score: ${gameStateViewModel.scores}',
          style: heading3,
          textAlign: TextAlign.center,
        ),
        Text(
          isGuest ? '' : 'Previous High Score: $previousHighScore',
          style: heading1,
          textAlign: TextAlign.center
        ),
        SizedBox(height: small),
        Text(
          isNewHighscore ? "Congratulations for new high score!" : "",
          style: heading3,
          textAlign: TextAlign.center
        )
      ],
    ),
    buttons: [
      DialogButton(
        onPressed: () async {
          //save screenshot of game result to photo gallery (milestone 2)
          final image = await controller.capture();

          if (image == null) {
            // ignore: use_build_context_synchronously
            displayErrorMsg(context, 'Failed to save result to Gallery.');
          } else {
            // ignore: use_build_context_synchronously
            displaySuccessMsg(context, "Game Result saved to Photo Gallery!");
            await _saveImageToGallery(image);
          }
        },
        color: Colors.orange,
        child: Text('Save Result', style: bold15),
      ),
      DialogButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          gameStateViewModel.reset();
        },
        color: Colors.orange,
        child: Text('Try Again', style: bold15),
      ),
      DialogButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          context.pushReplacementNamed('leaderboard_page');
        },
        color: Colors.orange,
        child: Text('View Leaderboard', style: bold15),
      ),
      DialogButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          context.goNamed('home_page', pathParameters: {'index': 0.toString()});
        },
        color: Colors.orange,
        child: Text('Main Menu', style: bold15),
      ),
    ],
  ).show();
}

Future<String> _saveImageToGallery(Uint8List bytes) async {
  await [Permission.storage].request();

  final time = DateTime.now()
      .toIso8601String().replaceAll('.', '-').replaceAll(':', '-');
  final name = 'screenshot_$time';
  final result = await ImageGallerySaver.saveImage(bytes, name: name);

  return result['filePath'];
}