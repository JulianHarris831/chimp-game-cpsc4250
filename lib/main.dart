import 'package:chimp_game/firebase/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'firebase/login_view.dart';
import 'firebase/register_view.dart';
import 'main_menu_view.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //look at notes for more info 8:54:30
  await Firebase.initializeApp();

  // check which firebase server the app is connected to
  FirebaseApp app = Firebase.app();
  String projectId = app.options.projectId;

  if (projectId == 'my-project-id') {
    print('Firebase is connected to the production server');
  } else if (projectId == 'my-project-id-staging') {
    print('Firebase is connected to the staging server');
  } else {
    print('Firebase is connected to an unknown server');
  }
  print(projectId);
  runApp(
    MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginOrRegister(),
      routes: {
        '/login/': (context) => const LoginView(),
        '/register/': (context) => const RegisterView(),
      },
    ),
  );
}

class LoginOrRegister extends StatelessWidget {
  const LoginOrRegister({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
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
    );
    // ignore: dead_code
    ElevatedButton(
      child: const Text('Dont have an account? click here to register!'),
      onPressed: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const RegisterView())),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.pageIndex}) : super(key: key);
  final int pageIndex;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.pageIndex;
  }

  @override
  Widget build(BuildContext context) {
    Widget page;
    switch (selectedIndex) {
      case 0:
        page = MainMenuPage();
        break;
      case 1:
        page = EmptyPage();
        break;
      case 2:
        page = ProfilePage();
        break;
      default:
        throw UnimplementedError('No widget for $selectedIndex');
    }

    return LayoutBuilder(builder: (context, constraints) {
      return Scaffold(
        bottomNavigationBar: Container(
          height: 70,
          child: BottomNavigationBar(
            selectedItemColor: Colors.orange,
            unselectedItemColor: Colors.grey,
            backgroundColor: Colors.white,
            elevation: 0,
            type: BottomNavigationBarType.fixed,
            currentIndex: selectedIndex,
            onTap: (value) {
              setState(() {
                selectedIndex = value;
              });
            },
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.leaderboard),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: '',
              ),
            ],
          ),
        ),
        body: Container(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: page,
        ),
      );
    });
  }
}

class EmptyPage extends StatelessWidget {
  const EmptyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Text(
              "Leaderboard page, coming soon!",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
          ],
        ),
      ),
    );
  }
}
