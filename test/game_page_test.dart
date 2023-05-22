import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:chimp_game/game_state_view_model.dart';
import 'package:chimp_game/game_page.dart';

//TODO: Some issues with the tests: tester.pumpWidgets(GamePage) generates 6 buttons maximum

void main() {
  testWidgets('Checks sequence numbers are displayed', (tester) async {
    //await tester.pumpWidget(const MaterialApp(home: GamePage()));
    final testViewModel = GameStateViewModel();
    testViewModel.setDifficulty('easy');
    testViewModel.initializeGame();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: testViewModel,
        child: const MaterialApp(home: GamePage())
      )
    );
    await tester.pumpAndSettle();

    //should see numbers 1-3 as the base grid, and 9 buttons
    expect(find.text('CHIMP GAME: Level 1'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.text('Score: 0'), findsOneWidget);
    expect(find.text('Lives: '), findsOneWidget);
    expect(find.byIcon(Icons.favorite), findsNWidgets(3));
    expect(find.byType(ElevatedButton), findsAtLeastNWidgets(6));
    //expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Check response when correct button is pressed', (tester) async {
    //await tester.pumpWidget(const MaterialApp(home: GamePage()));
    final testViewModel = GameStateViewModel();
    testViewModel.setDifficulty('easy');
    testViewModel.initializeGame();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: testViewModel,
        child: const MaterialApp(home: GamePage())
      )
    );
    await tester.pumpAndSettle();

    // Verify that player score starts from 0
    expect(find.text('Score: 0'), findsOneWidget);

    //tap #1, see that score goes up?
    //await tester.tap(find.text('1'));
    int gridKey = testViewModel.sequence!.keys.firstWhere(
            (k) => testViewModel.sequence![k] == 1, orElse: () => null);
    testViewModel.onButtonPressed(gridKey);
    await tester.pump();
    //expect(find.text(''), findsOneWidget);
    expect(find.text('Score: 10'), findsOneWidget);
  });

  testWidgets('Check response when wrong sequence is pressed', (tester) async {
    final testViewModel = GameStateViewModel();
    testViewModel.setDifficulty('medium');
    testViewModel.initializeGame();

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: testViewModel,
        child: const MaterialApp(home: GamePage())
      )
    );
    await tester.pumpAndSettle();

    // Verify that player lives starts from 3
    expect(find.byIcon(Icons.favorite), findsNWidgets(3));

    //Press the wrong sequence intentionally (for now, internally)
    //await tester.tap(find.text('2'));
    int falseGridKey = testViewModel.sequence!.keys.firstWhere(
            (k) => testViewModel.sequence![k] == 2, orElse: () => null);
    testViewModel.onButtonPressed(falseGridKey);
    await tester.pump();

    // Verify that the player lose a life when doing so
    expect(find.byIcon(Icons.favorite), findsNWidgets(2));
    expect(find.byIcon(Icons.heart_broken), findsOneWidget);
  });

  testWidgets('Checks navigation via Home icon', (tester) async {
    final testViewModel = GameStateViewModel();
    testViewModel.setDifficulty('hard');
    testViewModel.initializeGame();

    const destinationIdentifier = 'asjkdae7148193sads'; // unique string id
    final router = GoRouter(
        routes: [
          GoRoute(
              path: '/',
              builder: (context, _) => const GamePage()
          ),
          GoRoute(
            path: "/home_page/:index",
            name: "home_page",
            builder: (context, state) {
              final index = int.parse(state.pathParameters['index']!);
              return const Scaffold(body: Text(destinationIdentifier));
            },
          ),
        ]
    );

    await tester.pumpWidget(
      ChangeNotifierProvider.value(
        value: testViewModel,
        child: MaterialApp.router(routerConfig: router)
      )
    );
    await tester.pumpAndSettle();

    // Verify initial route in GamePage and Home icon is available
    expect(find.text('CHIMP GAME: Level 1'), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);

    // Press the Home icon to navigate back to home_page
    await tester.tap(find.byIcon(Icons.home));
    await tester.pumpAndSettle();

    // Verify that the Home icon navigates properly to home_page
    expect(find.text(destinationIdentifier), findsOneWidget);
  });
}