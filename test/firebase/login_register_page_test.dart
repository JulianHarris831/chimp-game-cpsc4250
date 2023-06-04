import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chimp_game/firebase/login_register_page.dart';
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

  testWidgets('Test initial route "/login_or_register" navigates to LoginPage', (WidgetTester tester) async {
    // Uses pre-defined LoginOrRegister router to check navigation
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));
    await tester.pumpAndSettle();

    // Verify that the initial route navigates to LoginPage as autoLogin is false
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Click here to register!'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);
  });

  testWidgets('Test button navigation route between RegisterPage and initial LoginPage', (WidgetTester tester) async {
    // Uses pre-defined LoginOrRegister router to check navigation
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));
    await tester.pumpAndSettle();

    // Verify that the initial route navigates to LoginPage as autoLogin is false
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Click here to register!'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);

    // Taps 'Click here to register!' button
    await tester.tap(find.text('Click here to register!'));
    await tester.pumpAndSettle();

    // Verify that it properly navigates to the RegisterPage
    expect(find.text('Register:'), findsOneWidget);
    expect(find.text('Profile Information: '), findsOneWidget);
    expect(find.text('Register'), findsOneWidget);

    // Taps back arrow to go back to LoginPage
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    // Verify that it properly routes back to initial LoginPage
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Click here to register!'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);
  });

  testWidgets('Test tapping Continue as Guest route to Main Menu from LoginPage', (WidgetTester tester) async {
    // Uses pre-defined LoginOrRegister router to check navigation
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));
    await tester.pumpAndSettle();

    // Verify that the initial route navigates to LoginPage as autoLogin is false
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Click here to register!'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);

    // Taps Continue as Guest button
    await tester.tap(find.text('Continue as Guest'));
    await tester.pumpAndSettle();

    // Verify that it navigates properly to Main Menu
    expect(find.text('CHIMP GAME'), findsOneWidget);
    expect(find.text('PLAY'), findsOneWidget);

    // Go back to LoginPage through Profile Page
    await tester.tap(find.byIcon(Icons.person));
    await tester.pump();

    await tester.tap(find.text('Click here to login!'));
    await tester.pumpAndSettle();

    // Verify you are back to LoginPage
    expect(find.text('Welcome!'), findsOneWidget);
  });

  testWidgets('Test Leaderboard route from LoginPage', (WidgetTester tester) async {
    // Uses pre-defined LoginOrRegister router to check navigation
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));
    await tester.pumpAndSettle();

    // Verify that the initial route navigates to LoginPage as autoLogin is false
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Click here to register!'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);

    // Taps Continue as Guest button
    await tester.tap(find.text('Continue as Guest'));
    await tester.pumpAndSettle();

    // Verify that it navigates properly to Main Menu
    expect(find.text('CHIMP GAME'), findsOneWidget);
    expect(find.text('PLAY'), findsOneWidget);

    // Taps the Leaderboard BottomNavBar to route to Leaderboard Page
    await tester.tap(find.byIcon(Icons.leaderboard));
    await tester.pump();

    // Verify that it navigates properly to Leaderboard Page
    expect(find.text('Leaderboard'), findsNWidgets(2));
    expect(find.byIcon(Icons.leaderboard), findsNWidgets(2));

    // Go back to LoginPage through Profile Page
    await tester.tap(find.byIcon(Icons.person));
    await tester.pump();

    await tester.tap(find.text('Click here to login!'));
    await tester.pumpAndSettle();

    // Verify you are back to LoginPage
    expect(find.text('Welcome!'), findsOneWidget);
  });

  testWidgets('Test Difficulty Page route from LoginPage', (WidgetTester tester) async {
    // Uses pre-defined LoginOrRegister router to check navigation
    await tester.pumpWidget(MaterialApp.router(
      routerConfig: router,
    ));
    await tester.pumpAndSettle();

    // Verify that the initial route navigates to LoginPage as autoLogin is false
    expect(find.text('Welcome!'), findsOneWidget);
    expect(find.text('Click here to register!'), findsOneWidget);
    expect(find.text('Continue as Guest'), findsOneWidget);

    // Taps Continue as Guest button
    await tester.tap(find.text('Continue as Guest'));
    await tester.pumpAndSettle();

    // Verify that it navigates properly to Main Menu
    expect(find.text('CHIMP GAME'), findsOneWidget);
    expect(find.text('PLAY'), findsOneWidget);

    // Taps the PLAY button to route to Difficulty Page
    await tester.tap(find.text('PLAY'));
    await tester.pumpAndSettle();

    // Verify that it navigates properly to Difficulty Page
    expect(find.text('Choose your Difficulty'), findsOneWidget);
    expect(find.text('Easy'), findsOneWidget);
    expect(find.text('Medium'), findsOneWidget);
    expect(find.text('Hard'), findsOneWidget);

    // Go back to LoginPage through Profile Page
    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.person));
    await tester.pump();

    await tester.tap(find.text('Click here to login!'));
    await tester.pumpAndSettle();

    // Verify you are back to LoginPage
    expect(find.text('Welcome!'), findsOneWidget);
  });
}