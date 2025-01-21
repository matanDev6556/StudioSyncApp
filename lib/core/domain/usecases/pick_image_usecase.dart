import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:studiosync/core/domain/repositories/i_storage_service.dart';
import 'package:uuid/uuid.dart';

class PickImageUseCase {
  final IStorageService _storageService;

  PickImageUseCase({required IStorageService iStorageService}):_storageService = iStorageService;

  Future<String?> call(String userId) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        return await _storageService.uploadImage(
          imageFile,
          '$userId/${const Uuid().v4()}.jpg',
        );
      } else {
        return null;
      }
    } catch (error) {
      print('error from pick image use case $error');
      return null;
    }
  }
}
