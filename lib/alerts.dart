import 'package:flutter/material.dart';
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

displayGameOver(BuildContext context) {
  final gameStateViewModel = context.read<GameStateViewModel>();
  Alert(
    context: context,
    content: Column(
      children: [
        Text(gameStateViewModel.level,
          style: heading2, textAlign: TextAlign.center),
        SizedBox(height: medium),
        Text('Final Score: ${gameStateViewModel.scores}',
          style: heading3, textAlign: TextAlign.center),
      ],
    ),
    buttons: [
      /*DialogButton(
        onPressed: () {
          //save screenshot of game result to photo gallery (milestone 2)
        },
        color: Colors.blue,
        child: const Text('Save Game Result',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      // < Place the Try Again button here.>
      DialogButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const MyHomePage(pageIndex: 1)));
        },
        color: Colors.blue,
        child: const Text('View Leaderboard',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),*/
      DialogButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          gameStateViewModel.reset();
        },
        color: Colors.blue,
        child: const Text('Retry', // Try Again
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      DialogButton(
        onPressed: () {
          Navigator.of(context, rootNavigator: true).pop();
          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => const MyHomePage(pageIndex: 0)));
        },
        color: Colors.blue,
        child: const Text('Home', // Main Menu
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
    ],
  ).show();
}
