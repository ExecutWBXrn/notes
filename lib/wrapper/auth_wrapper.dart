import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_flutter_studying_project/providers/auth_provider.dart';
import 'package:firebase_flutter_studying_project/screens/note_screen.dart';
import 'package:firebase_flutter_studying_project/screens/auth/sign_in.dart';

class AuthWrapper extends ConsumerWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateChangesProvider);

    return authState.when(
      data: (data) {
        if (data == null) {
          return SignIn();
        }
        return NoteScreen();
      },
      error: (e, s) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Невдалось увійти"),
            backgroundColor: Colors.red,
          ),
        );
        return SignIn();
      },
      loading: () {
        return const Center(child: CircularProgressIndicator());
      },
    );
  }
}
