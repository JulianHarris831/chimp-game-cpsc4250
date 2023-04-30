import 'package:chimp_game/difficulty_page.dart';
import 'package:chimp_game/styles.dart';
import 'package:flutter/material.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({super.key});

  @override
  State<MainMenuPage> createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: large * 4),
              Text("CHIMP GAME", textAlign: TextAlign.center, style: heading4),
              SizedBox(height: large * 2),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => const DifficultyPage()));
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
    );
  }
}
