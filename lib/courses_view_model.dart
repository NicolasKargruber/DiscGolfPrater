import 'model/course.dart';
import 'model/player.dart';

class CourseViewModel {
  final List<Player> _players;
  List<Player> get players => _players.toList();

  CourseViewModel(this._players);

  final int totalCourses = 18;
  int get currentCourseIndex => _finishedCourses.length;
  final List<Course> _finishedCourses = [];
  Course? _currentCourse;

  void onTurnEnded(int courseNumber, {required int score, required Player player}) {
    (_currentCourse ??= Course(courseNumber)).addCourse(score, player);
  }

  void onCourseFinished(int courseNumber, {required int score, required Player player}) {
    (_currentCourse ??= Course(courseNumber)).addCourse(score, player);
    _finishedCourses.add(_currentCourse!);
  }
}