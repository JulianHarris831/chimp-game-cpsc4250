//import 'package:chimp_game/game_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chimp_game/game_state_view_model.dart';

main() {
  group('GameStateViewModel', () {
    group('setDifficulty', () {
      test('Setting difficulty updates a String in the view model.', () {
        final viewModel = GameStateViewModel();
        const difficulty = 'easy';

        viewModel.setDifficulty(difficulty);

        expect(viewModel.getGameState.getDifficultyChosen, difficulty);
      });
      test('Difficulty is not case sensitive and gets updated properly either way', () {
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
      expect(viewModel.getGameState.getPlayerSequenceIndex, equals(0));
      expect(viewModel.getGameState.getPressed, isNotNull);
      expect(viewModel.getGameState.getPressed!.length, equals(viewModel.getGameState.getGridSize));
      });
      //additional initializeGame testing
    });

    group('reset', () {
      test('reset should reset the game state to that of a new game with same settings', () {
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
        expect(viewModel.getGameState.getPressed!.length, equals(viewModel.getGameState.getGridSize));
      });
    });
  });
}
