import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../data_sources/task_remote_data_source.dart';

class TaskRepositoryImpl implements TaskRepository {
  final TaskRemoteDataSource remoteDataSource;

  TaskRepositoryImpl({required this.remoteDataSource});

  @override
  Future<void> addTask(Task task) async {
    return remoteDataSource.addTask(task);
  }

  @override
  Future<void> deleteTask(String taskId) async {
    return remoteDataSource.deleteTask(taskId);
  }

  @override
  Future<void> updateTask(Task task) async {
    return remoteDataSource.updateTask(task);
  }

  @override
  Stream<List<Task>> getAllTasks() {
    return remoteDataSource.getAllTasks();
  }
}
