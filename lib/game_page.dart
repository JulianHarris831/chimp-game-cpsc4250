import 'game_state_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//use viewModels in the future

//TODO: Right now displaying gridView explodes everything, work that out!
//You've got some decent logic for the sizing though! 

class GamePage extends StatefulWidget {
  GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {

  @override
  Widget build(BuildContext context) {
    final gameStateViewModel = context.watch<GameStateViewModel>();
    gameStateViewModel.setDifficulty('easy');
    gameStateViewModel.initializeGame();
    gameStateViewModel.reset();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GridView.count(
          shrinkWrap: true, //does nothing?
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          crossAxisCount: 3,
          //How can I have a dynamic number of children here? I want 9, 12, and 15.
          children: List.generate(gameStateViewModel.getGameState.getGridSize!, (index) {
            if (index < gameStateViewModel.getGameState.getGridSize!) {
              return ElevatedButton(
                onPressed: () {
                  gameStateViewModel.onButtonPressed(index);
                },
                //index should be the position of index in sequence. use a map?
                child: (gameStateViewModel.getPressed[index] || gameStateViewModel.started) ? Text('${gameStateViewModel.getSequence[index]}') : const SizedBox(),
              );
            } else {
              return const SizedBox.shrink();
            }
          }),
        ),
      ),
    );
  }
}