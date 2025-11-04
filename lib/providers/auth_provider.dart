import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

// repos

import 'package:firebase_flutter_studying_project/repos/note_repository.dart';
import 'package:firebase_flutter_studying_project/repos/auth_repository.dart';

// models

import 'package:firebase_flutter_studying_project/models/note.dart';

// instance

final firebaseInstanceProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreInstanceProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

//  Auth

final authRepositoryProvider = Provider<AuthRepository>(
  (ref) => AuthRepository(ref.read(firebaseInstanceProvider)),
);

final authStateChangesProvider = StreamProvider<User?>(
  (ref) => ref.watch(authRepositoryProvider).authStateChages,
);

// Note

final noteRepositoryProvider = Provider<NoteRepository>(
  (ref) => NoteRepository(
    ref.read(firebaseInstanceProvider),
    ref.read(firestoreInstanceProvider),
  ),
);

final getNotesProvider = FutureProvider<List<Note>>(
  (ref) => ref.watch(noteRepositoryProvider).getNotes(),
);

final getNotesStreamProvider = StreamProvider<List<Note>>(
  (ref) => ref.watch(noteRepositoryProvider).getNoteStream(),
);
