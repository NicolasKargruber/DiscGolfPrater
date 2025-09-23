import 'package:disc_golf_prater/model/course.dart';
import 'package:disc_golf_prater/model/player.dart';
import 'package:disc_golf_prater/utilities/app_values.dart';
import 'package:disc_golf_prater/utilities/extensions/build_context_extensions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'view_model/leaderboard_view_model.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.read<LeaderboardViewModel>();
    final ranking = vm.ranking;
    final courses = vm.courses;

    return Scaffold(
      appBar: AppBar(title: const Text("Leaderboard")),
      body: SafeArea(
        child: Column(
          children: [

            // Trophy + Ranking
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // Trophy
                  const Icon(
                    Icons.emoji_events,
                    color: Colors.amber,
                    size: 100,
                  ),
                  const SizedBox(width: 24),

                  // Ranking
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(ranking.length, (i) {
                        final entry = ranking[i];
                        return Text(
                          "${i + 1}. ${entry.key.name}  (${entry.value})",
                          style: TextStyle(
                            fontSize: 16.0 + 12 / (i + 1),
                            fontWeight: i == 0 ? FontWeight.bold : FontWeight.normal,
                            color: entry.key.color,
                          ),
                        );
                      }),
                    ),
                  ),

                ],
              ),
            ),

            SizedBox(height: AppValues.s24),

            // Player-Score-Table
            SizedBox(
              width: double.infinity,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Padding(
                  padding: const EdgeInsets.all(AppValues.p8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(AppValues.r12),
                    child: _PlayerScoresTable(courses: courses, ranking: ranking),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlayerScoresTable extends StatelessWidget {
  const _PlayerScoresTable({
    super.key,
    required this.courses,
    required this.ranking,
  });

  final List<Course> courses;
  final List<MapEntry<Player, int>> ranking;

  @override
  Widget build(BuildContext context) {
    return DataTable(
      dataRowColor: WidgetStateProperty.all(context.colorScheme.surfaceContainerHigh),
      headingTextStyle: TextStyle(fontWeight: FontWeight.bold, color: context.colorScheme.onPrimary),
      headingRowColor: WidgetStateProperty.all(context.colorScheme.primary),
      columns: [
        const DataColumn(label: Text("Player")),
        ...courses.map((c) => DataColumn(label: Text(c.label))),
        const DataColumn(label: Text("Total")),
      ],
      rows: ranking.map((entry) {
        final player = entry.key;
        final total = entry.value;
        return DataRow(
          cells: [
            DataCell(Row(
              children: [
                CircleAvatar(backgroundColor: player.color, radius: 8),
                const SizedBox(width: 8),
                Text(player.name),
              ],
            )),
            ...courses.map((c) {
              final score = c.playerScores.firstWhere(
                    (s) => s.player == player,
              ).score;
              return DataCell(
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: AppValues.p2, horizontal: AppValues.p16),
                    decoration: BoxDecoration(
                      color: player.color,
                      borderRadius: BorderRadius.circular(AppValues.r8),
                    ), child: Text(score.toString(), style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                  ),
              );
            }),
            DataCell(Text(total.toString())),
          ],
        );
      }).toList(),
    );
  }
}

