import 'package:chimp_game/leaderboard/leaderboard_page.dart';
import 'package:chimp_game/leaderboard/player_account.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chimp_game/alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';

//import 'leaderboard_page_test.mocks.dart';

// flutter test test/leaderboard/leaderboard_page_test.dart

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

void main() async {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  testWidgets('LeaderboardHeading widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LeaderboardHeading()));
    await tester.pumpAndSettle();

    expect(find.text("Leaderboard"), findsOneWidget);
    expect(find.byIcon(Icons.leaderboard), findsOneWidget);
  });

  testWidgets('ListHeader widget test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: ListHeader()));
    await tester.pumpAndSettle();

    expect(find.text("Rank"), findsOneWidget);
    expect(find.text("Nickname"), findsOneWidget);
    expect(find.text("Highscore"), findsOneWidget);
  });

  testWidgets('PlayerDisplay display the right player information',
      (WidgetTester tester) async {
    final player1 = Player("player1Id", 2000, "Walter");
    await tester.pumpWidget(
        MaterialApp(home: PlayerDisplay(player: player1, index: 0)));
    await tester.pumpAndSettle();

    expect(find.text("1"), findsOneWidget);
    expect(find.text("Walter"), findsOneWidget);
    expect(find.text("2000"), findsOneWidget);
  });
}
