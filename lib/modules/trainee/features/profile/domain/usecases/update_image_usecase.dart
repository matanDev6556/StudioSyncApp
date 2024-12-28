import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:studiosync/core/domain/repositories/i_storage_service.dart';
import 'package:studiosync/modules/trainee/features/profile/domain/repositories/i_trainee_repository.dart';
import 'package:studiosync/modules/trainee/features/profile/data/models/trainee_model.dart';
import 'package:uuid/uuid.dart';

class UpdateProfileImageUseCase {
  final ITraineeRepository _repository;
  final IStorageService _iStorageService;

  UpdateProfileImageUseCase(this._repository, this._iStorageService);

  Future<String> execute(TraineeModel trainee) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final imgUrl = await _iStorageService.uploadImage(
          imageFile, '${trainee.userId}/${const Uuid().v4()}.jpg');
      _repository.updateProfileImage(trainee.copyWith(imgUrl: imgUrl));
      return imgUrl;
    }
    return '';
  }
}
