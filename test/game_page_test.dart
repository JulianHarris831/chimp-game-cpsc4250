import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:chimp_game/game_state_view_model.dart';
import 'package:chimp_game/game_page.dart';

//TODO: Issues with these tests, we might need to use Mockito instead?

void main() {
  testWidgets('Checks sequence numbers are displayed', (tester) async {
    //await tester.pumpWidget(const MaterialApp(home: GamePage()));
    final testViewModel = GameStateViewModel();
    await tester.pumpWidget(
      ChangeNotifierProvider<GameStateViewModel>.value(
        value: testViewModel,
        child: const MaterialApp(
          home: Scaffold(
            //by default, game page is set to easy difficulty!
            body: GamePage()
          )
        )
      )
    );

    //should see numbers 1-3 as the base grid, and 9 buttons
    expect(find.text('1'), findsOneWidget);
  });

  testWidgets('Check response when button correct button is pressed', (tester) async {
    //await tester.pumpWidget(const MaterialApp(home: GamePage()));
    final testViewModel = GameStateViewModel();
    await tester.pumpWidget(
        ChangeNotifierProvider.value(
            value: testViewModel,
            child: const MaterialApp(
                home: Scaffold(
                  //by default, game page is set to easy difficulty!
                    body: GamePage()
                )
            )
        )
    );

    //tap #1, see that score goes up?
    await tester.tap(find.text('1'));
    await tester.pump();
    //expect(find.text(''), findsOneWidget);
  });
}