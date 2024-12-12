import 'package:studiosync/modules/trainee/features/trainers-list/utils/keys_filters_prefrences.dart';
import 'package:studiosync/shared/repositories/interfaces/local_storage_repository.dart';


class LoadPreferencesUseCase {
  final ILocalStorageRepository _iLocalStorageRepository;

  LoadPreferencesUseCase(
      {required ILocalStorageRepository localStorageRepository})
      : _iLocalStorageRepository = localStorageRepository;

  Future<Map<String, dynamic>> execute() async {
  return {
    PreferencesKeys.inMyCity: await _iLocalStorageRepository.get<bool>(PreferencesKeys.inMyCity) ?? false,
    PreferencesKeys.markedFilters: await _iLocalStorageRepository.get<bool>(PreferencesKeys.markedFilters) ?? false,
    PreferencesKeys.lessonFilters: await _iLocalStorageRepository.get<List<String>>(PreferencesKeys.lessonFilters) ?? [],
  };
}
}
