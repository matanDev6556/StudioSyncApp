import 'package:studiosync/modules/trainer/features/statistics/data/models/date_range_model.dart';
import 'package:studiosync/modules/trainer/features/statistics/data/models/monthly_states_model.dart';

abstract class IStatsRepository {
  Future<MonthlyStats> calculateMonthlyStats(String trainerId, DateRange dateRange);
}