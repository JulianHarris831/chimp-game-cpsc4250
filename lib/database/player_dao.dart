import 'package:floor/floor.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../firebase/player_account.dart';

@dao
abstract class PlayerDao {
  @Query("SELECT * FROM Player")
  Future<List<Player>> getAllPlayers();

  @Query('SELECT nickname FROM Player')
  Stream<List<String>> getAllNickname();

  @Query('SELECT * FROM Player WHERE nickname = :nickname')
  Stream<Player?> findPlayerByNickname(String nickname);

  @insert
  Future<void> insertPlayer(Player player);

  @delete
  Future<void> deletePlayer(Player player);

  @Query('DELETE FROM Player WHERE playerId = :playerId')
  Future<void> deletePlayerById(String playerId);
}
