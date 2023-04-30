class GameState {
  int _currentLevel = 1;
  double _fadeTime = 3; // sequence fade time; time to memorize (in s)
  int _currentLives = 3;
  int _scores = 0;
  int _playerSequenceIndex = 0; // current index the player needs to taps

  // default value: 'easy' difficulty 3x3 GameState
  bool _started = false;
  String _difficultyChosen = 'easy'; // 'easy', 'medium', or 'hard'
  int _gridSize = 9; // based on _difficultyChosen
  int _maxSequence = 9; // based on _gridSize
  int _numSequence = 3; // sequence to memorize (increases with level)
  final double _minFadeTime = 1;

  Map? _randomSequence;
  List<bool>? _pressed;

  void setDifficultySettings(String difficultyChosen) {
    _difficultyChosen = difficultyChosen.toLowerCase();
  }

  void setStarted() { _started = true; }

  void initGameState() {
    _started = false; _currentLevel = 1;
    _fadeTime = 3; _currentLives = 3;
    _scores = 0; _playerSequenceIndex = 0;
    if (_difficultyChosen == 'easy') {
      _gridSize = 9; // 3 x 3
      _maxSequence = 9;
      _numSequence = 3; // starting sequence to memorize
    } else if (_difficultyChosen == 'medium') {
      _gridSize = 12; // 3 x 4
      _maxSequence = 12;
      _numSequence = 4;
    } else {
      _gridSize = 15; // 3 x 5
      _maxSequence = 15;
      _numSequence = 5;
    }
    generateRandomSequence();
    setPressed();
  }

  void resetGameState() {
    _currentLevel = 1; _fadeTime = 3;
    _currentLives = 3; _scores = 0;
    refreshGameState();
    // Try again with same difficulty settings
  }

  void refreshGameState() {
    _started = false;
    _playerSequenceIndex = 0;
    setPressed();
    generateRandomSequence(); // generate a new random sequence
    //user sequence needs to get reset here too
  }

  int get getCurrentLevel => _currentLevel;
  double get getFadeTime => _fadeTime;
  int get getCurrentLives => _currentLives;
  int get getScores => _scores;
  int get getPlayerSequenceIndex => _playerSequenceIndex;
  String get getDifficultyChosen => _difficultyChosen;
  bool get getStarted => _started;
  int get getGridSize => _gridSize;
  int get getMaxSequence => _maxSequence;
  int get getNumSequence => _numSequence;
  double get getMinFadeTime => _minFadeTime;
  Map? get getSequence => _randomSequence;
  List<bool>? get getPressed => _pressed;

  void nextLevel() {
    _currentLevel++;
    _fadeTime = _fadeTime * .95; // fadeTime decreases as level increases
    if (_fadeTime < _minFadeTime) _fadeTime = _minFadeTime;
    _numSequence = _numSequence + 1; // sequence to memorize increases w/ level
    if (_numSequence > _maxSequence) _numSequence = _maxSequence;
  }

  void addToScores() {
    int baseScore = 10; // Base score for choosing the correct square
    int levelMultiplier = _currentLevel;
    int difficultyMultiplier;
    if (_difficultyChosen == 'easy') {
      difficultyMultiplier = 1;
    } else if (_difficultyChosen == 'medium') {
      difficultyMultiplier = 2;
    } else {
      difficultyMultiplier = 3;
    }
    int scoreGained = baseScore * levelMultiplier * difficultyMultiplier;
    _scores += scoreGained;
  }

  void updatePlayerSequenceIndex() {
    _playerSequenceIndex++; // when the player taps the correct sequence index
  }

  void removeLife() {
    if (_currentLives > 0) _currentLives--;
  }

  // i.e. randomSeq = [7, 5, 4] in a '3 x 3' square grid =>
  // the following sequence is created: [_][_][_] # 0, 1, 2
  //                                    [_][3][2] # 3, 4, 5
  //                                    [_][1][_] # 6, 7, 8
  void generateRandomSequence() {
    // generate random sequence
    List<int> randomSequence = List.generate(_maxSequence, (i) => i);
    randomSequence.shuffle();
    randomSequence = randomSequence.take(_numSequence).toList();

    Map mapSequence = {};
    for(int i = 0; i < _numSequence; i++){
      mapSequence[randomSequence[i]] = i;
    }
    _randomSequence = mapSequence;
  }

  void setPressed() {
    List<bool> pressed = [];
    for(int i = 0; i < _maxSequence; i++){
      pressed.add(false);
    }
    _pressed = pressed;
  }
}