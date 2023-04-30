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
    _gameState.setStarted();
    pressed![index] = true;
    notifyListeners();
  }

  GameState get getGameState => _gameState;
  bool get started => _gameState.getStarted;
  String get level => 'Level ${_gameState.getCurrentLevel}';
  double get fadeTime => _gameState.getFadeTime;
  int get lives => _gameState.getCurrentLives;
  int get scores => _gameState.getScores;
  Map? get sequence => _gameState.getSequence;
  List<bool>? get pressed => _gameState.getPressed;

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