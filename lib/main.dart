import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_studying_project/screens/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_flutter_studying_project/wrapper/Auth_wrapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_flutter_studying_project/screens/note_screen.dart';
import 'package:firebase_flutter_studying_project/screens/auth/sign_in.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(
    ProviderScope(
      child: MaterialApp(
        home: AuthWrapper(),
        routes: {
          '/notes': (context) => NoteScreen(),
          '/signIn': (context) => SignIn(),
          '/signUp': (context) => SignUp(),
        },
      ),
    ),
  );
}
