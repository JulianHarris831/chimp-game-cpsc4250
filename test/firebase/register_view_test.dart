import 'package:chimp_game/firebase/firebase_options.dart';
import 'package:chimp_game/firebase/login_view.dart';
import 'package:chimp_game/firebase/register_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chimp_game/alerts.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

// flutter test test/firebase/register_view_test.dart

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

void main() async {
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
    expect(find.widgetWithText(ElevatedButton, "Continue as Guest"),
        findsOneWidget);
  });

  testWidgets("RegisterView() can navigate to LoginView()", (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: RegisterView(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ));
    await tester.pump();

    expect(find.text('Click here to login!'), findsOneWidget);
    await tester.tap(find.text('Click here to login!'));
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
