import 'dart:math';

import 'package:chimp_game/main_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:chimp_game/main.dart' as app;

//paste this command below into your terminal to run integration test:
// flutter test integration_test/firebase_login_integration_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
      "login with existed account then navigate correctly to MainMenuPage",
      (tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(seconds: 3));

    final loginButton = find.widgetWithText(TextButton, "Login");
    expect(loginButton, findsOneWidget);

    final emailField = find.widgetWithText(TextField, "Enter your email here!");
    await tester.enterText(emailField, "test1@gmail.com");
    await tester.pumpAndSettle(Duration(seconds: 2));

    final passwordField =
        find.widgetWithText(TextField, "Enter your password here!");
    await tester.enterText(passwordField, "123456");
    await tester.pumpAndSettle(Duration(seconds: 2));

    await tester.tap(loginButton);
    await tester.pumpAndSettle(Duration(seconds: 10));

    expect(find.text("CHIMP GAME"), findsOneWidget);
    expect(find.byType(MainMenuPage), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 3));
  });
}
