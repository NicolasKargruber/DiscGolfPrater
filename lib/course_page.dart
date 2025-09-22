import 'package:disc_golf_prater/utilities/app_values.dart';
import 'package:flutter/material.dart';

import 'player.dart';

class CoursePage extends StatefulWidget {
  final int courseNumber;
  final List<Player> players;
  final Function() backwardPage;
  final Function() forwardPage;
  final Function(int) onCourseFinished;

  const CoursePage({
    super.key,
    required this.courseNumber,
    required this.players,
    required this.backwardPage,
    required this.forwardPage,
    required this.onCourseFinished,
  });

  @override
  State<CoursePage> createState() => _CoursePageState();
}

class _CoursePageState extends State<CoursePage> {
  int _currentIndex = 0;
  int _frisbeeCount = 0;
  bool _finishedCourse = false;

  void _nextPlayer() {
    setState(() {
      if (_currentIndex < widget.players.length - 1) {
        _currentIndex++;
        _frisbeeCount = 0;
      } else {
        // FINISHED COURSE for all players
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              behavior: SnackBarBehavior.floating,
              duration: Durations.long1,
              content: Text('Course ${widget.courseNumber} finished!'),
          ),
        );
        _finishedCourse = true;
        widget.onCourseFinished(widget.courseNumber);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final player = widget.players[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppValues.p24, vertical: AppValues.p24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppValues.r12),
          child: Container(
            color: player.color,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Top: Course number
                Padding(
                  padding: const EdgeInsets.all(AppValues.p16),
                  child: Text(
                    'Course ${widget.courseNumber}',
                    style: const TextStyle(
                      fontSize: AppValues.fs28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),

                // Middle: Player's turn + Frisbee counter
                _finishedCourse ? buildCourseFinished() : buildPlayersTurn(player),

                // Bottom: Next button
                Padding(
                  padding: const EdgeInsets.all(AppValues.p16),
                  child: Row(
                    spacing: AppValues.s4,
                    children: [
                      IconButton.filled(
                        style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: player.color,
                      ),
                        onPressed: widget.backwardPage,
                        icon: Icon(Icons.arrow_back),
                      ),
                      Flexible(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.fromHeight(AppValues.s60),
                            backgroundColor: Colors.white,
                            foregroundColor: player.color,
                          ),
                          onPressed: _nextPlayer,
                          child: Text(
                            _currentIndex < widget.players.length - 1
                                ? 'Next Player'
                                : 'Finish Course',
                            style: const TextStyle(fontSize: AppValues.fs24),
                          ),
                        ),
                      ),
                      IconButton.filled(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: player.color,
                        ),
                        onPressed: widget.forwardPage,
                        icon: Icon(Icons.arrow_forward),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildCourseFinished() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check_circle, size: AppValues.s120, color: Colors.white),
        const SizedBox(height: AppValues.s8),
        const Text(
          'Course finished!',
          style: TextStyle(
            fontSize: AppValues.fs24,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),]
    );

  }

  Widget buildPlayersTurn(Player player){
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${player.name}'s turn",
          style: const TextStyle(
            fontSize: AppValues.fs32,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: AppValues.s24),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: () {
                setState(() {
                  _frisbeeCount--;
                });
              },
              icon: const Icon(
                Icons.remove,
                size: AppValues.s36,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: AppValues.s8),
            const Icon(
              Icons.sports_baseball, // substitute frisbee
              size: AppValues.s60,
              color: Colors.white,
            ),
            const SizedBox(width: AppValues.s16),
            Text(
              '$_frisbeeCount',
              style: const TextStyle(
                fontSize: AppValues.fs48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: AppValues.s8),
            IconButton(
              onPressed: () {
                setState(() {
                  _frisbeeCount++;
                });
              },
              icon: const Icon(
                Icons.add,
                size: AppValues.s36,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ],
    );
  }
}