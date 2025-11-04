import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_flutter_studying_project/models/note.dart';

class NoteRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _fireStore;

  NoteRepository(this._firebaseAuth, this._fireStore);

  CollectionReference<Note> _getNoteCollectionReference() {
    final userId = _firebaseAuth.currentUser!.uid;

    return _fireStore
        .collection('users')
        .doc(userId)
        .collection('notes')
        .withConverter(
          fromFirestore: (snapshot, _) => Note.fromFirestore(snapshot),
          toFirestore: (model, _) => model.toFirestore(),
        );
  }

  Future<void> createNote(String name, String content) async {
    final newNote = Note(
      id: '',
      name: name,
      content: content,
      createdAt: DateTime.now(),
    );
    await _getNoteCollectionReference().add(newNote);
  }

  Future<List<Note>> getNotes() async {
    try {
      final snapshot = await _getNoteCollectionReference()
          .orderBy('createdAt')
          .get();
      final data = snapshot.docs.map((note) => note.data()).toList();
      return data;
    } catch (e) {
      print("Помилка при отриманні нотаток: $e");
      return [];
    }
  }

  Stream<List<Note>> getNoteStream() {
    final snapshots = _getNoteCollectionReference()
        .orderBy('createdAt')
        .snapshots();
    final snapshot = snapshots.map(
      (snap) => snap.docs.map((note) => note.data()).toList(),
    );
    return snapshot;
  }

  Future<void> updateNote(String id, String name, String content) async {
    await _getNoteCollectionReference().doc(id).update({
      'name': name,
      'content': content,
    });
  }

  Future<void> deleteNote(String id) async {
    await _getNoteCollectionReference().doc(id).delete();
  }
}
