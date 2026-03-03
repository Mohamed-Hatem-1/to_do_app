import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/task_model.dart';

class TasksRepo {
  final _db = FirebaseFirestore.instance;
  final String uid;

  TasksRepo({required this.uid});

  CollectionReference<Map<String, dynamic>> get _tasksRef =>
      _db.collection('users').doc(uid).collection('tasks');

  Stream<List<TaskModel>> watchTasks() {
    return _tasksRef
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs.map(TaskModel.fromDoc).toList());
  }

  Stream<TaskModel?> watchTaskById(String taskId) {
    return _tasksRef.doc(taskId).snapshots().map((doc) {
      if (!doc.exists) return null;
      final data = doc.data();
      if (data == null) return null;
      return TaskModel.fromDoc(doc);
    });
  }

  Future<void> addTask({
    required String title,
    required String description,
  }) async {
    await _tasksRef.add(
      TaskModel(
        id: '',
        title: title,
        description: description,
        createdAt: DateTime.now(),
      ).toMap(),
    );
  }

  Future<void> deleteTask(String taskId) async {
    await _tasksRef.doc(taskId).delete();
  }

  Future<void> updateTask({
    required String taskId,
    required String title,
    required String description,
  }) async {
    await _tasksRef.doc(taskId).update({
      'title': title,
      'description': description,
    });
  }
}
