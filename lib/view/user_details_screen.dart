import 'package:flutter/material.dart';

class UserDetailsScreen extends StatelessWidget {
  final dynamic user;

  const UserDetailsScreen({super.key, required this.user});

  String _getInitials(String? name) {
    if (name == null || name.trim().isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  String _safeField(
    dynamic Function() getter, [
    String fallback = 'Not specified',
  ]) {
    try {
      final value = getter();
      if (value == null || value.toString().trim().isEmpty) return fallback;
      return value.toString();
    } catch (_) {
      return fallback;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final userName = _safeField(() => user.name, 'User Details');
    final userEmail = _safeField(() => user.email, 'No email provided');

    return Scaffold(
      backgroundColor:
          theme.colorScheme.surfaceBright ?? const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: 'Share profile',
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          children: [
            // Profile Card Header
            _buildProfileHeader(theme, userName, userEmail),
            const SizedBox(height: 20),

            // Quick Actions Row
            _buildQuickActions(theme),
            const SizedBox(height: 24),

            // Contact Information Section
            _buildInfoCard(
              theme,
              title: 'Contact Details',
              items: [
                _InfoTile(
                  icon: Icons.email_outlined,
                  label: 'Email Address',
                  value: userEmail,
                ),
                _InfoTile(
                  icon: Icons.phone_outlined,
                  label: 'Phone Number',
                  value: _safeField(() => user.phone),
                ),
                _InfoTile(
                  icon: Icons.language_rounded,
                  label: 'Website',
                  value: _safeField(() => user.website),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Organization & Location Section
            _buildInfoCard(
              theme,
              title: 'Account & Organization',
              items: [
                _InfoTile(
                  icon: Icons.tag_rounded,
                  label: 'User ID',
                  value: '#${_safeField(() => user.id.toString(), '0')}',
                ),
                _InfoTile(
                  icon: Icons.apartment_rounded,
                  label: 'Company',
                  value: _safeField(
                    () => user.company is String
                        ? user.company
                        : user.company?.name,
                  ),
                ),
                _InfoTile(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
                  value: _safeField(
                    () => user.address is String
                        ? user.address
                        : user.address?.city,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(ThemeData theme, String name, String email) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              _getInitials(name),
              style: TextStyle(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 28,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            name,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            email,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            icon: Icons.mail_rounded,
            label: 'Email',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.phone_rounded,
            label: 'Call',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ActionButton(
            icon: Icons.chat_bubble_outline_rounded,
            label: 'Message',
            onTap: () {},
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(
    ThemeData theme, {
    required String title,
    required List<_InfoTile> items,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: 16),
          ...items.expand(
            (item) => [
              item,
              if (item != items.last)
                Divider(
                  height: 24,
                  thickness: 0.7,
                  color: theme.colorScheme.outlineVariant.withValues(
                    alpha: 0.4,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.colorScheme.surfaceContainerHigh.withValues(alpha: 0.6),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            children: [
              Icon(icon, size: 20, color: theme.colorScheme.primary),
              const SizedBox(height: 6),
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainerHighest.withValues(
              alpha: 0.4,
            ),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            size: 20,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
