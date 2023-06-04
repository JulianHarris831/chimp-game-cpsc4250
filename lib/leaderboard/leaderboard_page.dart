import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'player_account.dart';
import '../styles.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/yoshi_orange.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        height: MediaQuery.of(context).size.height - 70,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding:
                  EdgeInsets.only(left: medium, top: medium, right: medium),
              child: Column(
                children: [
                  const LeaderboardHeading(),
                  SizedBox(height: small),
                  const FirestoreLeaderboard()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FirestoreLeaderboard extends StatefulWidget {
  const FirestoreLeaderboard({Key? key}) : super(key: key);

  @override
  _FirestoreLeaderboardState createState() => _FirestoreLeaderboardState();
}

class _FirestoreLeaderboardState extends State<FirestoreLeaderboard> {
  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('Players');
  List<Player> players = [];

  void loadPlayers(AsyncSnapshot<QuerySnapshot<Object?>> snapshot) {
    snapshot.data!.docs.forEach((document) {
      String playerId = document.id;
      Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      String nickname = data['nickname'] as String;
      int highScore = data['highscore'] as int;
      Player player = Player(playerId, highScore, nickname);
      players.add(player);
    });

    sortPlayersByHighScoreAndNickname();
  }

  void sortPlayersByHighScoreAndNickname() {
    players.sort((a, b) {
      int scoreComparison = b.highScore.compareTo(a.highScore);
      if (scoreComparison != 0) {
        return scoreComparison;
      } else {
        return a.nickname.compareTo(b.nickname);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: playersCollection.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading data: ${snapshot.error}');
        } else {
          loadPlayers(snapshot);
          const Duration(seconds: 3);
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 255,
                width: 500,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: ListView(
                  children: [
                    SizedBox(height: small),
                    const ListHeader(),
                    Divider(color: black, height: small, thickness: 1),
                    for (int i = 0; i < players.length; i++)
                      Column(
                        children: [
                          PlayerDisplay(
                            player: players[i],
                            index: i,
                          ),
                          SizedBox(height: xsmall / 2)
                        ],
                      )
                  ],
                ),
              ),
              Text(
                'Players count: ${snapshot.data!.docs.length}',
                style: heading0,
              ),
            ],
          );
        }
      },
    );
  }
}

class PlayerDisplay extends StatelessWidget {
  PlayerDisplay({
    super.key,
    required this.player,
    required this.index,
  });

  Player player;
  int index;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (player.playerId == user?.uid) {
      return Container(
        color: blue,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Container(
              width: 50,
              child: Text((index + 1).toString(), style: heading0),
            ),
            Container(
              width: 130,
              child: Text(player.nickname, style: heading0),
            ),
            Container(
              width: 90,
              child: Text(player.highScore.toString(), style: heading0),
            ),
          ],
        ),
      );
    } else {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 50,
            child: Text((index + 1).toString(), style: heading0),
          ),
          Container(
            width: 130,
            child: Text(player.nickname, style: heading0),
          ),
          Container(
            width: 90,
            child: Text(player.highScore.toString(), style: heading0),
          ),
        ],
      );
    }
  }
}

class LeaderboardHeading extends StatelessWidget {
  const LeaderboardHeading({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        SizedBox(width: small),
        Text("Leaderboard", style: heading3),
        const Icon(Icons.leaderboard, size: 25),
        SizedBox(width: small),
      ],
    );
  }
}

class ListHeader extends StatelessWidget {
  const ListHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 50,
          child: Text("Rank", style: heading0),
        ),
        Container(
          width: 130,
          child: Text("Nickname", style: heading0),
        ),
        Container(
          width: 90,
          child: Text("Highscore", style: heading0),
        ),
      ],
    );
  }
}
