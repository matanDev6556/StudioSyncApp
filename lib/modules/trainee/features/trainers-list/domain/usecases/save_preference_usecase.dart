import 'package:studiosync/core/domain/repositories/i_local_storage_repository.dart';

class SavePreferencesUseCase {
  final ILocalStorageRepository _iLocalStorageRepository;

  SavePreferencesUseCase({
    required ILocalStorageRepository localStorageRepository,
  }) : _iLocalStorageRepository = localStorageRepository;

  Future<void> execute({
    required String key,
    required dynamic value, 
  }) async {
    await _iLocalStorageRepository.save(key, value);
  }
}
