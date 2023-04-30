import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
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
    ]
  ).show();
}
