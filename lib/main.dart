import 'package:flutter/material.dart';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const PlayerApp());
}

class PlayerApp extends StatelessWidget {
  const PlayerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Player App',
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
      floatingActionButton: FloatingActionButton(
        onPressed: _addPlayer,
        child: const Icon(Icons.add),
      ),
    );
  }
}

