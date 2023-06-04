import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'package:chimp_game/game_state_view_model.dart';
import 'package:chimp_game/difficulty_page.dart';

void main() {
  testWidgets('Check every displayed text/button', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: DifficultyPage()));

    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);
  });

  testWidgets('Testing easy button properly navigates', (tester) async{
    final testViewModel = GameStateViewModel();
    testViewModel.test = true;

    const destinationChecker = '12345';
    final router = GoRouter(
      routes: [
        //make difficulty page our home page for this test!
        GoRoute(
          path: '/',
          builder: (context, _) => const Scaffold(
            body: DifficultyPage(),
          )
        ),
        GoRoute(
          path: '/game_page',
          name: 'game_page',
          builder: (context, _) => const Scaffold(
            body: Text(destinationChecker),
          )
        ),
      ],
    );

    await tester.pumpWidget(
      ChangeNotifierProvider<GameStateViewModel>.value(
        value: testViewModel,
        child: MaterialApp.router(
          routerConfig: router
        )
      )
    );

    await tester.tap(find.byIcon(Icons.directions_run));
    await tester.pumpAndSettle();
    expect(find.text(destinationChecker), findsOneWidget);
  });

  testWidgets('Testing that medium button properly navigates', (tester) async{
    final testViewModel = GameStateViewModel();
    testViewModel.test = true;

    const destinationChecker = '12345';
    final router = GoRouter(
      routes: [
        //make difficulty page our home page for this test!
        GoRoute(
            path: '/',
            builder: (context, _) => const Scaffold(
              body: DifficultyPage(),
            )
        ),
        GoRoute(
            path: '/game_page',
            name: 'game_page',
            builder: (context, _) => const Scaffold(
              body: Text(destinationChecker),
            )
        ),
      ],
    );

    await tester.pumpWidget(
        ChangeNotifierProvider<GameStateViewModel>.value(
            value: testViewModel,
            child: MaterialApp.router(
                routerConfig: router
            )
        )
    );

    await tester.tap(find.byIcon(Icons.directions_bike));
    await tester.pumpAndSettle();
    expect(find.text(destinationChecker), findsOneWidget);
  });

  testWidgets('Testing that hard button properly navigates', (tester) async{
    final testViewModel = GameStateViewModel();
    testViewModel.test = true;

    const destinationChecker = '12345';
    final router = GoRouter(
      routes: [
        //make difficulty page our home page for this test!
        GoRoute(
            path: '/',
            builder: (context, _) => const Scaffold(
              body: DifficultyPage(),
            )
        ),
        GoRoute(
            path: '/game_page',
            name: 'game_page',
            builder: (context, _) => const Scaffold(
              body: Text(destinationChecker),
            )
        ),
      ],
    );

    await tester.pumpWidget(
        ChangeNotifierProvider<GameStateViewModel>.value(
            value: testViewModel,
            child: MaterialApp.router(
                routerConfig: router
            )
        )
    );

    await tester.tap(find.byIcon(Icons.directions_car));
    await tester.pumpAndSettle();
    expect(find.text(destinationChecker), findsOneWidget);
  });
}