import 'package:disc_golf_prater/utilities/app_values.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/course_view_model.dart';
import 'model/course.dart';

class CoursePage extends StatelessWidget {
  final Function() backwardPage;
  final Function() forwardPage;
  final Function(Course course) onCourseFinished;

  const CoursePage({
    super.key,
    required this.backwardPage,
    required this.forwardPage,
    required this.onCourseFinished,
  });

  void _onResetCourse(BuildContext context) async {
    final CourseViewModel vm = context.read<CourseViewModel>();
    final result = await showDialog(context: context, builder: (BuildContext context) {
      return AlertDialog(
        title: Text('${vm.course.label} (Reset)'),
        content: const Text('Are you sure you want to reset this course?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              vm.resetCourse();
              Navigator.of(context).pop();
            },
            child: const Text('Reset'),
          ),
        ],
      );
    });
    if(result) vm.resetCourse();
  }
  Future<bool?> _showBackDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Are you sure?'),
          content: const Text('Leaving this page you will loose all progress and will reset every course!'),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Nevermind'),
              onPressed: () {
                Navigator.pop(context, false);
              },
            ),
            TextButton(
              style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
              child: const Text('Leave'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  void _onNextPlayer(BuildContext context) {
    final CourseViewModel vm = context.read<CourseViewModel>();
    if(vm.isLastPlayer) {
      if(!vm.course.finished) {
        vm.onCourseFinished();
        onCourseFinished(vm.course);
      }
      // FINISHED COURSE for all players
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          duration: Durations.long1,
          content: Text('${vm.course.label} finished!'),
        ),
      );
    }
    else {
      vm.onTurnEnded();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CourseViewModel>();
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        if (didPop) {
          return;
        }
        final bool shouldPop = await _showBackDialog(context) ?? false;
        if (context.mounted && shouldPop) {
          Navigator.pop(context);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: AppValues.s8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.p24, vertical: AppValues.p4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(AppValues.r12),
                  child: Container(
                    color: vm.currentPlayer.color,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Top: Course number
                        Padding(
                          padding: const EdgeInsets.all(AppValues.p16),
                          child: Text(
                            vm.course.label,
                            style: const TextStyle(
                              fontSize: AppValues.fs28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),

                        Column(
                          children: vm.previousPlayerScores.map((score) => Text('${score.player.name}: ${score.score}', style: const TextStyle(fontSize: AppValues.fs20, color: Colors.white))).toList(),
                        ),

                        // Middle: Player's turn + Frisbee counter
                        vm.course.finished ? buildCourseFinished() : buildPlayersTurn(context),

                        // Bottom: Next button
                        Padding(
                          padding: const EdgeInsets.all(AppValues.p16),
                          child: Row(
                            spacing: AppValues.s4,
                            children: [
                              IconButton.filled(
                                style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: vm.currentPlayer.color,
                              ),
                                onPressed: backwardPage,
                                icon: Icon(Icons.arrow_back),
                              ),
                              Flexible(
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    minimumSize: const Size.fromHeight(AppValues.s60),
                                    backgroundColor: Colors.white,
                                    foregroundColor: vm.currentPlayer.color,
                                  ),
                                  onPressed: () => _onNextPlayer(context),
                                  child: Text(
                                    !vm.isLastPlayer ? 'Next Player' : 'Finish Course',
                                    style: const TextStyle(fontSize: AppValues.fs24),
                                  ),
                                ),
                              ),
                              IconButton.filled(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: vm.currentPlayer.color,
                                ),
                                onPressed: forwardPage,
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
            ),

            TextButton(
              style: TextButton.styleFrom(foregroundColor: Colors.white),
                onPressed: vm.finished ? () => _onResetCourse(context) : null,
                child: Text('Reset Course', style: const TextStyle(fontSize: AppValues.fs16)),
            ),

          ],
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

  Widget buildPlayersTurn(BuildContext context){
    final vm = context.watch<CourseViewModel>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "${vm.currentPlayer.name}'s turn",
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
              onPressed: vm.lowerCurrentScore,
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
              '${vm.currentScore}',
              style: const TextStyle(
                fontSize: AppValues.fs48,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: AppValues.s8),
            IconButton(
              onPressed: vm.upCurrentScore,
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