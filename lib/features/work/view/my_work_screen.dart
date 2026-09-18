import 'package:flutter/material.dart';
import 'package:my_app/data/models/task_model.dart';
import 'package:my_app/features/timer/view/timer_bottom_sheet.dart';
import 'package:my_app/providers/timer_provider.dart';
import 'package:my_app/providers/work_provider.dart';
import 'package:provider/provider.dart';

class MyWorkScreen extends StatefulWidget {
  const MyWorkScreen({super.key});

  @override
  State<MyWorkScreen> createState() => _MyWorkScreenState();
}

class _MyWorkScreenState extends State<MyWorkScreen> {
  String _searchQuery = '';
  TaskStatus? _statusFilter;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Work",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_task_rounded),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          _buildFilters(theme),
          Expanded(child: _buildTaskList(theme)),
        ],
      ),
    );
  }

  Widget _buildFilters(ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: "Search tasks...",
              prefixIcon: const Icon(Icons.search_rounded),
              filled: true,
              fillColor: theme.colorScheme.surface,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: theme.colorScheme.outline),
              ),
              contentPadding: EdgeInsets.zero,
            ),
          ),
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: TaskStatus.values.map((status) {
                final isSelected = _statusFilter == status;
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(status.name.toUpperCase()),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _statusFilter = selected ? status : null;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(ThemeData theme) {
    return Consumer<WorkProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        var tasks = provider.tasks;
        if (_searchQuery.isNotEmpty) {
          tasks = tasks
              .where(
                (t) =>
                    t.title.toLowerCase().contains(_searchQuery.toLowerCase()),
              )
              .toList();
        }
        if (_statusFilter != null) {
          tasks = tasks.where((t) => t.status == _statusFilter).toList();
        }

        if (tasks.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.assignment_turned_in_rounded,
                  size: 64,
                  color: theme.colorScheme.outline,
                ),
                const SizedBox(height: 16),
                Text("No tasks found", style: theme.textTheme.titleMedium),
                const SizedBox(height: 8),
                Text(
                  "Add a new task to get started.",
                  style: theme.textTheme.bodyMedium,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                title: Text(
                  task.title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    decoration: task.status == TaskStatus.completed
                        ? TextDecoration.lineThrough
                        : null,
                  ),
                ),
                subtitle: Text(
                  "Project: ${task.projectId}  •  ${task.status.name}",
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (task.status != TaskStatus.completed)
                      IconButton(
                        icon: Icon(
                          Icons.play_arrow_rounded,
                          color: theme.colorScheme.primary,
                        ),
                        onPressed: () {
                          context.read<TimerProvider>().setTask(task);
                          TimerBottomSheet.show(context);
                          context.read<TimerProvider>().toggleTimer();
                        },
                      ),
                    IconButton(
                      icon: Icon(
                        task.status == TaskStatus.completed
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: task.status == TaskStatus.completed
                            ? Colors.green
                            : theme.colorScheme.outline,
                      ),
                      onPressed: () {
                        final newStatus = task.status == TaskStatus.completed
                            ? TaskStatus.planned
                            : TaskStatus.completed;
                        final updated = TaskModel(
                          id: task.id,
                          title: task.title,
                          projectId: task.projectId,
                          status: newStatus,
                          priority: task.priority,
                          estimatedMinutes: task.estimatedMinutes,
                          actualMinutes: task.actualMinutes,
                        );
                        provider.updateTask(updated);
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
