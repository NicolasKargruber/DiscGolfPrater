import 'package:flutter/foundation.dart';

import '../model/course.dart';
import '../model/player.dart';

class LeaderboardViewModel extends ChangeNotifier {
  final List<Course> courses;

  LeaderboardViewModel(this.courses);

  Map<Player, int> get totalScores {
    final Map<Player, int> totals = {};
    for (final course in courses) {
      for (final playerScore in course.playerScores) {
        totals[playerScore.player] = (totals[playerScore.player] ?? 0) + playerScore.score;
      }
    }
    return totals;
  }

  List<MapEntry<Player, int>> get ranking {
    final totals = totalScores.entries.toList();
    totals.sort((a, b) => a.value.compareTo(b.value)); // lower is better
    return totals;
  }
}
