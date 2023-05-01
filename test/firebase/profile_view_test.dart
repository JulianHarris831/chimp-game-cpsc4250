import 'dart:math';

import 'package:chimp_game/firebase/firebase_options.dart';
import 'package:chimp_game/firebase/login_view.dart';
import 'package:chimp_game/firebase/profile_view.dart';
import 'package:chimp_game/firebase/register_view.dart';
import 'package:chimp_game/home_page.dart';
import 'package:chimp_game/main_menu_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chimp_game/alerts.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// flutter test test/firebase/profile_view_test.dart
class MockFirebaseAuth extends Mock implements FirebaseAuth {}

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

  testWidgets("ProfilePage shows GuestProfile if isGuest is true",
      (tester) async {
    isGuest = true;

    await tester.pumpWidget(MaterialApp(home: ProfilePage()));
    expect(find.byType(GuestProfile), findsOneWidget);
  });

//THIS METHOD BELOW DOES NOT WORK YET
  /*
  testWidgets("ProfilePage shows GuestProfile if isGuest is false",
      (tester) async {
    isGuest = false;
    await MockFirebaseAuth().signInWithEmailAndPassword(
        email: "test1@gmail.com", password: "123456");
    final user = MockFirebaseAuth().currentUser;

    await tester
        .pumpWidget(MaterialApp(home: FireBaseAccountProfile()));

    expect(find.byType(FireBaseAccountProfile), findsOneWidget);
  });
  */

  testWidgets("GuestProfile displayed correctly", (tester) async {
    await tester.pumpWidget(MaterialApp(home: GuestProfile()));

    //expect(find.text("Guest"), findsOneWidget);
    expect(find.text('Click here to register!'), findsOneWidget);
    expect(find.text('Click here to login!'), findsOneWidget);
  });

  testWidgets("GuestProfile can navigate to LoginView()", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GuestProfile(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ));

    expect(find.text('Click here to login!'), findsOneWidget);
    await tester.tap(find.text('Click here to login!'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);
    expect(find.byType(RegisterView), findsNothing);
  });

  testWidgets("GuestProfile can navigate to RegisterView()", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: GuestProfile(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ));

    expect(find.text('Click here to register!'), findsOneWidget);
    await tester.tap(find.text('Click here to register!'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterView), findsOneWidget);
    expect(find.byType(LoginView), findsNothing);
  });
}
