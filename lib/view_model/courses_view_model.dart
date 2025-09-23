import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../model/course.dart';
import '../model/player.dart';

class CoursesViewModel extends ChangeNotifier {
  final List<Player> _players;
  List<Player> get players => _players.toList();

  CoursesViewModel(this._players);

  final int totalCourses = 18;
  final List<Course> _courses = [];
  List<Course> get finishedCourses => _courses.where((course) => course.finished).toList();
  int get finishedCourseCount => finishedCourses.length;
  bool get hasFinishedAllCourses => finishedCourseCount >= totalCourses;

  List<Player> get nextPlayerOrder {
    final lastCourse = finishedCourses.lastOrNull;

    if (lastCourse == null) {
      final shuffled = List<Player>.from(_players)..shuffle();
      return shuffled;
    }

    // Calculate total scores
    final Map<Player, int> totalScores = {};
    for (final course in finishedCourses) {
      for (final ps in course.playerScores) {
        totalScores[ps.player] = (totalScores[ps.player] ?? 0) + ps.score;
      }
    }

    // Sort players by their previous course score
    final sorted = List.of(lastCourse.playerScores)
      ..sort((a, b) {
        final byLastCourse = a.score.compareTo(b.score); // smaller is better
        if (byLastCourse != 0) return byLastCourse;

        // Tie-breaker: Total score
        final totalA = totalScores[a.player] ?? 0;
        final totalB = totalScores[b.player] ?? 0;
        return totalA.compareTo(totalB); // smaller is better
      });

    return sorted.map((e) => e.player).toList();
  }


  void onCourseFinished(Course course) {
    _courses.add(course);
    notifyListeners();
  }
}