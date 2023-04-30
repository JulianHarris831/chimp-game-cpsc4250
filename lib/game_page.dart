import 'package:chimp_game/game_state_view_model.dart';
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
  //TODO: Move these vars into a viewModel for game_state.
  //final int gridSize = 3;
 //this is always 3, 4, or 5 w/the current game
  //final int sequenceSize = 4; == .numSequence
 //starts at 4, 5, or 6, but increments!
  //final Map sequence = {5:1, 3:2, 1:3, 6:4}; == .randomSequence

  //even after doing all that above stuff, only display it if this bool is true
  final List<bool> pressed = [false, false, false, false, false, false, false, false, false];

  //started determines whether the numbers not pressed hide themselves. if false, visible.
  bool started = false;

  @override
  Widget build(BuildContext context) {
    final gameStateViewModel = context.watch<GameStateViewModel>();
    gameStateViewModel.setDifficulty('easy');
    gameStateViewModel.initializeGame();
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: GridView.count(
          shrinkWrap: true, //does nothing?
          mainAxisSpacing: 10.0,
          crossAxisSpacing: 10.0,
          crossAxisCount: 3,
          //How can I have a dynamic number of children here? I want 9, 12, and 15.
          children: List.generate(gridSize * gridSize, (index) {
            if (index < gridSize * 3) {
              return ElevatedButton(
                onPressed: () {
                  setState(() {
                    pressed[index] = true;
                    started = true;
                  });
                },
                //index should be the position of index in sequence. use a map?
                child: (pressed[index] || !started) ? Text('${sequence[index]}') : const SizedBox(),
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