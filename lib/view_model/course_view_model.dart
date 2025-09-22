import 'package:flutter/foundation.dart';

import '../model/course.dart';
import '../model/player.dart';

class CourseViewModel extends ChangeNotifier {
  final Course course;

  CourseViewModel(this.course) {
    if(course.finished) { _currentPlayerIndex = course.orderedPlayers.length - 1; }
  }

  int _currentPlayerIndex = 0;
  Player get currentPlayer => course.orderedPlayers[_currentPlayerIndex];
  PlayerScore get currentPlayerScore => course.playerScores.firstWhere((element) => element.player == currentPlayer);
  bool get isLastPlayer => _currentPlayerIndex == course.orderedPlayers.length - 1;

  int _currentScore = 0;
  int get currentScore => _currentScore;

  void onTurnEnded() {
    currentPlayerScore.score = _currentScore;
    // Next Player
    _currentPlayerIndex++;
    _currentScore = 0;
    notifyListeners();
  }

  void onCourseFinished() {
    currentPlayerScore.score = _currentScore;
    course.endCourse();
    notifyListeners();
  }

  void upCurrentScore() {
    _currentScore++;
    notifyListeners();
  }

  void lowerCurrentScore() {
    _currentScore--;
    notifyListeners();
  }
}