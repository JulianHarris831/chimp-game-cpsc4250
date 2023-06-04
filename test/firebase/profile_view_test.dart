import 'package:chimp_game/firebase/login_register_page.dart';
import 'package:chimp_game/firebase/login_view.dart';
import 'package:chimp_game/firebase/logout.dart';
import 'package:chimp_game/firebase/profile_view.dart';
import 'package:chimp_game/firebase/register_view.dart';
import 'package:chimp_game/firebase/user_auth.dart';
import 'package:chimp_game/game_state_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

//import 'login_view_test.mocks.dart';
import 'profile_view_test.mocks.dart';

// flutter test test/firebase/profile_view_test.dart
@GenerateMocks([User, UserAuth])
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

    expect(find.text("Guest"), findsOneWidget);

    expect(find.text("Already have an account?"), findsOneWidget);
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

    expect(find.text("Already have an account?"), findsOneWidget);
    expect(find.text('Click here to login!'), findsOneWidget);
    await tester.tap(find.text('Click here to login!'));
    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);
    expect(find.byType(RegisterView), findsNothing);
  });

  testWidgets("Logout displayed correctly", (tester) async {
    MockUserAuth userAuth = MockUserAuth();
    final router = GoRouter(initialLocation: "/logout", routes: [
      GoRoute(
        path: "/logout",
        name: "logout",
        builder: (context, state) => Logout(
          userAuth: userAuth,
        ),
      ),
      GoRoute(
        path: "/login_or_register",
        name: "login_or_register",
        builder: (context, state) => LoginOrRegister(autoLogin: false),
      ),
    ]);

    await tester.pumpWidget(ChangeNotifierProvider(
      create: (context) => GameStateViewModel(),
      child: MaterialApp.router(
        routerConfig: router,
      ),
    ));

    when(userAuth.signOut()).thenAnswer((_) => Future.value(true));

    expect(find.text("Logout"), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
    final logoutButton = find.byType(ElevatedButton);
    await tester.tap(logoutButton);
    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);
    expect(find.text("Login"), findsOneWidget);
  });
}
