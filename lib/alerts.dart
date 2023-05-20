import 'package:chimp_game/firebase/profile_view.dart';
import 'package:chimp_game/leaderboard/update_firestore_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:provider/provider.dart';
import 'home_page.dart';
import 'game_state_view_model.dart';
import 'styles.dart';

displayErrorMsg(BuildContext context, String errorMsg) {
  Alert(
      context: context,
      type: AlertType.error,
      content: Column(
        children: [
          SizedBox(height: medium),
          Text("An error occured!", style: bold25, textAlign: TextAlign.center),
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

displayGameOver(BuildContext context) async {
  final gameStateViewModel = context.read<GameStateViewModel>();
  bool isNewHighscore = false;
  if (!isGuest) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
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
          'Final Score: ${gameStateViewModel.scores}${isNewHighscore ? "\nCongratulations for new high score!" : ""}',
          style: heading3,
          textAlign: TextAlign.center,
        )
      ],
    ),
    buttons: [
      DialogButton(
        onPressed: () {
          //save screenshot of game result to photo gallery (milestone 2)
        },
        color: Colors.blue,
        child: const Text(
          'Save Game Result',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      // < Place the Try Again button here.>
      DialogButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          context.goNamed('leaderboard_page');
          /*Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const MyHomePage(pageIndex: 1)));*/
        },
        color: Colors.blue,
        child: const Text(
          'View Leaderboard',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      DialogButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          gameStateViewModel.reset();
        },
        color: Colors.blue,
        child: const Text(
          'Retry', // Try Again
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      DialogButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          context.goNamed('home_page', pathParameters: {'index': 0.toString()});
          /*Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => const MyHomePage(pageIndex: 0)));*/
        },
        color: Colors.blue,
        child: const Text(
          'Home', // Main Menu
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ],
  ).show();
}
