import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import '../pages/add_edit_task_page.dart';

class TaskCard extends ConsumerWidget {
  final Task task;

  const TaskCard({Key? key, required this.task}) : super(key: key);

  // Define colors for text based on priority
  Color _textColorForPriority(Priority p) {
    switch (p) {
      case Priority.low:
        return const Color(0xFF2E7D32); // Dark green
      case Priority.medium:
        return const Color(0xFFF57F17); // Dark orange
      case Priority.high:
        return const Color(0xFFC62828); // Dark red
    }
  }

  // Define background colors for priority tags
  Color _priorityColor(Priority p) {
    switch (p) {
      case Priority.low:
        return Colors.green.shade400;
      case Priority.medium:
        return Colors.orange.shade400;
      case Priority.high:
        return Colors.red.shade400;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deleteUseCase = ref.watch(deleteTaskUseCaseProvider);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      elevation: 2,
      child: ListTile(
        onTap: () {
          // Open edit page
          Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddEditTaskPage(existingTask: task)));
        },
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (val) {
            // Toggle completion:
            final updated = task.copyWith(isCompleted: val ?? false);
            ref.read(editTaskUseCaseProvider)(updated);
          },
        ),
        title: Text(
          task.title,
          style: TextStyle(
            decoration: task.isCompleted ? TextDecoration.lineThrough : null,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (task.description.isNotEmpty)
              Text(
                task.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            const SizedBox(height: 4),
            Row(
              children: [
                // Priority tag
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: _priorityColor(task.priority).withOpacity(0.2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    task.priority.name.toUpperCase(),
                    style: TextStyle(
                      // Use the fixed text color instead of .shade700
                      color: _textColorForPriority(task.priority),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Due date
                Text(
                  '${task.dueDate.day}/${task.dueDate.month}/${task.dueDate.year}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            )
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.redAccent),
          onPressed: () {
            deleteUseCase(task.id);
          },
        ),
      ),
    );
  }
}
