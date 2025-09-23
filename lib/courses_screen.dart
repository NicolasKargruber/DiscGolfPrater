import 'package:disc_golf_prater/course_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'model/course.dart';
import 'view_model/course_view_model.dart';
import 'leaderboard_screen.dart';
import 'utilities/app_values.dart';
import 'view_model/courses_view_model.dart';
import 'view_model/leaderboard_view_model.dart';

class CoursesScreen extends StatelessWidget {
  CoursesScreen({super.key});

  final PageController _pageController = PageController(keepPage: true);

  void backwardPage() {
    if (_pageController.hasClients) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void forwardPage(BuildContext context) {
    final vm = context.read<CoursesViewModel>();
    if (_pageController.hasClients) {
      if (_pageController.page == vm.totalCourses - 1) {
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ChangeNotifierProvider(
                create: (_) => LeaderboardViewModel(vm.finishedCourses),
                child: LeaderboardScreen(),
            ),
          ),
        );
      }
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.read<CoursesViewModel>();
    return Scaffold(
      appBar: AppBar(title: Text("${vm.totalCourses} Courses")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                if((_pageController.page?.round() ?? 0) > vm.finishedCourseCount) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: Durations.long4,
                      content: Text('Finish this course first!'),
                    ),
                  );
                  backwardPage();
                }
            },
              itemCount: vm.totalCourses,
              itemBuilder: (context, index) {
                return ChangeNotifierProvider(
                  create: (_) {
                    final Course course;
                    if(index < vm.finishedCourseCount) {
                      course = vm.finishedCourses[index];
                    } else {
                      course = Course(index, orderedPlayers: vm.players);
                    }
                    return CourseViewModel(course);
                  },
                  child: CoursePage(
                    backwardPage: backwardPage,
                    forwardPage: () => forwardPage(context),
                    onCourseFinished: vm.onCourseFinished,
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppValues.p16),
            child: SmoothPageIndicator(
              controller: _pageController,
              count: vm.totalCourses,
              effect: const ScrollingDotsEffect(
                activeDotColor: Colors.white,
                dotColor: Colors.white60,
                dotHeight: AppValues.s12,
                dotWidth: AppValues.s12,
              ),
            ),
          ),
          SizedBox(height: AppValues.s36),
        ],
      ),
    );
  }
}