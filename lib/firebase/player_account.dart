import 'package:flutter/material.dart';
import 'package:floor/floor.dart';

@entity
class Player {
  @primaryKey
  String playerId;

  int highScore;
  String nickname;

  Player(this.playerId, this.highScore, this.nickname);
}
