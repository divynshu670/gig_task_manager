import '../entities/task.dart';
import '../repositories/task_repository.dart';

class EditTask {
  final TaskRepository repository;

  EditTask(this.repository);

  Future<void> call(Task task) {
    return repository.updateTask(task);
  }
}
