import 'package:chimp_game/firebase/player_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../firebase/player_account.dart';
import '../styles.dart';

class LeaderboardPage extends StatelessWidget {
  LeaderboardPage({super.key});

  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('Players');

  void getPlayerBasedOnDocument() {
    FirebaseFirestore.instance
        .collection("Players")
        .doc("testPlayer1")
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        Object? data = documentSnapshot.data();
        print('Data: $data');
      } else {
        print('Document does not exist');
      }
    }).catchError((error) {
      print('Error retrieving document: $error');
    });
  }

  void getAllPlayers() {
    playersCollection.get().then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((DocumentSnapshot documentSnapshot) {
        Object? data = documentSnapshot.data();
        print('User data: $data');
      });
    });
  }

  int getCollectionSize() {
    FirebaseFirestore.instance
        .collection("Players")
        .get()
        .then((QuerySnapshot querySnapshot) {
      int size = querySnapshot.size;
      print('Collection size: $size');
      return size;
    }).catchError((error) {
      print('Error retrieving collection size: $error');
      return -1;
    });
    return -1;
  }

  @override
  Widget build(BuildContext context) {
    // final playerViewModel = context.watch<PlayerViewModel>();
    // playerViewModel.loadPlayers();
    print("build");
    getPlayerBasedOnDocument();
    print("build2");
    getAllPlayers();
    getCollectionSize();
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
                  //PlayersList(playerViewModel: playerViewModel)
                  FirestoreTest()
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class FirestoreTest extends StatefulWidget {
  FirestoreTest({Key? key}) : super(key: key);

  @override
  _FirestoreTestState createState() => _FirestoreTestState();
}

class _FirestoreTestState extends State<FirestoreTest> {
  CollectionReference playersCollection =
      FirebaseFirestore.instance.collection('Players');
  List<Player> players = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    try {
      players = await getAllPlayersSortedByHighScore();
      setState(() {});
    } catch (error) {
      print('Error loading data: $error');
    }
  }

  Future<int> getCollectionSize() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("Players").get();
    int size = querySnapshot.size;
    print('Collection size: $size');
    return size;
  }

  Future<List<Player>> getAllPlayersSortedByHighScore() async {
    QuerySnapshot querySnapshot = await playersCollection.get();
    List<Player> players = [];

    for (var documentSnapshot in querySnapshot.docs) {
      String playerId = documentSnapshot.id;
      Map<String, dynamic> data =
          documentSnapshot.data() as Map<String, dynamic>;
      String nickname = data['nickname'] as String;
      int highScore = data['highscore'] as int;
      Player player = Player(playerId, highScore, nickname);
      players.add(player);
    }

    // Sort the players by high score
    players.sort((a, b) => b.highScore.compareTo(a.highScore));

    return players;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<int>(
      future: getCollectionSize(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error loading data: ${snapshot.error}');
        } else {
          int collectionSize = snapshot.data ?? 0;
          return Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height - 255,
                width: 500,
                decoration: BoxDecoration(
                  color: Color.fromRGBO(255, 255, 255, 0.7),
                  borderRadius: BorderRadius.circular(28),
                ),
                child: Padding(
                  padding: EdgeInsets.only(
                    left: small,
                    right: small,
                    top: xsmall / 2,
                  ),
                  child: ListView(
                    children: [
                      SizedBox(height: small),
                      const ListHeader(),
                      SizedBox(height: small),
                      for (int i = 0; i < players.length; i++)
                        FirestoreListBlock(player: players[i], index: i),
                    ],
                  ),
                ),
              ),
              Text('Collection size: $collectionSize'),
            ],
          );
        }
      },
    );
  }
}

class FirestoreListBlock extends StatelessWidget {
  FirestoreListBlock({super.key, required this.player, required this.index});

  Player player;
  int index;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 50,
          child: Text(index.toString(), style: heading0),
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

class PlayersList extends StatefulWidget {
  const PlayersList({super.key, required this.playerViewModel});
  final PlayerViewModel playerViewModel;

  @override
  State<PlayersList> createState() => _PlayersListState();
}

class _PlayersListState extends State<PlayersList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: MediaQuery.of(context).size.height - 255,
          width: 500,
          decoration: BoxDecoration(
            color: Color.fromRGBO(255, 255, 255, 0.7),
            borderRadius: BorderRadius.circular(28),
          ),
          child: Padding(
            padding:
                EdgeInsets.only(left: small, right: small, top: xsmall / 2),
            child: ListView(
              children: [
                SizedBox(height: small),
                const ListHeader(),
                SizedBox(height: small),
                for (int i = 0; i < widget.playerViewModel.playerCount; i++)
                  PlayerDisplay(
                      index: i,
                      player: widget.playerViewModel.getPlayerAtIndex(i))
              ],
            ),
          ),
        )
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

class PlayerDisplay extends StatelessWidget {
  const PlayerDisplay({super.key, required this.index, required this.player});
  final int index;
  final Player player;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
          width: 50,
          child: Text(
            (index + 1).toString(),
            style: heading0,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: 130,
          child: Text(
            player.nickname,
            style: heading0,
          ),
        ),
        Container(
          width: 90,
          child: Text(
            player.highScore.toString(),
            style: heading0,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
