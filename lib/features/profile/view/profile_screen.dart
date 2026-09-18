import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22)),
        actions: [
          IconButton(icon: const Icon(Icons.settings_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: theme.colorScheme.primaryContainer,
                  child: Text("JD", style: theme.textTheme.headlineLarge?.copyWith(color: theme.colorScheme.onPrimaryContainer)),
                ),
                const SizedBox(height: 16),
                Text("Jack Developer", style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("Senior Flutter Engineer", style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
          const SizedBox(height: 32),
          _buildSectionHeader(theme, "Account"),
          _buildListTile(theme, Icons.person_outline, "Personal Information"),
          _buildListTile(theme, Icons.work_outline, "Work Preferences"),
          _buildListTile(theme, Icons.notifications_outlined, "Notifications"),
          
          const SizedBox(height: 24),
          _buildSectionHeader(theme, "Preferences"),
          _buildListTile(theme, Icons.dark_mode_outlined, "Theme Settings"),
          _buildListTile(theme, Icons.language_outlined, "Language"),
          
          const SizedBox(height: 32),
          FilledButton.tonal(
            onPressed: () {},
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              foregroundColor: theme.colorScheme.error,
              backgroundColor: theme.colorScheme.error.withValues(alpha: 0.1),
            ),
            child: const Text("Log Out"),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, left: 16),
      child: Text(
        title.toUpperCase(),
        style: theme.textTheme.labelMedium?.copyWith(
          color: theme.colorScheme.primary,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildListTile(ThemeData theme, IconData icon, String title) {
    return ListTile(
      leading: Icon(icon, color: theme.colorScheme.onSurfaceVariant),
      title: Text(title, style: theme.textTheme.bodyLarge),
      trailing: const Icon(Icons.chevron_right_rounded, size: 20),
      onTap: () {},
    );
  }
}
