import 'package:chimp_game/firebase/player_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../firebase/player_account.dart';
import '../styles.dart';

class LeaderboardPage extends StatelessWidget {
  const LeaderboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final playerViewModel = context.watch<PlayerViewModel>();
    playerViewModel.loadPlayers();
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
                  PlayersList(playerViewModel: playerViewModel)
                ],
              ),
            ),
          ),
        ),
      ),
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
          child: Text("Rank", style: heading1),
        ),
        Container(
          width: 150,
          child: Text("Nickname", style: heading1),
        ),
        Container(
          width: 100,
          child: Text("Highscore", style: heading1),
        ),
      ],
    );
    ;
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
            style: heading1,
            textAlign: TextAlign.center,
          ),
        ),
        Container(
          width: 150,
          child: Text(
            player.nickname,
            style: heading1,
          ),
        ),
        Container(
          width: 100,
          child: Text(
            player.highScore.toString(),
            style: heading1,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
