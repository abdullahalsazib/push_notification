import 'dart:async';

import 'package:flutter/material.dart';
import 'package:my_app/reuseable/connectivity_service.dart';
import 'package:my_app/view/user_details_screen.dart';
import 'package:my_app/viewmodels/user_view_model.dart';
import 'package:provider/provider.dart';

class UsersScreen extends StatefulWidget {
  const UsersScreen({super.key});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late final StreamSubscription<bool> _connectionSubscription;

  bool isOffline = false;
  bool _hasInitialConnectionState = false;

  @override
  void initState() {
    super.initState();

    _initializeConnectivity();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchUsersIfOnline();
    });
  }

  Future<void> _initializeConnectivity() async {
    final hasConnection = await ConnectivityService().checkConnection();

    if (!mounted) return;

    setState(() {
      isOffline = !hasConnection;
      _hasInitialConnectionState = true;
    });

    _connectionSubscription = ConnectivityService().connectionstream.listen((
      isConnected,
    ) {
      if (!mounted) return;

      final wasOffline = isOffline;

      setState(() {
        isOffline = !isConnected;
      });

      // Internet came back
      if (wasOffline && isConnected) {
        ScaffoldMessenger.of(context).hideCurrentSnackBar();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Row(
              children: [
                Icon(Icons.wifi_rounded, color: Colors.white),
                SizedBox(width: 8),
                Text('Back online'),
              ],
            ),
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 2),
          ),
        );

        // Refresh users automatically after connection returns.
        context.read<UserViewModel>().fetchUsers();
      }
    });
  }

  Future<void> _fetchUsersIfOnline() async {
    final hasConnection = await ConnectivityService().checkConnection();

    if (!mounted) return;

    if (!hasConnection) {
      setState(() {
        isOffline = true;
      });
      return;
    }

    await context.read<UserViewModel>().fetchUsers();
  }

  @override
  void dispose() {
    if (_hasInitialConnectionState) {
      _connectionSubscription.cancel();
    }

    super.dispose();
  }

  Future<void> _onRefresh() async {
    final hasConnection = await ConnectivityService().checkConnection();

    if (!hasConnection) {
      if (!mounted) return;

      setState(() {
        isOffline = true;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Row(
            children: [
              Icon(Icons.wifi_off_rounded, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text('You are offline. Please connect to the internet.'),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
        ),
      );

      return;
    }

    await context.read<UserViewModel>().fetchUsers();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final viewModel = context.watch<UserViewModel>();

    return Scaffold(
      backgroundColor:
          theme.colorScheme.surfaceBright ?? const Color(0xFFF8F9FA),

      appBar: AppBar(
        title: const Text(
          'Users Directory',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 22,
            color: Colors.black,
          ),
        ),
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: theme.colorScheme.surface,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'Refresh',
            onPressed: viewModel.isLoading ? null : _onRefresh,
          ),
        ],
      ),

      body: Column(
        children: [
          // Offline banner
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: isOffline ? 42 : 0,
            width: double.infinity,
            color: theme.colorScheme.error,
            child: isOffline
                ? SafeArea(
                    bottom: false,
                    child: Row(
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
                    ),
                  )
                : null,
          ),

          Expanded(
            child: RefreshIndicator(
              onRefresh: _onRefresh,
              child: _buildBody(context, viewModel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context, UserViewModel viewModel) {
    if (viewModel.isLoading && viewModel.users.isEmpty) {
      return const Center(child: CircularProgressIndicator.adaptive());
    }

    if (viewModel.error != null && viewModel.users.isEmpty) {
      return _buildErrorState(context, viewModel.error!);
    }

    if (viewModel.users.isEmpty) {
      return _buildEmptyState(context);
    }

    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      itemCount: viewModel.users.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final user = viewModel.users[index];

        return _UserCard(
          user: user,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => UserDetailsScreen(user: user),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildErrorState(BuildContext context, String error) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.errorContainer.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline_rounded,
                size: 40,
                color: theme.colorScheme.error,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              'Something went wrong',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              error,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),

            const SizedBox(height: 20),

            FilledButton.tonalIcon(
              onPressed: _onRefresh,
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.people_outline_rounded,
              size: 64,
              color: theme.colorScheme.outline.withValues(alpha: 0.5),
            ),

            const SizedBox(height: 16),

            Text(
              'No users found',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'The user list is currently empty. '
              'Pull down to refresh.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  final dynamic user;
  final VoidCallback onTap;

  const _UserCard({required this.user, required this.onTap});

  String _getInitials(String name) {
    final parts = name.trim().split(RegExp(r'\s+'));

    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }

    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  Color _getAvatarColor(int id, ColorScheme colors) {
    final palette = [
      colors.primary,
      colors.secondary,
      colors.tertiary,
      Colors.indigo,
      Colors.teal,
      Colors.deepPurple,
    ];

    return palette[id.abs() % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final avatarColor = _getAvatarColor(
      user.id is int ? user.id : 0,
      theme.colorScheme,
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: avatarColor.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _getInitials(user.name ?? ''),
                    style: TextStyle(
                      color: avatarColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name ?? 'Unknown',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                      const SizedBox(height: 4),

                      Row(
                        children: [
                          Icon(
                            Icons.mail_outline_rounded,
                            size: 14,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),

                          const SizedBox(width: 4),

                          Expanded(
                            child: Text(
                              user.email ?? '',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.4,
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 12,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
