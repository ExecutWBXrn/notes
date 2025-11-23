import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

// repos

import 'package:firebase_flutter_studying_project/repos/note_repository.dart';
import 'package:firebase_flutter_studying_project/repos/auth_repository.dart';
import 'package:firebase_flutter_studying_project/repos/avatar_repository.dart';

// models

import 'package:firebase_flutter_studying_project/models/note.dart';

// instance

final firebaseInstanceProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

final firestoreInstanceProvider = Provider<FirebaseFirestore>(
  (ref) => FirebaseFirestore.instance,
);

final storageInstanceProvider = Provider<FirebaseStorage>(
  (ref) => FirebaseStorage.instance,
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

// Avatar

final avatarRepositoryProvider = Provider<AvatarRepository>(
  (ref) => AvatarRepository(
    ref.read(firebaseInstanceProvider),
    ref.read(storageInstanceProvider),
  ),
);

final avatarUrlProvider = FutureProvider<String?>(
  (ref) => ref.read(avatarRepositoryProvider).getAvatar(),
);
