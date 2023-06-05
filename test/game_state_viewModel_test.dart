//import 'package:chimp_game/game_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:chimp_game/game_state_view_model.dart';
import 'package:screenshot/screenshot.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';

typedef Callback = void Function(MethodCall call);

void setupFirebaseAuthMocks([Callback? customHandlers]) {
  TestWidgetsFlutterBinding.ensureInitialized();

  setupFirebaseCoreMocks();
}

void main() async {
  setupFirebaseAuthMocks();
  setUpAll(() async {
    await Firebase.initializeApp();
  });

  void callbackDecoy(bool value) {
    bool decoy = value;
  }

  group('GameStateViewModel', () {
    group('setDifficulty', () {
      test('Setting difficulty updates a String in the view model.', () {
        final viewModel = GameStateViewModel();
        const difficulty = 'easy';

        viewModel.setDifficulty(difficulty);

        expect(viewModel.getGameState.getDifficultyChosen, difficulty);
      });
      test(
          'Difficulty is not case sensitive and gets updated properly either way',
          () {
        final viewModel = GameStateViewModel();
        const difficulty = 'EASY';
        const expectedResult = 'easy';

        viewModel.setDifficulty(difficulty);

        expect(viewModel.getGameState.getDifficultyChosen, expectedResult);
      });
      //additional setDifficulty tests go here
    });

    group('initializeGame', () {
      test('initializeGame should set default values based on difficulty', () {
        final viewModel = GameStateViewModel();

        viewModel.setDifficulty('easy'); //already tested above
        viewModel.initializeGame();

        //everything that initializedGame sets for easy is verified here
        expect(viewModel.getGameState.getStarted, isFalse);
        expect(viewModel.getGameState.getCurrentLevel, equals(1));
        expect(viewModel.getGameState.getCurrentLives, equals(3));
        expect(viewModel.getGameState.getScores, equals(0));
        expect(viewModel.getGameState.getFadeTime, equals(3));
        expect(viewModel.getGameState.getStartTime, isNotNull);
        expect(viewModel.getGameState.getMaxSequence, equals(9));
        expect(viewModel.getGameState.getNumSequence, equals(3));
        expect(viewModel.getGameState.getMinFadeTime, equals(1));
        expect(viewModel.getGameState.getPlayerSequenceIndex, equals(0));
        expect(viewModel.getGameState.getPressed, isNotNull);
        expect(viewModel.getGameState.getPressed!.length,
            equals(viewModel.getGameState.getGridSize));
      });
      //additional initializeGame testing
    });

    group('reset', () {
      test(
          'reset should reset the game state to that of a new game with same settings',
          () {
        final viewModel = GameStateViewModel();

        //to further test this, we ought to modify more before calling reset!

        viewModel.setDifficulty('easy');
        viewModel.initializeGame();
        viewModel.reset();

        //everything for resets defaults
        expect(viewModel.getGameState.getStarted, isFalse);
        expect(viewModel.getGameState.getCurrentLevel, equals(1));
        expect(viewModel.getGameState.getCurrentLives, equals(3));
        expect(viewModel.getGameState.getScores, equals(0));
        expect(viewModel.getGameState.getPlayerSequenceIndex, equals(0));
        expect(viewModel.getGameState.getPressed, isNotNull);
        expect(viewModel.getGameState.getPressed!.length,
            equals(viewModel.getGameState.getGridSize));
      });
      test('test reset for medium resets to the proper numSequence', () {
        final viewModel = GameStateViewModel();

        viewModel.setDifficulty('medium');
        viewModel.initializeGame();
        viewModel.reset();

        // verify that numSequence properly resets to medium's 4
        expect(viewModel.getGameState.getNumSequence, equals(4));
      });
      test('test reset for hard resets to the proper numSequence', () {
        final viewModel = GameStateViewModel();

        viewModel.setDifficulty('hard');
        viewModel.initializeGame();
        viewModel.reset();

        // verify that numSequence properly resets to hard mode's 5
        expect(viewModel.getGameState.getNumSequence, equals(5));
      });
    });

    group('refresh', () {
      test('refresh should refresh the game state sequence and player index',
          () {
        final viewModel = GameStateViewModel();

        //to further test this, we ought to modify more before calling refresh!

        viewModel.setDifficulty('easy');
        viewModel.initializeGame();
        viewModel.refresh();

        //check game state sequence refreshes
        expect(viewModel.getGameState.getStarted, isFalse);
        expect(viewModel.getGameState.getPlayerSequenceIndex, equals(0));
        expect(viewModel.getGameState.getPressed, isNotNull);
        expect(viewModel.getGameState.getPressed!.length,
            equals(viewModel.getGameState.getGridSize));
      });
    });

    group('onButtonPressed', () {
      test(
          'pressing the correct sequence for the first time should set started',
          () {
        final viewModel = GameStateViewModel();

        viewModel.setDifficulty('easy');
        viewModel.initializeGame();

        // Verify that started is initially false
        expect(viewModel.getGameState.getStarted, isFalse);

        // Find the correct gridKey and press the correct sequence
        int gridKey = viewModel.sequence!.keys
            .firstWhere((k) => viewModel.sequence![k] == 1, orElse: () => null);
        viewModel.onButtonPressed(gridKey);

        // Verify that started is set to true
        expect(viewModel.getGameState.getStarted, isTrue);
      });
      test(
          'pressing the correct sequence should addToScores and update player index',
          () {
        final viewModel = GameStateViewModel();

        viewModel.setDifficulty('easy');
        viewModel.initializeGame();

        // Verify that the score and player sequence index is initially 0
        expect(viewModel.getGameState.getScores, equals(0));
        expect(viewModel.getGameState.getPlayerSequenceIndex, equals(0));

        // Find the correct gridKey and press the correct sequence
        int gridKey = viewModel.sequence!.keys
            .firstWhere((k) => viewModel.sequence![k] == 1, orElse: () => null);
        viewModel.onButtonPressed(gridKey);

        // Verify that the score and player sequence index updates
        expect(viewModel.getGameState.getScores, equals(10));
        expect(viewModel.getGameState.getPlayerSequenceIndex, equals(1));
      });
      test(
          'pressing the correct sequence on medium should have 2x score multiplier',
          () {
        final viewModel = GameStateViewModel();

        // Set the game difficulty to medium
        viewModel.setDifficulty('medium');
        viewModel.initializeGame();

        // Verify that score is initially 0
        expect(viewModel.getGameState.getScores, equals(0));

        // Find the correct gridKey and press the correct sequence
        int gridKey = viewModel.sequence!.keys
            .firstWhere((k) => viewModel.sequence![k] == 1, orElse: () => null);
        viewModel.onButtonPressed(gridKey);

        // Verify that the score updates to 20 (10 * 1 * 2)
        expect(viewModel.getGameState.getScores, equals(20));
      });
      test(
          'pressing the correct sequence on hard should have 3x score multiplier',
          () {
        final viewModel = GameStateViewModel();

        // Set the game difficulty to hard
        viewModel.setDifficulty('hard');
        viewModel.initializeGame();

        // Verify that score is initially 0
        expect(viewModel.getGameState.getScores, equals(0));

        // Find the correct gridKey and press the correct sequence
        int gridKey = viewModel.sequence!.keys
            .firstWhere((k) => viewModel.sequence![k] == 1, orElse: () => null);
        viewModel.onButtonPressed(gridKey);

        // Verify that the score updates to 20 (10 * 1 * 3)
        expect(viewModel.getGameState.getScores, equals(30));
      });
      test(
          'pressing the wrong sequence should remove life and refresh game state',
          () {
        final viewModel = GameStateViewModel();

        viewModel.setDifficulty('easy');
        viewModel.initializeGame();

        // Verify that the lives start at 3
        expect(viewModel.getGameState.getCurrentLives, equals(3));

        // Find the false gridKey and press the wrong sequence
        int falseGridKey = viewModel.sequence!.keys
            .firstWhere((k) => viewModel.sequence![k] == 2, orElse: () => null);
        viewModel.onButtonPressed(falseGridKey);

        // Verify that a life is lost due to pressing the wrong sequence
        expect(viewModel.getGameState.getCurrentLives, equals(2));
      });
    });

    group('viewModel getters', () {
      test('check all getters when a gameState viewModel is instantiated', () {
        final viewModel = GameStateViewModel();

        viewModel.setDifficulty('easy');
        viewModel.initializeGame();

        // Verify all getters
        expect(viewModel.getGameState, isNotNull);
        expect(viewModel.started, isFalse);
        expect(viewModel.level, equals('Level 1'));
        expect(viewModel.fadeTime, equals(3));
        expect(viewModel.startTime, isNotNull);
        expect(viewModel.lives, equals(3));
        expect(viewModel.scores, equals(0));
        expect(viewModel.playerIndex, equals(0));
        expect(viewModel.gridSize, equals(9));
        expect(viewModel.numSequence, equals(3));
        expect(viewModel.sequence, isNotNull);
        expect(viewModel.pressed, isNotNull);
        expect(viewModel.difficulty, equals('easy'));
      });
    });

    group('update with BuildContext', () {
      testWidgets('test update with required BuildContext parameter',
          (tester) async {
        await tester
            .pumpWidget(MaterialApp(home: Material(child: Container())));
        final BuildContext context = tester.element(find.byType(Container));

        final viewModel = GameStateViewModel();
        final controller = ScreenshotController();

        viewModel.setDifficulty('easy');
        viewModel.test = true;
        viewModel.initializeGame();
        viewModel.update(context, controller, false, callbackDecoy);

        expect(viewModel.getGameState, isNotNull);
      });
      testWidgets('test update for going to the next level', (tester) async {
        await tester
            .pumpWidget(MaterialApp(home: Material(child: Container())));
        final BuildContext context = tester.element(find.byType(Container));

        final viewModel = GameStateViewModel();
        final controller = ScreenshotController();

        viewModel.setDifficulty('easy');
        viewModel.test = true;
        viewModel.initializeGame();

        // Verify initial level and states for 'easy' level 1
        expect(viewModel.level, equals('Level 1'));
        expect(viewModel.fadeTime, equals(3));
        expect(viewModel.numSequence, equals(3));

        // Press the 3 correct sequence to go to the next level
        int gridKey1 = viewModel.sequence!.keys
            .firstWhere((k) => viewModel.sequence![k] == 1, orElse: () => null);
        viewModel.onButtonPressed(gridKey1);
        viewModel.update(context, controller, false, callbackDecoy);

        int gridKey2 = viewModel.sequence!.keys
            .firstWhere((k) => viewModel.sequence![k] == 2, orElse: () => null);
        viewModel.onButtonPressed(gridKey2);
        viewModel.update(context, controller, false, callbackDecoy);

        int gridKey3 = viewModel.sequence!.keys
            .firstWhere((k) => viewModel.sequence![k] == 3, orElse: () => null);
        viewModel.onButtonPressed(gridKey3);
        viewModel.update(context, controller, false, callbackDecoy);

        // Verify that you go to the next level and game state is refreshed
        expect(viewModel.level, equals('Level 2'));
        expect(viewModel.fadeTime, isNot(equals(3)));
        expect(viewModel.numSequence, equals(4));
      });
      testWidgets('test update to game over pop-up alert', (tester) async {
        final viewModel = GameStateViewModel();

        await tester.pumpWidget(
            ChangeNotifierProvider<GameStateViewModel>.value(
                value: viewModel,
                child: MaterialApp(home: Material(child: Container()))));
        await tester.pumpAndSettle();

        final BuildContext context = tester.element(find.byType(Container));
        final controller = ScreenshotController();

        viewModel.setDifficulty('easy');
        viewModel.test = true;
        viewModel.initializeGame();
        await tester.pump(const Duration(seconds: 5));

        // Verify starting lives is at 3
        expect(viewModel.lives, equals(3));

        // Purposefully lose by pressing the wrong sequence 3x
        int falseKey = viewModel.sequence!.keys
            .firstWhere((k) => viewModel.sequence![k] == 2, orElse: () => null);
        viewModel.onButtonPressed(falseKey);
        viewModel.update(context, controller, false, callbackDecoy);
        expect(viewModel.lives, equals(2));

        falseKey = viewModel.sequence!.keys
            .firstWhere((k) => viewModel.sequence![k] == 2, orElse: () => null);
        viewModel.onButtonPressed(falseKey);
        viewModel.update(context, controller, false, callbackDecoy);
        expect(viewModel.lives, equals(1));

        falseKey = viewModel.sequence!.keys
            .firstWhere((k) => viewModel.sequence![k] == 2, orElse: () => null);
        viewModel.onButtonPressed(falseKey);
        viewModel.update(context, controller, false, callbackDecoy);
        expect(viewModel.lives, equals(0));
      });
    });

    group('updateLevel', () {
      test('calling updateLevel properly updates level and game state', () {
        final viewModel = GameStateViewModel();

        viewModel.setDifficulty('easy');
        viewModel.initializeGame();

        // Verify initial level and game state for level 1 easy
        expect(viewModel.level, 'Level 1');
        expect(viewModel.fadeTime, equals(3));
        expect(viewModel.numSequence, equals(3));

        // Go to next level; Level 2 easy
        viewModel.updateLevel();

        // Verify changes to level and game state
        expect(viewModel.level, 'Level 2');
        expect(viewModel.fadeTime, isNot(equals(3)));
        expect(viewModel.numSequence, equals(4));
      });
    });

    group('updateScore', () {
      test('calling updateScore properly adds to score based on calculation',
          () {
        final viewModel = GameStateViewModel();

        viewModel.setDifficulty('easy');
        viewModel.initializeGame();

        // Verify initial score as 0 and checks level and difficulty for multiplier
        expect(viewModel.scores, equals(0));
        expect(viewModel.level, equals('Level 1')); // x1 multiplier
        expect(viewModel.difficulty, equals('easy')); // x1 multiplier

        // addToScore calculation: base score(10) * lvMultiplier(x1) * difMultiplier(x1)
        viewModel.updateScore();

        // Verify changes to score adds properly based on calculation
        expect(viewModel.scores, equals(10));
      });
    });

    group('updateLives', () {
      test('calling updateLives properly removes a life when not dead yet', () {
        final viewModel = GameStateViewModel();

        viewModel.setDifficulty('easy');
        viewModel.initializeGame();

        // Verify initial lives to be 3
        expect(viewModel.lives, equals(3));

        // Call updateLives to remove current lives by 1
        viewModel.updateLives();

        // Verify changes to lives
        expect(viewModel.lives, equals(2));

        // Verify that lives cannot drop below 0
        viewModel.updateLives();
        expect(viewModel.lives, equals(1));
        viewModel.updateLives();
        expect(viewModel.lives, equals(0));
        viewModel.updateLives();
        expect(viewModel.lives, equals(0));
      });
    });

    group('timer and pause', () {
      testWidgets('calling timer checks pause function', (tester) async {
        final viewModel = GameStateViewModel();
        expect(viewModel.test, isFalse);

        // Verify initial fadeTime to be 3
        expect(viewModel.fadeTime, equals(3));

        // Call timer to check pause function
        viewModel.timer();
        await tester.pump(const Duration(seconds: 5));

        // Verify setStarted is called after 3 sec
        expect(viewModel.started, isTrue);
      });
    });
  });
}
