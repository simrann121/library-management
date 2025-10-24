// Analytics Screen for Vidyalankar Library Management System

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as app_error;
import '../bloc/analytics_bloc.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String _selectedTimeRange = '7d';
  String _selectedCollege = 'all';

  final List<String> _timeRanges = ['24h', '7d', '30d', '90d', '1y'];
  final List<String> _colleges = ['all', 'vsit', 'vit', 'vp'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    context.read<AnalyticsBloc>().add(LoadAnalyticsData(
          timeRange: _selectedTimeRange,
          collegeId: _selectedCollege,
        ));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: const [
            Tab(icon: Icon(Icons.trending_up), text: 'Overview'),
            Tab(icon: Icon(Icons.people), text: 'Users'),
            Tab(icon: Icon(Icons.book), text: 'Books'),
            Tab(icon: Icon(Icons.analytics), text: 'Performance'),
          ],
        ),
        actions: [
          // Time Range Selector
          DropdownButton<String>(
            value: _selectedTimeRange,
            dropdownColor: AppTheme.lightSurfaceColor,
            items: _timeRanges.map((String range) {
              return DropdownMenuItem<String>(
                value: range,
                child: Text(range.toUpperCase()),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedTimeRange = newValue;
                });
                context.read<AnalyticsBloc>().add(LoadAnalyticsData(
                      timeRange: _selectedTimeRange,
                      collegeId: _selectedCollege,
                    ));
              }
            },
          ),
          const SizedBox(width: 8),
          // College Selector
          DropdownButton<String>(
            value: _selectedCollege,
            dropdownColor: AppTheme.lightSurfaceColor,
            items: _colleges.map((String college) {
              String displayName =
                  college == 'all' ? 'All Colleges' : college.toUpperCase();
              return DropdownMenuItem<String>(
                value: college,
                child: Text(displayName),
              );
            }).toList(),
            onChanged: (String? newValue) {
              if (newValue != null) {
                setState(() {
                  _selectedCollege = newValue;
                });
                context.read<AnalyticsBloc>().add(LoadAnalyticsData(
                      timeRange: _selectedTimeRange,
                      collegeId: _selectedCollege,
                    ));
              }
            },
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: BlocBuilder<AnalyticsBloc, AnalyticsState>(
        builder: (context, state) {
          if (state is AnalyticsLoading) {
            return const LoadingWidget(message: 'Loading analytics data...');
          }

          if (state is AnalyticsError) {
            return app_error.ErrorWidget(
              message: state.message,
              onRetry: () {
                context.read<AnalyticsBloc>().add(LoadAnalyticsData(
                      timeRange: _selectedTimeRange,
                      collegeId: _selectedCollege,
                    ));
              },
            );
          }

          if (state is AnalyticsLoaded) {
            return TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(context, state),
                _buildUsersTab(context, state),
                _buildBooksTab(context, state),
                _buildPerformanceTab(context, state),
              ],
            );
          }

          return const Center(
            child: Text('Select filters to view analytics'),
          );
        },
      ),
    );
  }

  Widget _buildOverviewTab(BuildContext context, AnalyticsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key Metrics Cards
          _buildMetricsGrid(context, state),
          const SizedBox(height: AppConstants.largePadding),

          // Usage Trends Chart
          _buildUsageTrendsChart(context, state),
          const SizedBox(height: AppConstants.largePadding),

          // College Comparison
          _buildCollegeComparison(context, state),
        ],
      ),
    );
  }

  Widget _buildUsersTab(BuildContext context, AnalyticsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User Activity Chart
          _buildUserActivityChart(context, state),
          const SizedBox(height: AppConstants.largePadding),

          // Top Users
          _buildTopUsers(context, state),
          const SizedBox(height: AppConstants.largePadding),

          // User Engagement Metrics
          _buildUserEngagementMetrics(context, state),
        ],
      ),
    );
  }

  Widget _buildBooksTab(BuildContext context, AnalyticsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Book Usage Chart
          _buildBookUsageChart(context, state),
          const SizedBox(height: AppConstants.largePadding),

          // Popular Books
          _buildPopularBooks(context, state),
          const SizedBox(height: AppConstants.largePadding),

          // Book Categories
          _buildBookCategories(context, state),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab(BuildContext context, AnalyticsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.largePadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Performance Metrics
          _buildPerformanceMetrics(context, state),
          const SizedBox(height: AppConstants.largePadding),

          // System Health
          _buildSystemHealth(context, state),
          const SizedBox(height: AppConstants.largePadding),

          // Recommendations
          _buildRecommendations(context, state),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(BuildContext context, AnalyticsLoaded state) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      crossAxisSpacing: AppConstants.defaultPadding,
      mainAxisSpacing: AppConstants.defaultPadding,
      children: [
        _buildMetricCard(
          context,
          'Total Users',
          state.data.totalUsers.toString(),
          Icons.people,
          AppTheme.primaryColor,
          '+12%',
        ),
        _buildMetricCard(
          context,
          'Active Users',
          state.data.activeUsers.toString(),
          Icons.person_pin,
          AppTheme.successColor,
          '+8%',
        ),
        _buildMetricCard(
          context,
          'Books Borrowed',
          state.data.booksBorrowed.toString(),
          Icons.book,
          AppTheme.warningColor,
          '+15%',
        ),
        _buildMetricCard(
          context,
          'Library Visits',
          state.data.libraryVisits.toString(),
          Icons.local_library,
          AppTheme.infoColor,
          '+5%',
        ),
      ],
    );
  }

  Widget _buildMetricCard(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
    String change,
  ) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTextSecondary,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppConstants.smallPadding / 2),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.smallPadding / 2),
            Text(
              change,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUsageTrendsChart(BuildContext context, AnalyticsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Usage Trends',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.lightBorderColor),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: const Center(
                child: Text('Chart will be implemented with fl_chart'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCollegeComparison(BuildContext context, AnalyticsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'College Comparison',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...state.data.collegeComparisons.map(
              (comparison) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    comparison.collegeCode,
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(comparison.collegeName),
                subtitle: Text(
                    '${comparison.userCount} users, ${comparison.bookCount} books'),
                trailing: Text(
                  '${comparison.utilizationRate.toStringAsFixed(1)}%',
                  style: TextStyle(
                    color: AppTheme.successColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserActivityChart(BuildContext context, AnalyticsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Activity Over Time',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.lightBorderColor),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: const Center(
                child: Text('User activity chart will be implemented'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopUsers(BuildContext context, AnalyticsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Top Active Users',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...state.data.topUsers.map(
              (user) => ListTile(
                leading: CircleAvatar(
                  backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
                  child: Text(
                    user.name.substring(0, 1).toUpperCase(),
                    style: TextStyle(
                      color: AppTheme.primaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                title: Text(user.name),
                subtitle: Text('${user.borrowCount} books borrowed'),
                trailing: Text(
                  '${user.activityScore}',
                  style: TextStyle(
                    color: AppTheme.warningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUserEngagementMetrics(
      BuildContext context, AnalyticsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'User Engagement Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              children: [
                Expanded(
                  child: _buildEngagementMetric(
                    context,
                    'Avg. Session Time',
                    '${state.data.avgSessionTime} min',
                    Icons.access_time,
                    AppTheme.primaryColor,
                  ),
                ),
                Expanded(
                  child: _buildEngagementMetric(
                    context,
                    'Return Rate',
                    '${state.data.returnRate.toStringAsFixed(1)}%',
                    Icons.repeat,
                    AppTheme.successColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEngagementMetric(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        children: [
          Icon(icon, size: 32, color: color),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.smallPadding / 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookUsageChart(BuildContext context, AnalyticsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book Usage Trends',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Container(
              height: 200,
              decoration: BoxDecoration(
                border: Border.all(color: AppTheme.lightBorderColor),
                borderRadius: BorderRadius.circular(AppConstants.borderRadius),
              ),
              child: const Center(
                child: Text('Book usage chart will be implemented'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularBooks(BuildContext context, AnalyticsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Most Popular Books',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...state.data.popularBooks.map(
              (book) => ListTile(
                leading: Container(
                  width: 40,
                  height: 60,
                  decoration: BoxDecoration(
                    color: AppTheme.primaryColor.withOpacity(0.1),
                    borderRadius:
                        BorderRadius.circular(AppConstants.smallBorderRadius),
                  ),
                  child: const Icon(
                    Icons.book,
                    color: AppTheme.primaryColor,
                  ),
                ),
                title: Text(book.title),
                subtitle: Text('by ${book.author}'),
                trailing: Text(
                  '${book.borrowCount}',
                  style: TextStyle(
                    color: AppTheme.warningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookCategories(BuildContext context, AnalyticsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Book Categories',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...state.data.bookCategories.map(
              (category) => Padding(
                padding:
                    const EdgeInsets.only(bottom: AppConstants.smallPadding),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(category.name),
                    ),
                    Expanded(
                      flex: 3,
                      child: LinearProgressIndicator(
                        value: category.percentage / 100,
                        backgroundColor: AppTheme.lightBorderColor,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppTheme.primaryColor,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        '${category.percentage.toStringAsFixed(1)}%',
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics(BuildContext context, AnalyticsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              childAspectRatio: 2,
              crossAxisSpacing: AppConstants.defaultPadding,
              mainAxisSpacing: AppConstants.defaultPadding,
              children: [
                _buildPerformanceMetric(
                  context,
                  'System Uptime',
                  '${state.data.systemUptime}%',
                  Icons.cloud_done,
                  AppTheme.successColor,
                ),
                _buildPerformanceMetric(
                  context,
                  'Response Time',
                  '${state.data.responseTime}ms',
                  Icons.speed,
                  AppTheme.warningColor,
                ),
                _buildPerformanceMetric(
                  context,
                  'Error Rate',
                  '${state.data.errorRate.toStringAsFixed(2)}%',
                  Icons.error_outline,
                  AppTheme.errorColor,
                ),
                _buildPerformanceMetric(
                  context,
                  'Throughput',
                  '${state.data.throughput}/min',
                  Icons.trending_up,
                  AppTheme.infoColor,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetric(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.smallPadding / 2),
          Text(
            value,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSystemHealth(BuildContext context, AnalyticsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'System Health',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...state.data.systemHealth.map(
              (health) => ListTile(
                leading: Icon(
                  health.status == 'healthy'
                      ? Icons.check_circle
                      : Icons.warning,
                  color: health.status == 'healthy'
                      ? AppTheme.successColor
                      : AppTheme.warningColor,
                ),
                title: Text(health.component),
                subtitle: Text(health.description),
                trailing: Text(
                  health.status.toUpperCase(),
                  style: TextStyle(
                    color: health.status == 'healthy'
                        ? AppTheme.successColor
                        : AppTheme.warningColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendations(BuildContext context, AnalyticsLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Recommendations',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...state.data.recommendations.map(
              (recommendation) => Card(
                color: recommendation.priority == 'high'
                    ? AppTheme.errorColor.withOpacity(0.1)
                    : AppTheme.warningColor.withOpacity(0.1),
                child: ListTile(
                  leading: Icon(
                    recommendation.priority == 'high'
                        ? Icons.priority_high
                        : Icons.lightbulb,
                    color: recommendation.priority == 'high'
                        ? AppTheme.errorColor
                        : AppTheme.warningColor,
                  ),
                  title: Text(recommendation.title),
                  subtitle: Text(recommendation.description),
                  trailing: Text(
                    recommendation.priority.toUpperCase(),
                    style: TextStyle(
                      color: recommendation.priority == 'high'
                          ? AppTheme.errorColor
                          : AppTheme.warningColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
