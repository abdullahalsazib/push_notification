import 'package:flutter/material.dart';

class OfflineBanner extends StatelessWidget {
  final bool isOffline;

  const OfflineBanner({super.key, required this.isOffline});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      height: isOffline ? 42 : 0,
      width: double.infinity,
      color: theme.colorScheme.error,
      child: isOffline
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.wifi_off_rounded,
                  size: 18,
                  color: theme.colorScheme.onError,
                ),
                const SizedBox(width: 8),
                Text(
                  'You are offline. Please connect to the internet.',
                  style: TextStyle(
                    color: theme.colorScheme.onError,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            )
          : null,
    );
  }
}
