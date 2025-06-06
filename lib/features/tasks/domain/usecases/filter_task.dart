import '../entities/task.dart';

class FilterTasks {
  List<Task> call({
    required List<Task> tasks,
    Priority? byPriority,
    bool? byCompletion,
  }) {
    Iterable<Task> result = tasks;

    if (byPriority != null) {
      result = result.where((t) => t.priority == byPriority);
    }
    if (byCompletion != null) {
      result = result.where((t) => t.isCompleted == byCompletion);
    }

    return result.toList();
  }
}
