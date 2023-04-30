import 'game_state_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//continue integrating viewModels here!

//TODO: Right now displaying gridView explodes everything, work that out!
//You've got some decent logic for the sizing though! 

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  @override
  Widget build(BuildContext context) {
    final gameStateViewModel = context.watch<GameStateViewModel>();

    //Needs to reset gameState whenever wrong sequence is pressed/level up
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('CHIMP GAME: ${gameStateViewModel.level}')),
        automaticallyImplyLeading: false,
      ),
      body: GridView.count(
        shrinkWrap: true, //does nothing?
        mainAxisSpacing: 10.0,
        crossAxisSpacing: 10.0,
        crossAxisCount: 3,
        //How can I have a dynamic number of children here? I want 9, 12, and 15.
        children: List.generate(9, (index) { //gameStateViewModel.getGameState.getGridSize!
          if (index < 9) { //gameStateViewModel.getGameState.getGridSize!
            return ElevatedButton(
              onPressed: () {
                //gameStateViewModel.onButtonPressed(index);
              },
              //index should be the position of index in sequence. use a map?
              child: SizedBox(),//(gameStateViewModel.getPressed[index] || gameStateViewModel.started) ? Text('${gameStateViewModel.getSequence[index]}') : const SizedBox(),
            );
          } else {
            return const SizedBox.shrink();
          }
        }),
      ),
    );
  }
}