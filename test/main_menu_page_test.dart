import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:chimp_game/game_state_view_model.dart';
import 'package:chimp_game/main_menu_page.dart';

void main() {
  testWidgets('Check every displayed text/button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: MainMenuPage()));

    expect(find.text('CHIMP GAME'), findsOneWidget);
    expect(find.text('PLAY'), findsOneWidget);
  });

  testWidgets('Test Play button navigates to difficulty settings page', (tester) async {
    final gameStateViewModel = GameStateViewModel();

    const destinationIdentifier = 'abhqeyha4gf5gtw45gw'; // unique string id
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => const MainMenuPage()
        ),
        GoRoute(
          path: '/difficulty_page',
          name: 'difficulty_page',
          builder: (context, _) => const Scaffold(body: Text(destinationIdentifier))
        ),
      ]
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<GameStateViewModel>.value(
        value: gameStateViewModel,
        child: MaterialApp.router(routerConfig: router)
      )
    );
    await tester.pumpAndSettle();

    // Verify that there is the 'PLAY' button that we want to test.
    expect(find.widgetWithText(ElevatedButton, 'PLAY'), findsOneWidget);

    // Tap the 'PLAY' button and wait for navigation to go through all of its frames of animation
    await tester.tap(find.widgetWithText(ElevatedButton, 'PLAY'));
    await tester.pumpAndSettle();

    // Verify that the widget lets the user navigates to the difficulty page route.
    expect(find.text(destinationIdentifier), findsOneWidget);
  });
}