import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../domain/entities/task.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';
import 'add_edit_task_page.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = ['Today', 'Tomorrow', 'This Week'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  DateTime _startOfToday() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DateTime _endOfToday() => _startOfToday()
      .add(const Duration(days: 1))
      .subtract(const Duration(milliseconds: 1));

  DateTime _startOfTomorrow() => _startOfToday().add(const Duration(days: 1));

  DateTime _endOfTomorrow() => _startOfTomorrow()
      .add(const Duration(days: 1))
      .subtract(const Duration(milliseconds: 1));

  DateTime _startOfWeek() {
    final today = _startOfToday();
    final weekday = today.weekday;
    return today.subtract(Duration(days: weekday - 1));
  }

  DateTime _endOfWeek() => _startOfWeek()
      .add(const Duration(days: 7))
      .subtract(const Duration(milliseconds: 1));

  bool _isInRange(Task t, DateTime start, DateTime end) {
    return t.dueDate.isAfter(start.subtract(const Duration(milliseconds: 1))) &&
        t.dueDate.isBefore(end.add(const Duration(milliseconds: 1)));
  }

  @override
  Widget build(BuildContext context) {
    final allTasksAsync = ref.watch(allTasksStreamProvider);
    final todayFormatted = DateFormat('EEEE, d MMMM y').format(DateTime.now());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6C63FF),
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.menu, color: Colors.white),
              onPressed: () {},
            ),
            const Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: TextField(
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: 'Search tasks...',
                    hintStyle: TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Color(0xFF5B54D6),
                    isDense: true,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
        ),
        toolbarHeight: 70,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(104),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: Text(
                  todayFormatted,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'My Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              TabBar(
                controller: _tabController,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                indicatorColor: Colors.white,
                tabs: _tabs.map((label) => Tab(text: label)).toList(),
              ),
            ],
          ),
        ),
      ),
      body: allTasksAsync.when(
        data: (allTasks) {
          final todayStart = _startOfToday();
          final todayEnd = _endOfToday();
          final tomorrowStart = _startOfTomorrow();
          final tomorrowEnd = _endOfTomorrow();
          final weekStart = _startOfWeek();
          final weekEnd = _endOfWeek();

          final tasksToday = allTasks
              .where((t) => _isInRange(t, todayStart, todayEnd))
              .toList();
          final tasksTomorrow = allTasks
              .where((t) => _isInRange(t, tomorrowStart, tomorrowEnd))
              .toList();
          final tasksThisWeek =
              allTasks.where((t) => _isInRange(t, weekStart, weekEnd)).toList();

          final List<List<Task>> tabTasks = [
            tasksToday,
            tasksTomorrow,
            tasksThisWeek
          ];

          return TabBarView(
            controller: _tabController,
            children: List.generate(_tabs.length, (index) {
              final tasksForThisTab = tabTasks[index];
              if (tasksForThisTab.isEmpty) {
                return const Center(child: Text('No tasks found.'));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: tasksForThisTab.length,
                itemBuilder: (context, idx) {
                  final task = tasksForThisTab[idx];
                  return TaskCard(task: task);
                },
              );
            }),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Error: ${err.toString()}')),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFF6C63FF),
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => const AddEditTaskPage(),
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: const BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6,
        child: SizedBox(height: 50),
      ),
    );
  }
}
