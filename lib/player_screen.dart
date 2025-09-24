import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'courses_screen.dart';
import 'view_model/courses_view_model.dart';
import 'model/player.dart';
import 'utilities/app_values.dart';

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
      String name = "Player69";
      int tries = 2;
      do {
        if (tries == 0) {
          name = "Player $_playerCount";
          break;
        }
        name = Player.names[_random.nextInt(Player.names.length)];
        tries--;
      } while (_players.any((player) => player.name == name));
      _players.add(
        Player(
          name,
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
    if (!mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ChangeNotifierProvider(
            create: (_) => CoursesViewModel(_players),
            child: CoursesScreen(),
        ),
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
                  onTap: () async {
                    final textController = TextEditingController();
                    final customName = await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Edit Player"),
                        content: TextField(
                          controller: textController,
                          decoration: const InputDecoration(
                            hintText: "Custom name",
                          ),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => setState(() {
                                Navigator.pop(context);
                              _players.remove(player);
                            }),
                            child: const Text("Remove"),
                          ),
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(context, textController.text),
                            child: const Text("OK"),
                          ),
                        ],
                      ),
                    );
                    if (customName != null && customName.isNotEmpty) {
                      setState(() {
                        _players[index] =
                            Player(customName, _players[index].color);
                      });
                    }
                  },
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