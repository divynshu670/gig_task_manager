import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/task.dart';
import '../model/task_model.dart';

abstract class TaskRemoteDataSource {
  Future<void> addTask(Task task);

  Future<void> updateTask(Task task);

  Future<void> deleteTask(String taskId);

  Stream<List<Task>> getAllTasks();
}

class TaskRemoteDataSourceImpl implements TaskRemoteDataSource {
  final FirebaseFirestore _firestore;
  static const String _collectionName = 'tasks';

  TaskRemoteDataSourceImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> addTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    await _firestore
        .collection(_collectionName)
        .doc(task.id)
        .set(model.toJson());
  }

  @override
  Future<void> updateTask(Task task) async {
    final model = TaskModel.fromEntity(task);
    await _firestore
        .collection(_collectionName)
        .doc(task.id)
        .update(model.toJson());
  }

  @override
  Future<void> deleteTask(String taskId) async {
    await _firestore.collection(_collectionName).doc(taskId).delete();
  }

  @override
  Stream<List<Task>> getAllTasks() {
    return _firestore
        .collection(_collectionName)
        .orderBy('dueDate', descending: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
              return TaskModel.fromJson(doc.data()).toEntity();
            }).toList());
  }
}
