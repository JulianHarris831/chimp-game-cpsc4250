import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:screenshot/screenshot.dart';
import 'package:chimp_game/alerts.dart';
import 'package:chimp_game/game_state_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

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

  void callbackDecoy(bool value) {
    bool decoy = value;
  }

  group('displayErrorMsg and displaySuccessMsg Alert tests', () {
    testWidgets('displayErrorMsg shows error alert',
        (WidgetTester tester) async {
      const errorMsg = 'Test Error Message';

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                displayErrorMsg(context, errorMsg);
              },
              child: const Text('Show Error Alert'),
            );
          },
        ),
      ));

      // Verify that the 'Show Error Alert' button is there
      expect(find.text('Show Error Alert'), findsOneWidget);

      // Taps the button to display the pop-up error alert
      await tester.tap(find.text('Show Error Alert'));
      await tester.pumpAndSettle();

      // Verify that the pop-up error alert is displayed with the errorMsg
      expect(find.text('An error occurred!'), findsOneWidget);
      expect(find.text(errorMsg), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);
    });

    testWidgets('displayErrorMsg alert pops context when tapping Try Again',
        (WidgetTester tester) async {
      const errorMsg = 'Test Error Message';

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                displayErrorMsg(context, errorMsg);
              },
              child: const Text('Show Error Alert'),
            );
          },
        ),
      ));

      // Verify that the 'Show Error Alert' button is there
      expect(find.text('Show Error Alert'), findsOneWidget);

      // Taps the button to display the pop-up error alert
      await tester.tap(find.text('Show Error Alert'));
      await tester.pumpAndSettle();

      // Verify that the pop-up error alert is displayed with the Try Again button
      expect(find.text('An error occurred!'), findsOneWidget);
      expect(find.text(errorMsg), findsOneWidget);
      expect(find.text('Try again'), findsOneWidget);

      // Taps the Try Again button to pop current context
      await tester.tap(find.text('Try again'));
      await tester.pumpAndSettle();

      // Verify that you are back to the screen with the 'Show Error Alert' button
      expect(find.text('Show Error Alert'), findsOneWidget);
    });

    testWidgets('displaySuccessMsg shows success alert',
        (WidgetTester tester) async {
      const successMsg = 'Test Success Message';

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                displaySuccessMsg(context, successMsg);
              },
              child: const Text('Show Success Alert'),
            );
          },
        ),
      ));

      // Verify that the 'Show Success Alert' button is there
      expect(find.text('Show Success Alert'), findsOneWidget);

      // Taps the 'Show Success Alert' button to display the success alert
      await tester.tap(find.text('Show Success Alert'));
      await tester.pumpAndSettle();

      // Verify that the success pop-up alert is displayed properly
      expect(find.text('SUCCESS'), findsOneWidget);
      expect(find.text(successMsg), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);
    });

    testWidgets('displaySuccessMsg alert pops context when tapping OK',
        (WidgetTester tester) async {
      const successMsg = 'Test Success Message';

      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () {
                displaySuccessMsg(context, successMsg);
              },
              child: const Text('Show Success Alert'),
            );
          },
        ),
      ));

      // Verify that the 'Show Success Alert' button is there
      expect(find.text('Show Success Alert'), findsOneWidget);

      // Taps the 'Show Success Alert' button to display the success alert
      await tester.tap(find.text('Show Success Alert'));
      await tester.pumpAndSettle();

      // Verify that the success pop-up alert is displayed properly
      expect(find.text('SUCCESS'), findsOneWidget);
      expect(find.text(successMsg), findsOneWidget);
      expect(find.text('OK'), findsOneWidget);

      // Taps the 'OK' button to pop back to previous page
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();

      // Verify that you are back to the page with 'Show Success Alert' button
      expect(find.text('Show Success Alert'), findsOneWidget);
    });
  });

  group('displayGameOver Alert tests', () {
    testWidgets('displayGameOver shows game over screen',
        (WidgetTester tester) async {
      final testViewModel = GameStateViewModel();
      final controller = ScreenshotController();

      await tester.pumpWidget(ChangeNotifierProvider.value(
          value: testViewModel,
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    displayGameOver(context, controller, callbackDecoy);
                  },
                  child: const Text('Show Game Over Alert'),
                );
              },
            ),
          )));

      // Verify that the 'Show Game Over Alert' button is there
      expect(find.text('Show Game Over Alert'), findsOneWidget);

      // Taps the 'Show Game Over Alert' button to display the game over screen
      await tester.tap(find.text('Show Game Over Alert'));
      await tester.pumpAndSettle();

      // Verify that the Game Over pop-up alert is displayed properly
      expect(find.text('Final Score: 0'), findsOneWidget);
      expect(find.text('Save Result'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);
      expect(find.text('View Leaderboard'), findsOneWidget);
      expect(find.text('Main Menu'), findsOneWidget);
    });

    testWidgets(
        'displayGameOver tapping Save Result when image is null display errorMsg',
        (WidgetTester tester) async {
      final testViewModel = GameStateViewModel();
      final controller = ScreenshotController();

      await tester.pumpWidget(ChangeNotifierProvider.value(
          value: testViewModel,
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    displayGameOver(context, controller, callbackDecoy);
                  },
                  child: const Text('Show Game Over Alert'),
                );
              },
            ),
          )));

      // Verify that the 'Show Game Over Alert' button is there
      expect(find.text('Show Game Over Alert'), findsOneWidget);

      // Taps the 'Show Game Over Alert' button to display the game over screen
      await tester.tap(find.text('Show Game Over Alert'));
      await tester.pumpAndSettle();

      // Verify that the Game Over pop-up alert is displayed and 'Save Result' button is there
      expect(find.text('Final Score: 0'), findsOneWidget);
      expect(find.text('Save Result'), findsOneWidget);

      // Taps the 'Save Result' button when image is null (empty ScreenshotController)
      await tester.tap(find.text('Save Result'));
      await tester.pumpAndSettle();

      // Verify that a pop-up error alert is displayed: Fails to save image to gallery
      expect(find.text('Failed to save result to Gallery.'), findsOneWidget);
    });

    testWidgets('displayGameOver tapping Try Again pops current context',
        (WidgetTester tester) async {
      final testViewModel = GameStateViewModel();
      testViewModel.test = true;
      final controller = ScreenshotController();

      await tester.pumpWidget(ChangeNotifierProvider.value(
          value: testViewModel,
          child: MaterialApp(
            home: Builder(
              builder: (BuildContext context) {
                return ElevatedButton(
                  onPressed: () {
                    displayGameOver(context, controller, callbackDecoy);
                  },
                  child: const Text('Show Game Over Alert'),
                );
              },
            ),
          )));

      // Verify that the 'Show Game Over Alert' button is there
      expect(find.text('Show Game Over Alert'), findsOneWidget);

      // Taps the 'Show Game Over Alert' button to display the game over screen
      await tester.tap(find.text('Show Game Over Alert'));
      await tester.pumpAndSettle();

      // Verify that the Game Over screen is displayed with 'Try Again' button
      expect(find.text('Final Score: 0'), findsOneWidget);
      expect(find.text('Try Again'), findsOneWidget);

      // Taps the 'Try Again' button to pop current context
      await tester.tap(find.text('Try Again'));
      await tester.pumpAndSettle();

      // Verify that context is popped back to screen with 'Show Game Over Alert' button
      expect(find.text('Show Game Over Alert'), findsOneWidget);
    });

    testWidgets(
        'displayGameOver tapping View Leaderboard navigates to LeaderboardPage',
        (WidgetTester tester) async {
      final testViewModel = GameStateViewModel();
      final controller = ScreenshotController();

      const destinationIdentifier = 'sajkdas9824294jaa'; // unique string id
      final router = GoRouter(routes: [
        GoRoute(
            path: '/',
            builder: (context, _) => MaterialApp(
                  home: Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        onPressed: () {
                          displayGameOver(context, controller, callbackDecoy);
                        },
                        child: const Text('Show Game Over Alert'),
                      );
                    },
                  ),
                )),
        GoRoute(
            path: '/leaderboard_page',
            name: 'leaderboard_page',
            builder: (context, _) =>
                const Scaffold(body: Text(destinationIdentifier))),
      ]);

      await tester.pumpWidget(ChangeNotifierProvider.value(
          value: testViewModel,
          child: MaterialApp.router(
            routerConfig: router,
          )));

      // Verify that the 'Show Game Over Alert' button is there
      expect(find.text('Show Game Over Alert'), findsOneWidget);

      // Taps the 'Show Game Over Alert' button to display the game over screen
      await tester.tap(find.text('Show Game Over Alert'));
      await tester.pumpAndSettle();

      // Verify that the Game Over screen is displayed with 'View Leaderboard' button
      expect(find.text('Final Score: 0'), findsOneWidget);
      expect(find.text('View Leaderboard'), findsOneWidget);

      // Taps the 'View Leaderboard' button to navigate to LeaderboardPage
      await tester.tap(find.text('View Leaderboard'));
      await tester.pumpAndSettle();

      // Verify that context is popped and navigates to LeaderboardPage
      expect(find.text(destinationIdentifier), findsOneWidget);
    });

    testWidgets('displayGameOver tapping Main Menu navigates to Main Menu',
        (WidgetTester tester) async {
      final testViewModel = GameStateViewModel();
      final controller = ScreenshotController();

      const destinationIdentifier = 'sajkeas7842174jnksa'; // unique string id
      final router = GoRouter(routes: [
        GoRoute(
            path: '/',
            builder: (context, _) => MaterialApp(
                  home: Builder(
                    builder: (BuildContext context) {
                      return ElevatedButton(
                        onPressed: () {
                          displayGameOver(context, controller, callbackDecoy);
                        },
                        child: const Text('Show Game Over Alert'),
                      );
                    },
                  ),
                )),
        GoRoute(
          path: "/home_page/:index",
          name: "home_page",
          builder: (context, state) {
            final index = int.parse(state.pathParameters['index']!);
            return const Scaffold(body: Text(destinationIdentifier));
          },
        ),
      ]);

      await tester.pumpWidget(ChangeNotifierProvider.value(
          value: testViewModel,
          child: MaterialApp.router(
            routerConfig: router,
          )));

      // Verify that the 'Show Game Over Alert' button is there
      expect(find.text('Show Game Over Alert'), findsOneWidget);

      // Taps the 'Show Game Over Alert' button to display the game over screen
      await tester.tap(find.text('Show Game Over Alert'));
      await tester.pumpAndSettle();

      // Verify that the Game Over screen is displayed with 'Main Menu' button
      expect(find.text('Final Score: 0'), findsOneWidget);
      expect(find.text('Main Menu'), findsOneWidget);

      // Taps the 'Main Menu' button to navigate back to Main Menu
      await tester.tap(find.text('Main Menu'));
      await tester.pumpAndSettle();

      // Verify that context is popped and navigates to Main Menu
      expect(find.text(destinationIdentifier), findsOneWidget);
    });
  });
}
