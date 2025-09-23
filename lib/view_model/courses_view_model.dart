import 'package:flutter/foundation.dart';

import '../model/course.dart';
import '../model/player.dart';

class CoursesViewModel extends ChangeNotifier {
  final List<Player> _players;
  List<Player> get players => _players.toList();

  CoursesViewModel(this._players);

  //final int totalCourses = 18;
  final int totalCourses = 3;
  final List<Course> _finishedCourses = [];
  List<Course> get finishedCourses => _finishedCourses.toList();
  int get finishedCourseCount => _finishedCourses.length;

  void onCourseFinished(Course course) {
    _finishedCourses.add(course);
    notifyListeners();
  }
}