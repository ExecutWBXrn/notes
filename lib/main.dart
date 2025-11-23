import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_flutter_studying_project/screens/auth/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:firebase_flutter_studying_project/wrapper/Auth_wrapper.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_flutter_studying_project/screens/note_screen.dart';
import 'package:firebase_flutter_studying_project/screens/auth/sign_in.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  Dio _dio = Dio(BaseOptions(baseUrl: 'https://sum-oukaqdq2cq-uc.a.run.app'));

  try {
    final response = await _dio.post("/", data: {'a': 1, 'b': 299});
    if ((response.statusCode! / 10).toInt() == 20) {
      print(response.data);
    } else {
      print(response.statusCode);
    }
  } on DioException catch (e) {
    print(e.response);
    print("Error status code: ${e.response?.statusCode}");
  }

  // runApp(
  //   ProviderScope(
  //     child: MaterialApp(
  //       home: AuthWrapper(),
  //       routes: {
  //         '/notes': (context) => NoteScreen(),
  //         '/signIn': (context) => SignIn(),
  //         '/signUp': (context) => SignUp(),
  //       },
  //     ),
  //   ),
  // );
}
