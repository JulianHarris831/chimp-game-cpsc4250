import 'package:chimp_game/firebase/firebase_options.dart';
import 'package:chimp_game/firebase/login_view.dart';
import 'package:chimp_game/firebase/register_view.dart';
import 'package:chimp_game/game_state_view_model.dart';
import 'package:chimp_game/home_page.dart';
import 'package:chimp_game/main_menu_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chimp_game/alerts.dart';
import 'package:go_router/go_router.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'login_view_test.mocks.dart';

// flutter test test/firebase/login_view_test.dart
// flutter pub run build_runner build

@GenerateMocks([
  FirebaseAuth,
  User,
  UserCredential,
  NavigatorObserver,
])
class MockFunctionCall extends Mock {
  //int check = 0;

  void mockDisplayErrorMsg(BuildContext context, String errorMsg) {
    //check++;
    displayErrorMsg(context, errorMsg);
  }
}

class MockBuildContext extends Mock implements BuildContext {}

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
  testWidgets("Login page generated", (tester) async {
    await tester.pumpWidget(MaterialApp(home: LoginView()));
    await tester.pump();

    expect(find.widgetWithText(TextField, "Enter your email here!"),
        findsOneWidget);
    expect(find.widgetWithText(TextField, "Enter your password here!"),
        findsOneWidget);

    expect(find.widgetWithText(TextButton, "Login"), findsOneWidget);
    expect(find.byType(LoginView), findsOneWidget);
    expect(find.widgetWithText(ElevatedButton, "Continue as Guest"),
        findsOneWidget);
  });

  testWidgets("LoginView() can navigate to RegisterView()", (tester) async {
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
  });

  testWidgets(
      "LoginView() can navigate to MyHomePage() with valid Login information",
      (tester) async {
    MockFirebaseAuth firebaseAuth = MockFirebaseAuth();
    MockUser user = MockUser();
    MockUserCredential userCredential = MockUserCredential();

    //when(firebaseAuth.currentUser).thenReturn(user);
    when(firebaseAuth.signInWithEmailAndPassword(
            email: anyNamed('email'), password: anyNamed('password')))
        .thenAnswer((_) async => userCredential);

    await Duration(seconds: 2);

    await tester.pumpWidget(MaterialApp(
      home: const LoginView(),
      routes: {
        '/homepage1/': (context) => const MyHomePage(pageIndex: 0),
      },
    ));

    // Enter valid email and password
    final emailField = find.widgetWithText(TextField, "Enter your email here!");
    final passwordField =
        find.widgetWithText(TextField, "Enter your password here!");
    final loginButton = find.widgetWithText(TextButton, "Login");
    await tester.enterText(emailField, "test1@gmail.com");
    await tester.enterText(passwordField, "123456");
    await tester.pump();

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.byType(MyHomePage), findsOneWidget);
    //expect(find.byType(LoginView), findsOneWidget);
  });

  //THIS METHOD BELOW DOES NOT WORK YET
/*
  testWidgets(
      "LoginView() can navigate to MyHomePage() with valid Login information",
      (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: LoginView(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ));

    // Enter valid email and password
    final emailField = find.widgetWithText(TextField, "Enter your email here!");
    final passwordField =
        find.widgetWithText(TextField, "Enter your password here!");
    final loginButton = find.widgetWithText(TextButton, "Login");
    await tester.enterText(emailField, "test1@gmail.com");
    await tester.enterText(passwordField, "123456");
    await Duration(milliseconds: 200);

    await tester.tap(loginButton);
    await tester.pumpAndSettle();

    expect(find.text('CHIMP GAME'), findsOneWidget);
    expect(find.byType(MyHomePage), findsOneWidget);
    expect(find.byType(BottomNavigationBar), findsOneWidget);
    expect(find.byIcon(Icons.home), findsOneWidget);
    expect(find.byIcon(Icons.settings), findsOneWidget);
    expect(find.byIcon(Icons.logout), findsOneWidget);
  });
  */
  //THIS METHOD BELOW DOES NOT WORK YET
  /*
  testWidgets(
      "making sure displayErrorMsg() is called, when login information is invalid",
      (tester) async {
    print("3");
    final MockBuildContext mockContext = MockBuildContext();
    final MockFunctionCall mockFunction = MockFunctionCall();
    print("4");
    await tester.pumpWidget(
      MaterialApp(
        title: 'Chimp Game',
        routes: {
          '/login/': (context) => const LoginView(),
          '/register/': (context) => const RegisterView(),
        },
        home: FutureBuilder(
          future: Firebase.initializeApp(
            options: DefaultFirebaseOptions.currentPlatform,
          ),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                return const LoginView();
              default:
                return const Text('Loading...');
            }
          },
        ),
      ),
    );
    await tester.pump();
    print("5");

    await tester.enterText(find.byType(TextField).at(0), 'invalid@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'invalid_password');
    print("6");

    expect(find.widgetWithText(TextButton, "Login"), findsOneWidget);
    await tester.pump(Duration(seconds: 1));
    await tester.tap(find.widgetWithText(TextButton, "Login"));
    await tester.pumpAndSettle(Duration(seconds: 2));
    print("7");

    // await untilCalled(
    //     mockFunction.mockDisplayErrorMsg(context, 'User not found!'));
    print("8");
    verify(mockFunction.mockDisplayErrorMsg(mockContext, 'User not found!'))
        .called(1);
    //mockFunction.mockDisplayErrorMsg(mockContext, 'User not found!');
    //expect(mockFunction.check, 1);
    print("9");
  });
  */
}
