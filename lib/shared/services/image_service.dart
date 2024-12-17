import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:studiosync/core/domain/repositories/i_storage_service.dart';
import 'package:uuid/uuid.dart';


class ImageService {
  final IStorageService storageServices;

  ImageService(this.storageServices);

  Future<String?> pickAndUploadImage(String userId) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        final imageFile = File(pickedFile.path);
        final imgUrl = await storageServices.uploadImage(
            imageFile, '$userId/${const Uuid().v4()}.jpg');
        return imgUrl;
      }
    } catch (e) {
      return null;
    }
    return null;
  }
}
