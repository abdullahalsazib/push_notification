import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:my_app/providers/timer_provider.dart';

class TimerBottomSheet extends StatelessWidget {
  const TimerBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const TimerBottomSheet(),
    );
  }

  String _formatTime(int seconds) {
    int h = seconds ~/ 3600;
    int m = (seconds % 3600) ~/ 60;
    int s = seconds % 60;
    return '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timerProvider = context.watch<TimerProvider>();
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 40, height: 4, decoration: BoxDecoration(color: theme.colorScheme.outline, borderRadius: BorderRadius.circular(2))),
            const SizedBox(height: 24),
            Text("Working on", style: theme.textTheme.bodyMedium),
            const SizedBox(height: 8),
            Text(timerProvider.activeTask?.title ?? "General Work", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 32),
            Text(_formatTime(timerProvider.seconds), style: theme.textTheme.displayLarge?.copyWith(fontFeatures: const [FontFeature.tabularFigures()])),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      timerProvider.stopTimer();
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          title: const Text("Stop tracking this work?"),
                          content: const Text("Your time will be saved locally."),
                          actions: [
                            TextButton(onPressed: () => ctx.pop(), child: const Text("Cancel")),
                            FilledButton(
                              onPressed: () {
                                timerProvider.clear();
                                ctx.pop();
                                context.pop(); // close bottom sheet
                              },
                              child: const Text("Save"),
                            ),
                          ],
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: const Text("Stop"),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () => context.read<TimerProvider>().toggleTimer(),
                    style: FilledButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: Text(timerProvider.isRunning ? "Pause" : "Start"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
