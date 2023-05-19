import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

Future<bool> updateHighscoreByID(String playerId, int newscore) async {
  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('Players');

  try {
    DocumentSnapshot documentSnapshot =
        await playersCollection.doc(playerId).get();
    Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
    int currentHighScore = data['highscore'] as int;

    if (newscore > currentHighScore) {
      await playersCollection.doc(playerId).update({'highscore': newscore});
      print('Player high score updated successfully!');
      return true;
    }
  } catch (error) {
    print('Error updating player high score: $error');
  }

  return false;
}

void updateNicknameByID(String playerId, String newNickname) {
  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('Players');

  playersCollection
      .doc(playerId)
      .update({'nickname': newNickname}).then((value) {
    print("Nickname updated successfully!");
  }).catchError((error) {
    print("Failed to update nickname!: $error");
  });
}
