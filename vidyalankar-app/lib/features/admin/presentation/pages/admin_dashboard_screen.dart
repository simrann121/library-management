// Admin Dashboard Screen for Vidyalankar Library Management System

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as app_error;
import '../bloc/admin_bloc.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const TrustOverviewScreen(),
    const CollegeManagementScreen(),
    const UserManagementScreen(),
    const LibraryAnalyticsScreen(),
    const SystemConfigurationScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trust Admin Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // Show notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.account_circle),
            onPressed: () {
              // Show admin profile
            },
          ),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Navigation
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: AppTheme.lightSurfaceColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            child: Column(
              children: [
                // Trust Logo and Info
                Container(
                  padding: const EdgeInsets.all(AppConstants.largePadding),
                  child: Column(
                    children: [
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: const Icon(
                          Icons.account_balance,
                          size: 40,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      Text(
                        AppConstants.trustName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppTheme.primaryColor,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        'Trust Admin Dashboard',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.lightTextSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Navigation Menu
                Expanded(
                  child: ListView(
                    children: [
                      _buildNavItem(
                        icon: Icons.dashboard_outlined,
                        title: 'Trust Overview',
                        index: 0,
                      ),
                      _buildNavItem(
                        icon: Icons.school_outlined,
                        title: 'College Management',
                        index: 1,
                      ),
                      _buildNavItem(
                        icon: Icons.people_outlined,
                        title: 'User Management',
                        index: 2,
                      ),
                      _buildNavItem(
                        icon: Icons.analytics_outlined,
                        title: 'Library Analytics',
                        index: 3,
                      ),
                      _buildNavItem(
                        icon: Icons.settings_outlined,
                        title: 'System Configuration',
                        index: 4,
                      ),
                    ],
                  ),
                ),
                const Divider(),
                // Quick Actions
                Padding(
                  padding: const EdgeInsets.all(AppConstants.defaultPadding),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Quick Actions',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      CustomButton(
                        text: 'Generate Report',
                        onPressed: () {
                          // Generate trust-wide report
                        },
                        icon: Icons.assessment_outlined,
                        size: ButtonSize.small,
                        isFullWidth: true,
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      CustomButton(
                        text: 'System Backup',
                        onPressed: () {
                          // Trigger system backup
                        },
                        icon: Icons.backup_outlined,
                        variant: ButtonVariant.outlined,
                        size: ButtonSize.small,
                        isFullWidth: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Main Content
          Expanded(
            child: _screens[_selectedIndex],
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required String title,
    required int index,
  }) {
    final isSelected = _selectedIndex == index;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.defaultPadding,
        vertical: AppConstants.smallPadding,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color:
              isSelected ? AppTheme.primaryColor : AppTheme.lightTextSecondary,
        ),
        title: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: isSelected
                    ? AppTheme.primaryColor
                    : AppTheme.lightTextPrimary,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
        ),
        selected: isSelected,
        selectedTileColor: AppTheme.primaryColor.withOpacity(0.1),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
        ),
        onTap: () {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}

// Trust Overview Screen
class TrustOverviewScreen extends StatelessWidget {
  const TrustOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdminBloc, AdminState>(
      builder: (context, state) {
        if (state is AdminLoading) {
          return const LoadingWidget(message: 'Loading trust overview...');
        }

        if (state is AdminError) {
          return app_error.ErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<AdminBloc>().add(LoadTrustOverview());
            },
          );
        }

        if (state is TrustOverviewLoaded) {
          return _buildTrustOverview(context, state);
        }

        return const Center(
          child: Text('Welcome to Trust Admin Dashboard'),
        );
      },
    );
  }

  Widget _buildTrustOverview(BuildContext context, TrustOverviewLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Trust Overview',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              CustomButton(
                text: 'Refresh Data',
                onPressed: () {
                  context.read<AdminBloc>().add(LoadTrustOverview());
                },
                icon: Icons.refresh,
                size: ButtonSize.small,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.largePadding),

          // Key Metrics Cards
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 1.5,
            crossAxisSpacing: AppConstants.defaultPadding,
            mainAxisSpacing: AppConstants.defaultPadding,
            children: [
              _buildMetricCard(
                context,
                'Total Students',
                state.data.totalStudents.toString(),
                Icons.people,
                AppTheme.primaryColor,
              ),
              _buildMetricCard(
                context,
                'Total Staff',
                state.data.totalStaff.toString(),
                Icons.badge,
                AppTheme.successColor,
              ),
              _buildMetricCard(
                context,
                'Total Books',
                state.data.totalBooks.toString(),
                Icons.library_books,
                AppTheme.warningColor,
              ),
              _buildMetricCard(
                context,
                'Active Libraries',
                state.data.activeLibraries.toString(),
                Icons.local_library,
                AppTheme.infoColor,
              ),
            ],
          ),
          const SizedBox(height: AppConstants.largePadding),

          // College Performance Chart
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'College Performance',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  // Chart will be implemented with fl_chart
                  Container(
                    height: 300,
                    decoration: BoxDecoration(
                      color: AppTheme.lightBackgroundColor,
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadius),
                    ),
                    child: const Center(
                      child: Text('Performance Chart (Coming Soon)'),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppConstants.largePadding),

          // Recent Activities
          Card(
            child: Padding(
              padding: const EdgeInsets.all(AppConstants.largePadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recent Activities',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppConstants.defaultPadding),
                  ...state.data.recentActivities
                      .map(
                        (activity) => ListTile(
                          leading: CircleAvatar(
                            backgroundColor:
                                AppTheme.primaryColor.withOpacity(0.1),
                            child: Icon(
                              activity.icon,
                              color: AppTheme.primaryColor,
                              size: 20,
                            ),
                          ),
                          title: Text(activity.title),
                          subtitle: Text(activity.description),
                          trailing: Text(
                            activity.timestamp,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ),
                      )
                      .toList(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 32,
              color: color,
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.lightTextSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Placeholder screens for other admin sections
class CollegeManagementScreen extends StatelessWidget {
  const CollegeManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('College Management (Coming Soon)'),
    );
  }
}

class UserManagementScreen extends StatelessWidget {
  const UserManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('User Management (Coming Soon)'),
    );
  }
}

class LibraryAnalyticsScreen extends StatelessWidget {
  const LibraryAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Library Analytics (Coming Soon)'),
    );
  }
}

class SystemConfigurationScreen extends StatelessWidget {
  const SystemConfigurationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('System Configuration (Coming Soon)'),
    );
  }
}
