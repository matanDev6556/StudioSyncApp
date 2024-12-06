import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:studiosync/core/services/firebase/storage_services.dart';

class ImageService {
  final StorageServices storageServices;

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
