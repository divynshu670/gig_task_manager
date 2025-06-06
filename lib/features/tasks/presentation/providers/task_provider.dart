import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/data_sources/task_remote_data_source.dart';
import '../../data/repository/task_repository_impl.dart';
import '../../domain/entities/task.dart';
import '../../domain/repositories/task_repository.dart';
import '../../domain/usecases/add_task.dart';
import '../../domain/usecases/delete_task.dart';
import '../../domain/usecases/edit_task.dart';
import '../../domain/usecases/filter_task.dart';
import '../../domain/usecases/view_task.dart';

final taskRemoteDataSourceProvider = Provider<TaskRemoteDataSource>((ref) {
  return TaskRemoteDataSourceImpl();
});

final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final remoteSource = ref.watch(taskRemoteDataSourceProvider);
  return TaskRepositoryImpl(remoteDataSource: remoteSource);
});

final getAllTasksUseCaseProvider = Provider((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return GetAllTasks(repo);
});

final addTaskUseCaseProvider = Provider((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return AddTask(repo);
});

final editTaskUseCaseProvider = Provider((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return EditTask(repo);
});

final deleteTaskUseCaseProvider = Provider((ref) {
  final repo = ref.watch(taskRepositoryProvider);
  return DeleteTask(repo);
});

final allTasksStreamProvider = StreamProvider<List<Task>>((ref) {
  final getAll = ref.watch(getAllTasksUseCaseProvider);
  return getAll();
});

final priorityFilterProvider = StateProvider<Priority?>((ref) => null);
final statusFilterProvider = StateProvider<bool?>((ref) => null);

final filteredTasksProvider = Provider<AsyncValue<List<Task>>>((ref) {
  final allTasksAsync = ref.watch(allTasksStreamProvider);
  final byPriority = ref.watch(priorityFilterProvider);
  final byStatus = ref.watch(statusFilterProvider);

  return allTasksAsync.whenData((tasks) {
    final filtered = FilterTasks()(
      tasks: tasks,
      byPriority: byPriority,
      byCompletion: byStatus,
    );
    return filtered;
  });
});
