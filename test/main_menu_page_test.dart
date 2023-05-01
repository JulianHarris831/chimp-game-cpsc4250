import 'dart:math';

import 'package:chimp_game/difficulty_page.dart';
import 'package:chimp_game/main_menu_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
// flutter test test/main_menu_page_test.dart

void main() {
  testWidgets('Check every displayed text/button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainMenuPage()));

    expect(find.text('CHIMP GAME'), findsOneWidget);
    expect(find.text('PLAY'), findsOneWidget);
  });
}
