import 'package:disc_golf_prater/course_page.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'courses_view_model.dart';
import 'model/player.dart';
import 'result_screen.dart';
import 'utilities/app_values.dart';

class CoursesScreen extends StatefulWidget {
  final List<Player> players;

  const CoursesScreen({super.key, required this.players});

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  late final CourseViewModel vm;
  final PageController _pageController = PageController(
      keepPage: true
  );

  @override
  void initState() {
    vm = CourseViewModel(widget.players);
    super.initState();
  }

  void backwardPage() {
    if (_pageController.hasClients) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void forwardPage() {
    if (_pageController.hasClients) {
      if (_pageController.page == vm.totalCourses - 1) {
        if (!mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ResultScreen(),
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
    return Scaffold(
      appBar: AppBar(title: Text("${vm.totalCourses} Courses")),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (int page) {
                if((_pageController.page?.round() ?? 0) > vm.currentCourseIndex + 1) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      behavior: SnackBarBehavior.floating,
                      duration: Durations.long4,
                      content: Text('Finish this course!'),
                    ),
                  );
                  backwardPage();
                }
            },
              itemCount: vm.totalCourses,
              itemBuilder: (context, index) {
                return CoursePage(
                  courseIndex: index,
                  players: widget.players,
                  backwardPage: backwardPage,
                  forwardPage: forwardPage,
                  onTurnEnded: vm.onTurnEnded,
                  onCourseFinished: vm.onCourseFinished,
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