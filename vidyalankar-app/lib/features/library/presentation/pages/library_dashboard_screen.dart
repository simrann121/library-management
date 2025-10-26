// Library Dashboard Screen for Vidyalankar Library Management System

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as app_error;
import '../bloc/library_bloc.dart';

class LibraryDashboardScreen extends StatefulWidget {
  const LibraryDashboardScreen({super.key});

  @override
  State<LibraryDashboardScreen> createState() => _LibraryDashboardScreenState();
}

class _LibraryDashboardScreenState extends State<LibraryDashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load library data when screen initializes
    context.read<LibraryBloc>().add(LoadLibraryData());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LibraryBloc, LibraryState>(
      listener: (context, state) {
        if (state is LibraryError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is LibraryLoading) {
          return const LoadingWidget(message: 'Loading library data...');
        }

        if (state is LibraryError) {
          return app_error.ErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<LibraryBloc>().add(LoadLibraryData());
            },
          );
        }

        if (state is LibraryLoaded) {
          return _buildDashboard(state);
        }

        return const LoadingWidget();
      },
    );
  }

  Widget _buildDashboard(LibraryLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Welcome Section
          _buildWelcomeSection(state),

          const SizedBox(height: AppConstants.largePadding),

          // Library Status Card
          _buildLibraryStatusCard(state),

          const SizedBox(height: AppConstants.defaultPadding),

          // Quick Actions
          _buildQuickActions(),

          const SizedBox(height: AppConstants.defaultPadding),

          // Library Stats
          _buildLibraryStats(state),

          const SizedBox(height: AppConstants.defaultPadding),

          // Recent Activity
          _buildRecentActivity(state),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection(LibraryLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Icon(
                    Icons.library_books,
                    size: 30,
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome to ${state.collegeName} Library',
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        'Access books, study spaces, and digital resources',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.lightTextSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLibraryStatusCard(LibraryLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Library Status',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: state.isOpen
                        ? AppTheme.successColor
                        : AppTheme.errorColor,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: AppConstants.smallPadding),
                Text(
                  state.isOpen ? 'Open' : 'Closed',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: state.isOpen
                            ? AppTheme.successColor
                            : AppTheme.errorColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                Text(
                  '${state.currentOccupancy}/${state.maxCapacity}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.smallPadding),
            LinearProgressIndicator(
              value: state.maxCapacity > 0
                  ? state.currentOccupancy / state.maxCapacity
                  : 0,
              backgroundColor: AppTheme.lightBorderColor,
              valueColor: AlwaysStoppedAnimation<Color>(
                state.currentOccupancy / state.maxCapacity > 0.8
                    ? AppTheme.warningColor
                    : AppTheme.successColor,
              ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              'Current occupancy: ${state.currentOccupancy} people',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTextSecondary,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: AppConstants.defaultPadding),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisSpacing: AppConstants.defaultPadding,
          mainAxisSpacing: AppConstants.defaultPadding,
          childAspectRatio: 1.5,
          children: [
            _buildActionCard(
              icon: Icons.qr_code_scanner,
              title: 'Scan QR',
              subtitle: 'Enter library',
              onTap: () {
                // Handle QR scan
              },
            ),
            _buildActionCard(
              icon: Icons.search,
              title: 'Search Books',
              subtitle: 'Find resources',
              onTap: () {
                // Navigate to books search
              },
            ),
            _buildActionCard(
              icon: Icons.book_online,
              title: 'My Books',
              subtitle: 'Borrowed items',
              onTap: () {
                // Navigate to borrowed books
              },
            ),
            _buildActionCard(
              icon: Icons.room_service,
              title: 'Study Rooms',
              subtitle: 'Book a room',
              onTap: () {
                // Navigate to study rooms
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.defaultPadding),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 32,
                color: AppTheme.primaryColor,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppConstants.smallPadding),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.lightTextSecondary,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryStats(LibraryLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Library Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.book,
                    label: 'Total Books',
                    value: state.totalBooks.toString(),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.people,
                    label: 'Active Users',
                    value: state.activeUsers.toString(),
                  ),
                ),
                Expanded(
                  child: _buildStatItem(
                    icon: Icons.trending_up,
                    label: 'Today\'s Visits',
                    value: state.todayVisits.toString(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 24,
          color: AppTheme.primaryColor,
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          value,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.primaryColor,
              ),
        ),
        const SizedBox(height: AppConstants.smallPadding),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.lightTextSecondary,
              ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRecentActivity(LibraryLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recent Activity',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            if (state.recentActivity.isEmpty)
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.largePadding),
                  child: Column(
                    children: [
                      Icon(
                        Icons.history,
                        size: 48,
                        color: AppTheme.lightTextSecondary,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      Text(
                        'No recent activity',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.lightTextSecondary,
                            ),
                      ),
                    ],
                  ),
                ),
              )
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: state.recentActivity.length,
                itemBuilder: (context, index) {
                  final activity = state.recentActivity[index];
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                      child: Icon(
                        activity.icon,
                        color: AppTheme.primaryColor,
                      ),
                    ),
                    title: Text(activity.title),
                    subtitle: Text(activity.subtitle),
                    trailing: Text(
                      activity.time,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.lightTextSecondary,
                          ),
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }
}
