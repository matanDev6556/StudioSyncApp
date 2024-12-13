import 'package:studiosync/modules/trainer/models/trainer_model.dart';

class FilterTrainersUseCase {
  List<TrainerModel> execute({
    required List<TrainerModel> trainers,
    required List<String> lessonsTypesFilter,
    required String searchQuery,
  }) {
    var filtered = trainers;

    if (lessonsTypesFilter.isNotEmpty) {
      filtered = filtered.where((trainer) {
        return lessonsTypesFilter
            .any((lesson) => trainer.lessonsTypeList.contains(lesson));
      }).toList();
    }

    if (searchQuery.isNotEmpty) {
      filtered = filtered.where((trainer) {
        return trainer.userFullName
            .toLowerCase()
            .contains(searchQuery.toLowerCase());
      }).toList();
    }

    return filtered;
  }
}
