import 'package:chimp_game/styles.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/monkey-banana.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: large * 2),
                Text("CHIMP GAME", textAlign: TextAlign.center, style: heading4),
                SizedBox(height: large * 4),
                ElevatedButton(
                  onPressed: () {
                    context.pushNamed("difficulty_page");
                  },
                  style: ButtonStyle(
                    minimumSize:
                        MaterialStateProperty.all(Size(large * 6, large * 2)),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(orange),
                  ),
                  child:
                      Text("PLAY", textAlign: TextAlign.center, style: heading3),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
