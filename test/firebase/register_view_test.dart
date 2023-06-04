import 'package:chimp_game/firebase/login_view.dart';
import 'package:chimp_game/firebase/register_view.dart';
import 'package:chimp_game/game_state_view_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

// flutter test test/firebase/register_view_test.dart

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
  testWidgets("Register page generated", (tester) async {
    await tester.pumpWidget(MaterialApp(home: RegisterView()));
    await tester.pump();

    expect(find.widgetWithText(TextField, "Enter your email here!"),
        findsOneWidget);
    expect(find.widgetWithText(TextField, "Enter your password here!"),
        findsOneWidget);

    expect(find.text("Profile Information: "), findsOneWidget);
    expect(find.widgetWithText(TextField, "Nickname"), findsOneWidget);

    expect(find.widgetWithText(TextButton, "Register"), findsOneWidget);
    expect(find.byType(RegisterView), findsOneWidget);
  });

  testWidgets(
      "Start from LoginView() to navigate to then test whether RegisterView() can navigate to LoginView()",
      (tester) async {
    final router = GoRouter(initialLocation: "/login_view", routes: [
      GoRoute(
        path: "/login_view",
        name: "login_view",
        builder: (context, state) => const LoginView(),
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
    await tester.pump();

    expect(find.text('Click here to register!'), findsOneWidget);
    await tester.tap(find.text('Click here to register!'));
    await tester.pumpAndSettle();

    expect(find.byType(RegisterView), findsOneWidget);
    final backButtonFinder = find.byTooltip('Back');
    expect(backButtonFinder, findsOneWidget);

    // Tap the back button
    await tester.tap(backButtonFinder);
    await tester.pumpAndSettle();

    expect(find.byType(LoginView), findsOneWidget);
  });

  //THIS METHOD BELOW DOES NOT WORK YET
  // testWidgets("Register page can navigate to Login page",
  //     (WidgetTester tester) async {
  //   await tester.pumpWidget(MaterialApp(
  //     routes: {
  //       '/login/': (context) => const LoginView(),
  //     },
  //     home: const RegisterView(),
  //   ));
  //   await tester.pump();

  //   final loginViewButton =
  //       find.widgetWithText(TextButton, 'Click here to login!');
  //   print(loginViewButton);
  //   // expect(loginViewButton, findsOneWidget);

  //   await tester.press(loginViewButton);
  //   await tester.pumpAndSettle();

  //   expect(find.widgetWithText(TextButton, 'Login'), findsOneWidget);
  //   //expect(find.byType(LoginView), findsOneWidget);
  // });
}
