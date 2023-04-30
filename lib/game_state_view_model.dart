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

  GameState get getGameState => _gameState;
  List<int> get generateSequence => _gameState.generateRandomSequence();

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