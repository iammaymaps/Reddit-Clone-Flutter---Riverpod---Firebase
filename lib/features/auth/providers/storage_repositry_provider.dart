import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:new_reddit_clone/core/Failure.dart';
import 'package:new_reddit_clone/core/type_def.dart';
import 'package:new_reddit_clone/features/auth/providers/firebase_Provider.dart';

final storageRepositoryProvider = Provider(
    (ref) => StorageRepository(firebaseStorage: ref.watch(storageProvider)));

class StorageRepository {
  final FirebaseStorage _firebaseStorage;

  StorageRepository({required FirebaseStorage firebaseStorage})
      : _firebaseStorage = firebaseStorage;

  FutureEither<String> storeFile({
    required String path,
    required String ID,
    required File? file,
  }) async {
    try {
      final ref = _firebaseStorage.ref().child(path).child(ID);
      UploadTask uploadTask = ref.putFile(file!);
      final snapshot = await uploadTask;

      return right(await snapshot.ref.getDownloadURL());
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }
}
