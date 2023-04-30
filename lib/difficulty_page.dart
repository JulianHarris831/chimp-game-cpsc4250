import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'game_page.dart';
import 'game_state_view_model.dart';
//need to start using viewModels. we can talk about the best setup,
//then I can do the code from there.

//Pick a difficulty, then navigate to another page, GamePage with the difficulty argument
//At GamePage, display a different sized grid depending on difficulty, in the future
//We will also have time to memorize settings with difficulty.

//change name to DifficultyPage
class DifficultyPage extends StatelessWidget {
  const DifficultyPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gameStateViewModel = context.watch<GameStateViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Level ${gameStateViewModel.getGameState.getCurrentLevel}"),
      ),
      body: Column (
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /*
          SizedBox(
            width: 300.0,
            height: 50.0,
            child: ElevatedButton.icon(
                onPressed: () {
                  //call viewModel, set to easy
                  //call game_page (after difficulty set)
                }, //navigation happens here!
                icon: Icon(
                  Icons.directions_run,
                  size: 24.0,
                ),
              label: Text("Easy"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height:30),
          SizedBox(
            width: 300.0,
            height: 50.0,
            child: ElevatedButton.icon(
              onPressed: () {
              },
              icon: Icon(
                Icons.directions_bike,
                size: 24.0,
              ),
              label: Text("Medium"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orangeAccent,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height:30),
          SizedBox(
            width: 300.0,
            height: 50.0,
            child: ElevatedButton.icon(
              onPressed: () {}, //navigation happens here!
              icon: Icon(
                Icons.directions_car,
                size: 24.0,
              ),
              label: Text("Hard"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
            ),
          ),
           */
          Expanded(child: GamePage()),
        ],
      ),
    );
  }
}
