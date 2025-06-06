
import '../entities/task.dart';
import '../repositories/task_repository.dart';

class GetAllTasks {
  final TaskRepository repository;

  GetAllTasks(this.repository);

  Stream<List<Task>> call() {
    return repository.getAllTasks();
  }
}
