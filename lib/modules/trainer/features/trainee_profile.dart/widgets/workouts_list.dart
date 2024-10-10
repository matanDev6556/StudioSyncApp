import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:studiosync/modules/trainee/models/workout_model.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/dots_inticator.dart';
import 'package:studiosync/modules/trainer/features/trainee_profile.dart/widgets/single_workout_card.dart';

class WorkoutListCard extends StatefulWidget {
  final List<WorkoutModel> workouts;

  const WorkoutListCard({Key? key, required this.workouts}) : super(key: key);

  @override
  _WorkoutListCardState createState() => _WorkoutListCardState();
}

class _WorkoutListCardState extends State<WorkoutListCard> {
  late PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _pageController.addListener(_onPageChanged);
  }

  void _onPageChanged() {
    int newPage = _pageController.page!.round();
    if (newPage != _currentPage) {
      setState(() {
        _currentPage = newPage;
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onPageChanged);
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Get.height * 0.4,
          child: PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.horizontal,
            itemCount: widget.workouts.length,
            itemBuilder: (context, index) {
              final workout = widget.workouts[index];
              return SingleWorkoutWidget(
                workout: workout,
                isExpanded: true,
              );
            },
          ),
        ),
        SizedBox(height: 15.h),
        DotsIndicatorWidget(
          dotsCount: widget.workouts.isNotEmpty ? widget.workouts.length : 1,
          activePosition: _currentPage,
        ),
      ],
    );
  }
}
