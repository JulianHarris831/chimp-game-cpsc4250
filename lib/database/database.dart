import 'dart:async';
import 'package:chimp_game/database/player_dao.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import '../firebase/player_account.dart';

part "database.g.dart";

// flutter pub run build_runner build

@Database(version: 1, entities: [Player])
abstract class PlayerDatabase extends FloorDatabase {
  PlayerDao get playerDao;
}
