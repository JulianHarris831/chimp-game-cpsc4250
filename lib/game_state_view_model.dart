import 'package:chimp_game/alerts.dart';
import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import 'game_state.dart';
import 'dart:io';

class GameStateViewModel extends ChangeNotifier {
  final _gameState = GameState();
  bool test = false;

  void setDifficulty(String difficultyChosen) {
    _gameState.setDifficultySettings(difficultyChosen);
    notifyListeners();
  }

  Future<double> pause() async {
    //double elapsed = _gameState.getStartTime.difference(DateTime.now()).inSeconds.abs().toDouble();
    final millTime = (fadeTime*1000).round();
    await Future.delayed(Duration(milliseconds: millTime));
    return fadeTime;
  }
  void timer() async{
    if (!test) {
      //UUID is our startTime. This could be improved to something more unique!
      double startFade = fadeTime; //this needs to be set every time timer is run!
      await pause();
      //This only seems to run one time. Is fadeTime set one time and just never again?
      if (startFade == fadeTime) {
        _gameState.setStarted();
        notifyListeners();
      }
    }
  }

  void initializeGame() {
    _gameState.initGameState();
    timer();
    notifyListeners();
  }

  void reset() {
    _gameState.resetGameState();
    timer();
    notifyListeners();
  }

  void refresh() {
    _gameState.refreshGameState();
    timer();
    notifyListeners();
  }

  void onButtonPressed(int index){
    if (!started) { _gameState.setStarted(); }
    if (!pressed![index]) {
      pressed![index] = true;
      if (sequence!.containsKey(index) && playerIndex == sequence![index]-1) {
        print('Player taps on the correct square: $playerIndex Add scores..');
        _gameState.addToScores();
        _gameState.updatePlayerSequenceIndex();
      }
      else {
        _gameState.removeLife();
        refresh();
        print('Player taps on the wrong square. Refreshing game state..');
      }
    }
    notifyListeners();
  }

  void update(BuildContext context, ScreenshotController controller) {
    print('player index: $playerIndex; correct sequence required $numSequence');
    if (playerIndex >= numSequence) {
      _gameState.nextLevel();
      refresh();
    }
    else if (lives == 0) {
      displayGameOver(context, controller);
    }
    notifyListeners();
  }

  GameState get getGameState => _gameState;
  bool get started => _gameState.getStarted;
  String get level => 'Level ${_gameState.getCurrentLevel}';
  double get fadeTime => _gameState.getFadeTime;
  DateTime get startTime => _gameState.getStartTime;
  int get lives => _gameState.getCurrentLives;
  int get scores => _gameState.getScores;
  int get playerIndex => _gameState.getPlayerSequenceIndex;
  int get gridSize => _gameState.getGridSize;
  int get numSequence => _gameState.getNumSequence;
  Map? get sequence => _gameState.getSequence;
  List<bool>? get pressed => _gameState.getPressed;
  String get difficulty => _gameState.getDifficultyChosen;
  //double get elapsed => _gameState.getStartTime.difference(DateTime.now()).inSeconds.abs().toDouble();

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