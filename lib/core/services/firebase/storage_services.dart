import 'dart:async';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StorageServices {
  final Reference _storageRef = FirebaseStorage.instance.ref();

  Future<String> uploadImageas(File imgFile, String imgPath) async {
    final ref = _storageRef.child(imgPath);
    final uploadTask = ref.putFile(imgFile);
    final snapshot = await uploadTask;
    final imgUrl = await snapshot.ref.getDownloadURL();
    print('storage service: $imgUrl');
    return imgUrl;
  }
}
