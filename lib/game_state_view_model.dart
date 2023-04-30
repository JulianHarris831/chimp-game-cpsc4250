import 'package:chimp_game/alerts.dart';
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

  void refresh() {
    _gameState.refreshGameState();
    notifyListeners();
  }

  void onButtonPressed(int index){
    if (!started) { _gameState.setStarted(); }
    if (!pressed![index]) {
      pressed![index] = true;
      if (playerIndex == sequence![index]) {
        print('Player taps on the correct square: $playerIndex Add scores..');
        _gameState.addToScores();
        _gameState.updatePlayerSequenceIndex();
      }
      else {
        _gameState.removeLife();
        _gameState.refreshGameState();
        print('Player taps on the wrong square. Resetting game state..');
      }
    }
    //also need to verify lost lives and stuff!
    notifyListeners();
  }

  void update(BuildContext context) {
    print('player index: $playerIndex; correct sequence required $numSequence');
    if (playerIndex >= numSequence) {
      _gameState.nextLevel();
      _gameState.refreshGameState();
    }
    else if (lives == 0) {
      displayGameOver(context);
      // display game over pop-up alert
    }
    notifyListeners();
  }

  GameState get getGameState => _gameState;
  bool get started => _gameState.getStarted;
  String get level => 'Level ${_gameState.getCurrentLevel}';
  double get fadeTime => _gameState.getFadeTime;
  int get lives => _gameState.getCurrentLives;
  int get scores => _gameState.getScores;
  int get playerIndex => _gameState.getPlayerSequenceIndex;
  int get gridSize => _gameState.getGridSize;
  int get numSequence => _gameState.getNumSequence;
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