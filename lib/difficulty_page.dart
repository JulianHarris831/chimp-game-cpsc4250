import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
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

  _onDifficultyChosen(BuildContext context, String difficulty) {
    final gameStateViewModel = context.read<GameStateViewModel>();
    gameStateViewModel.setDifficulty(difficulty);
    gameStateViewModel.initializeGame();

    context.pushNamed("game_page");
    //Navigator.push(context,
    //    MaterialPageRoute(builder: (context) => const GamePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Choose your Difficulty"),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/monkey-pipe.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: [
              const SizedBox(height:66),
              SizedBox(
                width: 300.0,
                height: 100.0,
                child: ElevatedButton.icon( //focus on implementing 3x3 game first
                    onPressed: () { _onDifficultyChosen(context, "Easy"); },
                    icon: const Icon(
                      Icons.directions_run,
                      size: 24.0,
                    ),
                  label: const Text("Easy"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height:30),
              SizedBox(
                width: 300.0,
                height: 100.0,
                child: ElevatedButton.icon(
                  onPressed: () { _onDifficultyChosen(context, "Medium"); },
                  icon: const Icon(
                    Icons.directions_bike,
                    size: 24.0,
                  ),
                  label: const Text("Medium"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height:30),
              SizedBox(
                width: 300.0,
                height: 100.0,
                child: ElevatedButton.icon(
                  onPressed: () { _onDifficultyChosen(context, "Hard"); },
                  icon: const Icon(
                    Icons.directions_car,
                    size: 24.0,
                  ),
                  label: const Text("Hard"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ),
              //Expanded(child: GamePage()),
            ],
          ),
        ),
      ),
    );
  }
}
