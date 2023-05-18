import 'package:chimp_game/database/player_dao.dart';
import 'package:chimp_game/firebase/player_account.dart';
import 'package:flutter/material.dart';

import '../database/database.dart';

class PlayerViewModel extends ChangeNotifier {
  final List<Player> _playersList = [];
  bool _playersAreLoaded = false;

  final PlayerDatabase _database;

  PlayerViewModel(this._database);

  int get playerCount => _playersList.length;

  Player getPlayerAtIndex(int index) {
    return _playersList[index];
  }

  Future<void> loadPlayers() async {
    if (_playersAreLoaded) {
      return;
    }

    final PlayerDao playerDao = _database.playerDao;
    final players = await playerDao.getAllPlayers();

    _playersList.addAll(players);
    _playersList.sort((a, b) => a.highScore.compareTo(b.highScore));
    _playersAreLoaded = true;

    notifyListeners();
  }

  void addPlayer(Player player) async {
    final PlayerDao playerDao = _database.playerDao;

    await playerDao.insertPlayer(player);
    _playersList.add(player);
    _playersList.sort((a, b) => a.highScore.compareTo(b.highScore));

    notifyListeners();
  }

  void editPlayer(int index, Player player) async {
    final PlayerDao playerDao = _database.playerDao;
    await playerDao.deletePlayerById(_playersList[index].playerId);
    await playerDao.insertPlayer(player);
    _playersList.removeAt(index);
    _playersList.add(player);
    _playersList.sort((a, b) => a.highScore.compareTo(b.highScore));

    notifyListeners();
  }

  void deletePlayer(int index) async {
    final PlayerDao playerDao = _database.playerDao;
    await playerDao.deletePlayerById(_playersList[index].playerId);
    _playersList.removeAt(index);
    _playersList.sort((a, b) => a.highScore.compareTo(b.highScore));

    notifyListeners();
  }
}
