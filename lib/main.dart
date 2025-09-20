import 'dart:async';
import 'dart:math';
import 'package:disc_golf_prater/utilities/app_values.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const PlayerApp());
}

class PlayerApp extends StatelessWidget {
  const PlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Disc Golf Prater',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      home: const PlayerScreen(),
    );
  }
}

class Player {
  final String name;
  final Color color;

  Player(this.name, this.color);
}

class PlayerScreen extends StatefulWidget {
  const PlayerScreen({super.key});

  @override
  State<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends State<PlayerScreen> {
  final List<Player> _players = [];
  int _playerCount = 0;
  final Random _random = Random();

  void _addPlayer() {
    setState(() {
      _playerCount++;
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
        builder: (_) => ResultScreen(players: shuffled),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Players')),
      body: ListView.builder(
        itemCount: _players.length,
        itemBuilder: (context, index) {
          final player = _players[index];
          return ListTile(
            leading: CircleAvatar(backgroundColor: player.color),
            title: Text(player.name),
          );
        },
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: _addPlayer,
            heroTag: "add",
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            onPressed: _players.isNotEmpty ? _startGame : null,
            heroTag: "start",
            backgroundColor:
            _players.isNotEmpty ? Colors.green : Colors.grey.shade400,
            child: const Icon(Icons.play_arrow),
          ),
        ],
      ),
    );
  }
}

class ResultScreen extends StatefulWidget {
  final List<Player> players;

  const ResultScreen({super.key, required this.players});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  int _currentIndex = 0;
  int _frisbeeCount = 0;

  void _nextCourse() {
    setState(() {
      if (_currentIndex < widget.players.length - 1) {
        _currentIndex++;
        _frisbeeCount = 0; // reset for next player
      } else {
        // game finished → go back or show results
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.players[_currentIndex];

    return Scaffold(
      backgroundColor: player.color,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top: Course number
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Course 1',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            // Middle: Player's turn + Frisbee counter
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${player.name}'s turn",
                  style: const TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(onPressed: () {
                      setState(() {
                        _frisbeeCount--;
                      });
                    }
                      , icon: const Icon(
                        Icons.remove,
                        size: AppValues.s36,
                        color: Colors.white,
                      ),),
                    const SizedBox(width: AppValues.s8),
                    const Icon(
                      Icons.sports_baseball, // substitute for frisbee
                      size: 60,
                      color: Colors.white,
                    ),
                    const SizedBox(width: AppValues.s16),
                    Text(
                      '$_frisbeeCount',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: AppValues.s8),
                    IconButton(onPressed: () {
                      setState(() {
                        _frisbeeCount++;
                      });
                    }
                      , icon: const Icon(
                        Icons.add,
                        size: AppValues.s36,
                        color: Colors.white,
                      ),),
                  ],
                ),
              ],
            ),

            // Bottom: Next button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(60),
                  backgroundColor: Colors.white,
                  foregroundColor: player.color,
                ),
                onPressed: _nextCourse,
                child: Text(
                  _currentIndex < widget.players.length - 1
                      ? 'Next'
                      : 'Finish',
                  style: const TextStyle(fontSize: 24),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

