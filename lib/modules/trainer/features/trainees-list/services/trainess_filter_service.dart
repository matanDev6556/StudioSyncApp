import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';

class TraineeFilterService {
  // Filter based on search query and active status
  List<TraineeModel> filterTrainees({
    required List<TraineeModel> traineesList,
    required String searchQuery,
    required String activeStatusFilter,
  }) {
    // Filter based on search query
    final filteredBySearch = traineesList.where((trainee) {
      final nameMatches = trainee.userFullName
          .toLowerCase()
          .contains(searchQuery.toLowerCase());

      return nameMatches;
    }).toList();

    // Filter based on active status
    if (activeStatusFilter == 'All') {
      return filteredBySearch;
    } else {
      final isActiveFilter = activeStatusFilter == 'Active';
      return filteredBySearch
          .where((trainee) => trainee.isActive() == isActiveFilter)
          .toList();
    }
  }
}