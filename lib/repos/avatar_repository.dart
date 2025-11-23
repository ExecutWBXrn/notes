import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AvatarRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseStorage _firebaseStorage;

  AvatarRepository(this._firebaseAuth, this._firebaseStorage);

  Reference _getUserAvatarRef() {
    final userId = _firebaseAuth.currentUser?.uid;
    if (userId == null) {
      throw Exception("Користувач не увійшов");
    }
    return _firebaseStorage
        .ref()
        .child('user_avatar')
        .child(userId)
        .child('avatar.jpg');
  }

  Future<String> uploadAvatar(File imageFile) async {
    try {
      final UploadTask uploadTask = _getUserAvatarRef().putFile(imageFile);
      final TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } on FirebaseException catch (e) {
      print("Error: ${e.message}");
      rethrow;
    }
  }

  Future<String?> getAvatar() async {
    try {
      return await _getUserAvatarRef().getDownloadURL();
    } on FirebaseException catch (e) {
      print("Error: ${e.message}");
      return null;
    }
  }

  Future<void> deleteAvatar() async {
    try {
      await _getUserAvatarRef().delete();
    } on FirebaseException catch (e) {
      print("Error: ${e.message}");
      rethrow;
    }
  }
}
