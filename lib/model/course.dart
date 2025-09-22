import 'player.dart';

class PlayerScore {
  int score;
  final Player player;

  PlayerScore({required this.score, required this.player});
}

class Course {
  final int index;
  String get label => "Course ${index + 1}";

  CourseStatus _status = CourseStatus.ongoing;
  CourseStatus get status => _status;

  final List<Player> orderedPlayers;

  late final List<PlayerScore> _playerScores;
  List<PlayerScore> get playerScores => _playerScores.toList();

  Course(this.index, {required this.orderedPlayers}) {
    _playerScores = orderedPlayers.map((player) => PlayerScore(score: 0, player: player)).toList();
  }

  endCourse() => _status = CourseStatus.finished;
  get finished => _status == CourseStatus.finished;
}

enum CourseStatus {
  ongoing, finished
}