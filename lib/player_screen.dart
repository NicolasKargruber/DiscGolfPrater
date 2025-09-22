import 'dart:math';

import 'package:disc_golf_prater/utilities/app_values.dart';
import 'package:flutter/material.dart';

import 'courses_screen.dart';
import 'player.dart';

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final List<Player> _players = [];
  int get _playerCount => _players.length;
  final Random _random = Random();

  void _addPlayer() {
    setState(() {
      _players.add(
        Player(
          'Player $_playerCount',
          Color.fromARGB(
            255,
            _random.nextInt(256),
            _random.nextInt(256),
            _random.nextInt(256),
          ),
        ),
      );
    });
  }

  void _startGame() async {
    // Countdown 3,2,1
    if (false) for (int i = 3; i > 0; i--) {
      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AlertDialog(
          alignment: Alignment.center,
          content: Text(
            '$i',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 64, fontWeight: FontWeight.bold),
          ),
        ),
      );
      //await Future.delayed(const Duration(milliseconds: 500));
      if (mounted) Navigator.of(context).pop();
    }

    // Shuffle players
    final shuffled = List<Player>.from(_players)..shuffle();

    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => CoursesScreen(players: shuffled),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Players')),
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView.builder(
            itemCount: _players.length,
            itemBuilder: (context, index) {
              final player = _players[index];
              return ListTile(
                leading: CircleAvatar(backgroundColor: player.color),
                title: Text(player.name),
              );
            },
          ),
          Padding(
            padding: const EdgeInsets.all(AppValues.p24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if(_players.isEmpty) Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Add Players', style: Theme.of(context).textTheme.titleMedium),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppValues.p12, vertical: AppValues.p4),
                      child: Icon(Icons.arrow_downward, size: AppValues.s36),
                    ),
                  ],
                ),
                Row(
                  children: [
                    FloatingActionButton(
                      onPressed: _addPlayer,
                      heroTag: "add",
                      child: const Icon(Icons.add),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: SizedBox(
                        height: AppValues.s52,
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            minimumSize: const Size.fromHeight(60),
                          ),
                          onPressed: _players.isNotEmpty ? _startGame : null,
                          child: Text('START', style: const TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}