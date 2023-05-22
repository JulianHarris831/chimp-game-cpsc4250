import 'package:chimp_game/firebase/login_view.dart';
import 'package:chimp_game/firebase/profile_view.dart';
import 'package:chimp_game/firebase/register_view.dart';
import 'package:chimp_game/game_state_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'login_view_test.mocks.dart';

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

  testWidgets("GuestProfile displayed correctly", (tester) async {
    await tester.pumpWidget(MaterialApp(home: GuestProfile()));

    //expect(find.text("Guest"), findsOneWidget);
    expect(find.text('Click here to register!'), findsOneWidget);
    expect(find.text('Click here to login!'), findsOneWidget);
  });

  testWidgets("GuestProfile can navigate to LoginView()", (tester) async {
    final router = GoRouter(initialLocation: "/guest_profile", routes: [
      GoRoute(
        path: "/guest_profile",
        name: "guest_profile",
        builder: (context, state) => const GuestProfile(),
      ),
      GoRoute(
        path: "/login_view",
        name: "login_view",
        builder: (context, state) => const LoginView(),
      ),
    ]);

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => GameStateViewModel(),
      child: MaterialApp.router(
        routerConfig: router,
      ),
    ));

    expect(find.text('Click here to login!'), findsOneWidget);
    await tester.tap(find.text('Click here to login!'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);
    expect(find.byType(RegisterView), findsNothing);
  });

  testWidgets("GuestProfile can navigate to RegisterView()", (tester) async {
    final router = GoRouter(initialLocation: "/guest_profile", routes: [
      GoRoute(
        path: "/guest_profile",
        name: "guest_profile",
        builder: (context, state) => const GuestProfile(),
      ),
      GoRoute(
        path: "/register_view",
        name: "register_view",
        builder: (context, state) => const RegisterView(),
      ),
    ]);

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => GameStateViewModel(),
      child: MaterialApp.router(
        routerConfig: router,
      ),
    ));

    expect(find.text('Click here to register!'), findsOneWidget);
    await tester.tap(find.text('Click here to register!'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterView), findsOneWidget);
    expect(find.byType(LoginView), findsNothing);
  });
}
