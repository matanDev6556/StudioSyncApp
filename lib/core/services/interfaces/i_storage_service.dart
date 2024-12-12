import 'dart:io';

abstract class IStorageService {
  Future<String> uploadImage(File imageFile, String path);
}