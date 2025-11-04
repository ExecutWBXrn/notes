import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  String id;
  String name;
  String content;
  DateTime createdAt;

  Note({
    required this.id,
    required this.name,
    required this.content,
    required this.createdAt,
  });

  factory Note.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data()!;
    return Note(
      id: snapshot.id,
      name: data['name'],
      content: data['content'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {'name': name, 'content': content, 'createdAt': createdAt};
  }
}
