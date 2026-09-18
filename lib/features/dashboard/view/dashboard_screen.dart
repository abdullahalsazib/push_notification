import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:my_app/data/models/task_model.dart';
import 'package:my_app/data/repositories/mock_repository.dart';
import 'package:my_app/features/timer/view/timer_bottom_sheet.dart';
import 'package:my_app/providers/work_provider.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = MockRepository().getCurrentUser(); // Just getting sync for now

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context, user, theme),
              const SizedBox(height: 32),
              _buildProgressCard(context, theme),
              const SizedBox(height: 24),
              _buildStatsRow(context, theme),
              const SizedBox(height: 32),
              _buildQuickActions(context, theme),
              const SizedBox(height: 32),
              _buildTodaysWork(context, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, user, ThemeData theme) {
    String formattedDate = DateFormat('EEEE, MMMM d, y').format(DateTime.now());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good morning, ${user.name}',
                style: theme.textTheme.titleLarge,
              ),
              const SizedBox(height: 4),
              Text(formattedDate, style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
        Row(
          children: [
            IconButton(
              icon: const Icon(Icons.notifications_none_rounded),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(user.avatarUrl),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildProgressCard(BuildContext context, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Today's Progress",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "78%",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text("7 / 9 Tasks Completed", style: theme.textTheme.bodyMedium),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: 0.78,
              minHeight: 8,
              backgroundColor: theme.colorScheme.primary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                theme.colorScheme.primary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow(BuildContext context, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(
            title: "Working Time",
            value: "6h 42m",
            subtitle: "Target: 8h 00m",
            icon: Icons.access_time_rounded,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _StatCard(
            title: "Productivity",
            value: "82%",
            subtitle: "+5% from yesterday",
            icon: Icons.trending_up_rounded,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Actions",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            _ActionBtn(
              icon: Icons.add_rounded, 
              label: "Add Work",
              onTap: () => context.push('/add-work'),
            ),
            _ActionBtn(
              icon: Icons.timer_outlined, 
              label: "Timer",
              onTap: () => TimerBottomSheet.show(context),
            ),
            _ActionBtn(
              icon: Icons.task_alt_rounded, 
              label: "Add Task",
              onTap: () => context.push('/add-work'),
            ),
            _ActionBtn(
              icon: Icons.summarize_outlined, 
              label: "Report",
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTodaysWork(BuildContext context, ThemeData theme) {
    return Consumer<WorkProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final tasks = provider.tasks;
        if (tasks.isEmpty) {
          return const Text("No tasks for today.");
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Today's Work",
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextButton(onPressed: () {}, child: const Text("View all")),
              ],
            ),
            const SizedBox(height: 8),
            ...tasks.map((task) => _TaskTile(task: task)),
          ],
        );
      },
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;

  const _StatCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: theme.colorScheme.primary, size: 24),
          const SizedBox(height: 12),
          Text(title, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(value, style: theme.textTheme.titleLarge),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(fontSize: 10),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: IconButton(
            icon: Icon(icon, color: theme.colorScheme.primary),
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _TaskTile extends StatelessWidget {
  final TaskModel task;

  const _TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    IconData statusIcon;
    Color statusColor;

    switch (task.status) {
      case TaskStatus.completed:
        statusIcon = Icons.check_circle_rounded;
        statusColor = theme.colorScheme.error == const Color(0xFFDC2626)
            ? const Color(0xFF16A34A)
            : const Color(0xFF4ADE80);
        break;
      case TaskStatus.inProgress:
        statusIcon = Icons.motion_photos_on_rounded;
        statusColor = theme.colorScheme.primary;
        break;
      default:
        statusIcon = Icons.radio_button_unchecked_rounded;
        statusColor = theme.colorScheme.onSurfaceVariant;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () {
              final newStatus = task.status == TaskStatus.completed ? TaskStatus.planned : TaskStatus.completed;
              final updated = TaskModel(
                id: task.id,
                title: task.title,
                projectId: task.projectId,
                status: newStatus,
                priority: task.priority,
                estimatedMinutes: task.estimatedMinutes,
                actualMinutes: task.actualMinutes,
              );
              context.read<WorkProvider>().updateTask(updated);
            },
            child: Icon(statusIcon, color: statusColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  task.title,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    decoration: task.status == TaskStatus.completed
                        ? TextDecoration.lineThrough
                        : null,
                    color: task.status == TaskStatus.completed
                        ? theme.colorScheme.onSurfaceVariant
                        : null,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      "Project: ${task.projectId}",
                      style: theme.textTheme.bodySmall,
                    ),
                    const SizedBox(width: 12),
                    if (task.actualMinutes > 0)
                      Text(
                        "${task.actualMinutes}m",
                        style: theme.textTheme.bodySmall,
                      ),
                  ],
                ),
              ],
            ),
          ),
          if (task.status != TaskStatus.completed)
            IconButton(
              icon: Icon(
                Icons.play_circle_fill_rounded,
                color: theme.colorScheme.primary,
              ),
              onPressed: () {},
            ),
        ],
      ),
    );
  }
}
