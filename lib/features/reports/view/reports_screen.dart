import 'package:flutter/material.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports & Analytics", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Weekly Overview", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: _buildStatCard(theme, "Total Hours", "35h 20m", Icons.timer_rounded)),
                const SizedBox(width: 16),
                Expanded(child: _buildStatCard(theme, "Tasks", "24", Icons.task_alt_rounded)),
              ],
            ),
            const SizedBox(height: 32),
            Text("Productivity Trend", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Container(
              height: 200,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Center(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildBar(theme, 40, "Mon"),
                    _buildBar(theme, 70, "Tue"),
                    _buildBar(theme, 60, "Wed"),
                    _buildBar(theme, 90, "Thu", isToday: true),
                    _buildBar(theme, 30, "Fri"),
                    _buildBar(theme, 10, "Sat"),
                    _buildBar(theme, 0, "Sun"),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            Text("Project Distribution", style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildProjectRow(theme, "ChatUAPP", 0.45, theme.colorScheme.primary),
            _buildProjectRow(theme, "POS System", 0.35, Colors.orange),
            _buildProjectRow(theme, "Ecommerce", 0.20, Colors.green),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(ThemeData theme, String title, String value, IconData icon) {
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
          Row(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(width: 8),
              Text(title, style: theme.textTheme.bodyMedium),
            ],
          ),
          const SizedBox(height: 12),
          Text(value, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Widget _buildBar(ThemeData theme, double heightRatio, String label, {bool isToday = false}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          width: 24,
          height: heightRatio,
          decoration: BoxDecoration(
            color: isToday ? theme.colorScheme.primary : theme.colorScheme.primary.withValues(alpha: 0.2),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: theme.textTheme.bodySmall?.copyWith(fontWeight: isToday ? FontWeight.bold : null)),
      ],
    );
  }

  Widget _buildProjectRow(ThemeData theme, String name, double pct, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(name, style: theme.textTheme.bodyMedium)),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(color),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(width: 12),
          Text('${(pct * 100).toInt()}%', style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}
