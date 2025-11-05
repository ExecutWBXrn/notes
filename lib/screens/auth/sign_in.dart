import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_flutter_studying_project/providers/auth_provider.dart';

class SignIn extends ConsumerStatefulWidget {
  const SignIn({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _SignInState();
  }
}

class _SignInState extends ConsumerState<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (_formKey.currentState!.validate()) {
      try {
        await ref
            .read(authRepositoryProvider)
            .signIn(
              _emailController.text.trim(),
              _passwordController.text.trim(),
            );
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Помилка входу: ${e.toString()}"),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("SignIn"), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 15),
              Text("Email"),
              TextFormField(
                controller: _emailController,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Поле з поштою не може бути порожнім";
                  }
                  return null;
                },
              ),
              Text("Password"),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                validator: (v) {
                  if (v == null || v.isEmpty) {
                    return "Поле з паролем не може бути порожнім";
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: () {
                  _signIn();
                },
                child: Text("Увійти"),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signUp');
                },
                child: Text("Зареєструватись"),
              ),
              SizedBox(height: 80),
            ],
          ),
        ),
      ),
    );
  }
}
