import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:studiosync/core/services/interfaces/i_storage_service.dart';
import 'package:studiosync/modules/trainee/features/profile/repositories/trainee_repository.dart';
import 'package:studiosync/modules/trainee/models/trainee_model.dart';
import 'package:uuid/uuid.dart';

class UpdateProfileImageUseCase {
  final TraineeRepository _repository;
  final IStorageService _iStorageService;

  UpdateProfileImageUseCase(this._repository, this._iStorageService);

  Future<String> execute(TraineeModel trainee, String path) async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final imageFile = File(pickedFile.path);
      final imgUrl = await _iStorageService.uploadImage(
          imageFile, '${trainee.userId}/${const Uuid().v4()}.jpg');
      _repository.updateProfileImage(trainee.copyWith(imgUrl: imgUrl), path);
      return imgUrl;
    }
    return '';
  }
}
