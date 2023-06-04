import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:chimp_game/firebase/profile_view.dart';
import 'package:chimp_game/home_page.dart';

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

  testWidgets('Check every displayed text/button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MyHomePage(pageIndex: 0)));

    expect(find.text('CHIMP GAME'), findsOneWidget);
    expect(find.text('PLAY'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.byIcon(Icons.leaderboard), findsOneWidget);
    expect(find.text('Leaderboard'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);
    expect(find.text('My Profile'), findsOneWidget);
  });

  group('BottomNavBar Tests', () {
    testWidgets('Pressing leaderboard icon navigates to Leaderboard Page', (tester) async {
      await tester.pumpWidget(const MaterialApp(home: MyHomePage(pageIndex: 0)));

      expect(find.text('CHIMP GAME'), findsOneWidget);
      expect(find.text('PLAY'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.leaderboard), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      await tester.tap(find.byIcon(Icons.leaderboard));
      await tester.pump();

      expect(find.text('Leaderboard'), findsNWidgets(2));
      expect(find.byIcon(Icons.leaderboard), findsNWidgets(2));

      expect(find.text('CHIMP GAME'), findsNothing);
      expect(find.text('PLAY'), findsNothing);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('Pressing person icon navigates to Profile Page', (tester) async {
      isGuest = true;
      await tester.pumpWidget(const MaterialApp(home: MyHomePage(pageIndex: 0)));

      expect(find.text('CHIMP GAME'), findsOneWidget);
      expect(find.text('PLAY'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.leaderboard), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      await tester.tap(find.byIcon(Icons.person));
      await tester.pump();

      expect(find.text('Guest'), findsOneWidget);
      expect(find.text('Already have an account?'), findsOneWidget);
      expect(find.text('Click here to login!'), findsOneWidget);

      expect(find.text('CHIMP GAME'), findsNothing);
      expect(find.text('PLAY'), findsNothing);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.leaderboard), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });

    testWidgets('Pressing home icon navigates to Profile Page', (tester) async {
      isGuest = true;
      await tester.pumpWidget(const MaterialApp(home: MyHomePage(pageIndex: 2)));

      expect(find.text('Guest'), findsOneWidget);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.leaderboard), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);

      await tester.tap(find.byIcon(Icons.home));
      await tester.pump();

      expect(find.text('CHIMP GAME'), findsOneWidget);
      expect(find.text('PLAY'), findsOneWidget);

      expect(find.text('Guest'), findsNothing);
      expect(find.byIcon(Icons.home), findsOneWidget);
      expect(find.byIcon(Icons.leaderboard), findsOneWidget);
      expect(find.byIcon(Icons.person), findsOneWidget);
    });
  });
}