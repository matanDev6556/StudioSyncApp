import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:studiosync/core/services/interfaces/i_storage_service.dart';

class StorageServices implements IStorageService {
  final Reference _storageRef = FirebaseStorage.instance.ref();

  @override
  Future<String> uploadImage(File imageFile, String path) async {
    final ref = _storageRef.child(path);
    final uploadTask = ref.putFile(imageFile);
    final snapshot = await uploadTask;
    final imgUrl = await snapshot.ref.getDownloadURL();
    return imgUrl;
  }
}
