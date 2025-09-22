import 'player.dart';

class Course {
  final int number;

  Course(this.number);

  final List<({int score, Player player})> _scores = [];
  List<({int score, Player player})> get scores => _scores.toList();

  addCourse(int score, Player player) => _scores.add((score: score, player: player));
}