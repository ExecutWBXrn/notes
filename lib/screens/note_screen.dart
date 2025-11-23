import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_flutter_studying_project/providers/auth_provider.dart';
import 'package:image_picker/image_picker.dart';

class NoteScreen extends ConsumerStatefulWidget {
  const NoteScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return _NoteScreenState();
  }
}

class _NoteScreenState extends ConsumerState<NoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _nameController = TextEditingController();

  Future<void> pickAndUploadAvatar() async {
    final ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile == null) return;

    final File imageFile = File(pickedFile.path);

    try {
      final avatarRepo = ref.read(avatarRepositoryProvider);
      await avatarRepo.uploadAvatar(imageFile);
      ref.refresh(avatarUrlProvider);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Не вдалося завантажити аватар")));
    }
  }

  Future<void> _saveNote({String? id, String? name, String? content}) async {
    try {
      if (id != null) {
        _nameController.text = name!;
        _contentController.text = content!;
      }
      await showDialog(
        context: context,
        builder: (BuildContext dialogContext) => Dialog(
          backgroundColor: Colors.purple.shade100,
          child: Container(
            width: 100,
            height: 350,
            padding: EdgeInsets.all(15),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Text(
                    "Створити нотатку",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      hintText: "Ведіть назву нотатки тут",
                    ),
                    autofocus: true,
                    controller: _nameController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Назва нотатки не може бути порожньою";
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "Ведіть нотатку тут"),
                    maxLines: 4,
                    autofocus: true,
                    controller: _contentController,
                    validator: (v) {
                      if (v == null || v.isEmpty) {
                        return "Поле з контеном не може бути порожнім";
                      }
                      return null;
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex: 9,
                        child: ElevatedButton(
                          onPressed: () async {
                            if (id == null) {
                              await ref
                                  .read(noteRepositoryProvider)
                                  .createNote(
                                    _nameController.text,
                                    _contentController.text,
                                  );
                            } else {
                              await ref
                                  .read(noteRepositoryProvider)
                                  .updateNote(
                                    id,
                                    _nameController.text,
                                    _contentController.text,
                                  );
                            }
                            _nameController.clear();
                            _contentController.clear();
                            Navigator.pop(dialogContext);
                          },
                          child: Text("Зберегти"),
                        ),
                      ),
                      Expanded(flex: 1, child: SizedBox()),
                      Expanded(
                        flex: 9,
                        child: ElevatedButton(
                          onPressed: () {
                            _nameController.clear();
                            _contentController.clear();
                            Navigator.pop(dialogContext);
                          },
                          child: Text("Скасувати"),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    } catch (e) {
      print("Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Не вийшло зберегти нотатку, спробуйте ще раз!"),
        ),
      );
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final noteRepo = ref.read(noteRepositoryProvider);

    final noteStream = ref.watch(getNotesStreamProvider);

    final authRepo = ref.read(authRepositoryProvider);

    final getAvatar = ref.watch(avatarUrlProvider);

    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.all(8),
          child: GestureDetector(
            onTap: () {
              pickAndUploadAvatar();
            },
            child: getAvatar.when(
              data: (data) {
                if (data == null) {
                  return const CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.person, color: Colors.black),
                  );
                }
                return CircleAvatar(backgroundImage: NetworkImage(data));
              },
              error: (error, s) {
                return const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.black),
                );
              },
              loading: () {
                return const CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.black),
                );
              },
            ),
          ),
        ),
        title: Text("Notes"),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              authRepo.signOut();
            },
            icon: Icon(Icons.logout),
          ),
        ],
      ),
      body: Center(
        child: noteStream.when(
          data: (data) {
            if (data.isEmpty) {
              return Text("У вас поки немає нотаток");
            }
            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(data[index].name),
                  subtitle: Text(
                    data[index].content,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: IconButton(
                    onPressed: () {
                      noteRepo.deleteNote(data[index].id);
                    },
                    icon: Icon(Icons.delete_outlined, color: Colors.red),
                  ),
                  onTap: () {
                    _saveNote(
                      id: data[index].id,
                      name: data[index].name,
                      content: data[index].content,
                    );
                  },
                );
              },
            );
          },
          error: (e, s) {
            print("Error: $e");
            return Text("Error");
          },
          loading: () {
            return const CircularProgressIndicator();
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _saveNote();
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
