import 'dart:async';
import 'package:get/get.dart';
import 'package:studiosync/modules/auth/domain/usecases/get_current_useruid_usecase.dart';
import 'package:studiosync/modules/trainer/features/trainees-list/presentation/trainees_controller.dart';
import 'package:studiosync/modules/trainer/features/lesoons/contollers/trainer_lessons_controller.dart';
import 'package:studiosync/modules/trainer/features/trainer-statistics/data/models/date_range_model.dart';
import 'package:studiosync/modules/trainer/features/trainer-statistics/data/models/monthly_states_model.dart';

class TrainerStatsController extends GetxController {
  final GetCurrentUserIdUseCase _getCurrentUserIdUseCase;
  final TrainerLessonsController trainerLessonsController;

  TrainerStatsController(this.trainerLessonsController,this._getCurrentUserIdUseCase);

  // Observable states
  final currentMonthStats = MonthlyStats(
    sessionsCount: 0,
    traineesCount: 0,
    newTraineesCount: 0,
    uniqueTrainees: {},
  ).obs;

  final previousMonthStats = MonthlyStats(
    sessionsCount: 0,
    traineesCount: 0,
    newTraineesCount: 0,
    uniqueTrainees: {},
  ).obs;

  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    calculateStats();
  }

  Future<void> calculateStats() async {
    try {
      isLoading.value = true;

      final currentMonth = DateRange.getCurrentMonth();
      final previousMonth = DateRange.getPreviousMonth();

      // Fetch current and previous month statistics in parallel
      final results = await Future.wait([
        _calculateMonthlyStats(_getCurrentUserIdUseCase() ?? "", currentMonth),
        _calculateMonthlyStats(_getCurrentUserIdUseCase() ?? "", previousMonth),
      ]);

      currentMonthStats.value = results[0];
      previousMonthStats.value = results[1];
    } catch (e) {
      print('Error calculating stats: $e');
      // Here you might want to handle the error appropriately
    } finally {
      isLoading.value = false;
    }
  }

  Future<MonthlyStats> _calculateMonthlyStats(
      String trainerId, DateRange dateRange) async {
    // Get lessons for the date range
    final lessonsInRange = trainerLessonsController.lessons.where((lesson) {
      final lessonDate =
          lesson.startDateTime; // Assuming startDateTime is a DateTime object
      return lessonDate.isAfter(dateRange.startDate) &&
          lessonDate.isBefore(dateRange.endDate);
    }).toList();

    // Calculate unique trainees
    final uniqueTrainees = <String>{};
    for (var lesson in lessonsInRange) {
      uniqueTrainees.addAll(lesson.traineesRegistrations);
    }

    // Calculate new trainees
    final traineesController = Get.find<TraineesController>();
    final newTrainees = traineesController.traineesList.where((trainee) {
      return trainee.startWorOutDate!.isAfter(dateRange.startDate) &&
          trainee.startWorOutDate!.isBefore(dateRange.endDate);
    }).length;

    return MonthlyStats(
      sessionsCount: lessonsInRange.length,
      traineesCount: uniqueTrainees.length,
      newTraineesCount: newTrainees,
      uniqueTrainees: uniqueTrainees,
    );
  }
}
