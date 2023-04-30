import 'package:flutter/material.dart';
import 'game_state.dart';

class GameStateViewModel extends ChangeNotifier {
  final _gameState = GameState();

  void setDifficulty(String difficultyChosen) {
    _gameState.setDifficultySettings(difficultyChosen);
    notifyListeners();
  }

  void initializeGame() {
    _gameState.initGameState();
    notifyListeners();
  }

  void reset() {
    _gameState.resetGameState();
    notifyListeners();
  }

  void onButtonPressed(int index){
    //also need to verify lost lives and stuff!
    _gameState.pressed![index] = true;
    _gameState.setStarted();
    notifyListeners();
  }

  GameState get getGameState => _gameState;
  //List<int> get generateSequence => _gameState.generateRandomSequence();
  Map get getSequence => _gameState.sequence!;
  List<bool> get getPressed => _gameState.pressed!;
  bool get started => _gameState.getStarted;

  void updateLevel() {
    _gameState.nextLevel();
    notifyListeners();
  }

  void updateScore() {
    _gameState.addToScores();
    notifyListeners();
  }

  void updateLives() {
    _gameState.removeLife();
    notifyListeners();
  }
}