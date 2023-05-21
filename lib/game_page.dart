import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:screenshot/screenshot.dart';
import 'package:go_router/go_router.dart';

import 'game_state_view_model.dart';
import 'home_page.dart';
import 'styles.dart';
//continue integrating viewModels here!

class GamePage extends StatefulWidget {
  const GamePage({Key? key}) : super(key: key);

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final _controller = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    final gameStateViewModel = context.watch<GameStateViewModel>();

    return Screenshot(
      controller: _controller,
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: Text('CHIMP GAME: ${gameStateViewModel.level}')),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              icon: const Icon(Icons.home),
              tooltip: 'Home',
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context); //pushing back to home
                //Navigator.pushReplacement(context, MaterialPageRoute(
                //    builder: (context) => const MyHomePage(pageIndex: 0))
                //);
              }
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      margin: const EdgeInsets.only(right: 30),
                      child: Text(
                          'Score: ${gameStateViewModel.scores}', style: heading3)
                  ),
                  Text('Lives: ', style: heading2),
                  for (int i = 0; i < gameStateViewModel.lives; i++)
                    const Icon(Icons.favorite, size: 30, color: Colors.red),
                  for (int i = 0; i < (3 - gameStateViewModel.lives); i++)
                    const Icon(Icons.heart_broken, size: 30, color: Colors.grey),
                ],
              ),
              const SizedBox(height: 20),
              GridView.count(
                shrinkWrap: true,
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                crossAxisCount: 3,
                children: List.generate(gameStateViewModel.gridSize, (index) {
                  if (index < gameStateViewModel.gridSize) {
                    return ElevatedButton(
                      onPressed: () {
                        gameStateViewModel.onButtonPressed(index);
                        gameStateViewModel.update(context, _controller);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        (gameStateViewModel.difficulty == 'easy') ? Colors.green
                            : (gameStateViewModel.difficulty == 'medium') ? Colors.orangeAccent
                            : Colors.red //if(gameStateViewModel.difficulty == 'hard')
                      ),
                      child: (gameStateViewModel.pressed![index] || (!gameStateViewModel.started)) //&& !gameStateViewModel.timeUp))
                        ? gameStateViewModel.sequence!.containsKey(index)
                          ? Text('${gameStateViewModel.sequence![index]}', style: heading5)
                          : const SizedBox()
                        : const SizedBox(),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}