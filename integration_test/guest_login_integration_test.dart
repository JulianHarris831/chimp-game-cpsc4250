import 'dart:math';

import 'package:chimp_game/main_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:chimp_game/main.dart' as app;

//paste this command below into your terminal to run integration test:
// flutter test integration_test/guest_login_integration_test.dart

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets("login as Guest then navigate correctly to MainMenuPage",
      (tester) async {
    app.main();
    await tester.pumpAndSettle(Duration(seconds: 3));

    final guestButton =
        find.widgetWithText(ElevatedButton, 'Continue as Guest');
    expect(guestButton, findsOneWidget);

    await tester.tap(guestButton);
    await tester.pumpAndSettle(Duration(seconds: 5));

    expect(find.text("CHIMP GAME"), findsOneWidget);
    expect(find.byType(MainMenuPage), findsOneWidget);
    await tester.pumpAndSettle(Duration(seconds: 3));
  });
}
