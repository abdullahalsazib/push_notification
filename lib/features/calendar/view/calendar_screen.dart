import 'package:flutter/material.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calendar", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("September 2026", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          IconButton(icon: const Icon(Icons.chevron_left_rounded), onPressed: () {}),
                          IconButton(icon: const Icon(Icons.chevron_right_rounded), onPressed: () {}),
                        ],
                      )
                    ],
                  ),
                  const SizedBox(height: 16),
                  _buildCalendarGrid(theme),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: _buildAgendaView(theme),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(ThemeData theme) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: days.map((d) => Text(d, style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold))).toList(),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          itemCount: 30,
          itemBuilder: (context, index) {
            final isToday = index == 17; // 18th is index 17
            final hasActivity = [2, 5, 10, 11, 15, 17].contains(index);
            
            return Container(
              decoration: BoxDecoration(
                color: isToday ? theme.colorScheme.primary : (hasActivity ? theme.colorScheme.primary.withValues(alpha: 0.1) : null),
                borderRadius: BorderRadius.circular(8),
              ),
              alignment: Alignment.center,
              child: Text(
                '${index + 1}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isToday ? theme.colorScheme.onPrimary : null,
                  fontWeight: isToday || hasActivity ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildAgendaView(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("September 18, 2026", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Expanded(
          child: ListView(
            children: [
              _AgendaItem(title: "Authentication API", time: "09:00 AM - 11:30 AM", type: "Task"),
              _AgendaItem(title: "Team Sync", time: "12:00 PM - 01:00 PM", type: "Meeting"),
              _AgendaItem(title: "Dashboard UI", time: "02:00 PM - 05:00 PM", type: "Task"),
            ],
          ),
        ),
      ],
    );
  }
}

class _AgendaItem extends StatelessWidget {
  final String title;
  final String time;
  final String type;

  const _AgendaItem({required this.title, required this.time, required this.type});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
          Container(
            width: 4,
            height: 40,
            decoration: BoxDecoration(
              color: type == "Meeting" ? theme.colorScheme.error : theme.colorScheme.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Text(time, style: theme.textTheme.bodySmall),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(type, style: theme.textTheme.bodySmall?.copyWith(fontSize: 10)),
          ),
        ],
      ),
    );
  }
}
