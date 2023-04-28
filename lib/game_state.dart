class GameState {
  int _currentLevel = 1;
  double _fadeTime = 3; // sequence fade time; time to memorize (in s)
  int _currentLives = 3;
  int _scores = 0;

  String? _difficultyChosen;
  String? _gridSize; // based on _difficultyChosen
  int? _maxSequence; // based on _gridSize
  int? _numSequence; // number of sequence to memorize (increases with level)
  final double _minFadeTime = 1;

  void setDifficulty(String difficultyChosen) {
    _difficultyChosen = difficultyChosen;
  }

  initGameState() {
    if (_difficultyChosen != null) {
      if (_difficultyChosen!.toLowerCase() == 'easy') {
        _gridSize = '3 x 3';
        _maxSequence = 9;
        _numSequence = 3; // starting sequence to memorize
      } else if (_difficultyChosen!.toLowerCase() == 'medium') {
        _gridSize = '3 x 4';
        _maxSequence = 12;
        _numSequence = 4;
      } else {
        _gridSize = '3 x 5';
        _maxSequence = 15;
        _numSequence = 5;
      }
    }
  }

  int get getCurrentLevel => _currentLevel;
  double get getFadeTime => _fadeTime;
  int get getCurrentLives => _currentLives;
  int get getScores => _scores;
  String? get getDifficultyChosen => _difficultyChosen;
  String? get getGridSize => _gridSize;
  int? get getMaxSequence => _maxSequence;
  int? get getNumSequence => _numSequence;
  double get getMinFadeTime => _minFadeTime;

  void nextLevel() {
    _currentLevel++;
    _fadeTime = _fadeTime * .8; // fadeTime decreases as level increases
    if (_fadeTime < _minFadeTime) _fadeTime = _minFadeTime;
    _numSequence = _numSequence! + 1; // sequence to memorize increases w/ level
    if (_numSequence! > _maxSequence!) _numSequence = _maxSequence;
  }

  void addToScores() {
    int baseScore = 10; // Base score for choosing the correct square
    int levelMultiplier = _currentLevel;
    int difficultyMultiplier;
    if (_difficultyChosen!.toLowerCase() == 'easy') {
      difficultyMultiplier = 1;
    } else if (_difficultyChosen!.toLowerCase() == 'medium') {
      difficultyMultiplier = 2;
    } else {
      difficultyMultiplier = 3;
    }
    int scoreGained = baseScore * levelMultiplier * difficultyMultiplier;
    _scores += scoreGained;
  }

  void removeLife() {
    if (_currentLives > 0) _currentLives--;
  }

  // i.e. randomSeq = [7, 5, 4] in a '3 x 3' square grid =>
  // the following sequence is created: [_][_][_] # 0, 1, 2
  //                                    [_][3][2] # 3, 4, 5
  //                                    [_][1][_] # 6, 7, 8
  List<int> generateRandomSequence() {
    // generate random sequence
    List<int> randomSequence = List.generate(_maxSequence!, (i) => i);
    randomSequence.shuffle();

    // return the number of sequence required for the current level
    return randomSequence.take(_numSequence!).toList();
  }
}