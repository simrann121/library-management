import 'package:equatable/equatable.dart';

// Analytics Data
class AnalyticsData extends Equatable {
  final int totalUsers;
  final int activeUsers;
  final int booksBorrowed;
  final int libraryVisits;
  final List<CollegeComparison> collegeComparisons;
  final List<TopUser> topUsers;
  final double avgSessionTime;
  final double returnRate;
  final List<PopularBook> popularBooks;
  final List<BookCategory> bookCategories;
  final double systemUptime;
  final int responseTime;
  final double errorRate;
  final int throughput;
  final List<SystemHealth> systemHealth;
  final List<Recommendation> recommendations;
  final DateTime lastUpdated;

  const AnalyticsData({
    required this.totalUsers,
    required this.activeUsers,
    required this.booksBorrowed,
    required this.libraryVisits,
    required this.collegeComparisons,
    required this.topUsers,
    required this.avgSessionTime,
    required this.returnRate,
    required this.popularBooks,
    required this.bookCategories,
    required this.systemUptime,
    required this.responseTime,
    required this.errorRate,
    required this.throughput,
    required this.systemHealth,
    required this.recommendations,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        totalUsers,
        activeUsers,
        booksBorrowed,
        libraryVisits,
        collegeComparisons,
        topUsers,
        avgSessionTime,
        returnRate,
        popularBooks,
        bookCategories,
        systemUptime,
        responseTime,
        errorRate,
        throughput,
        systemHealth,
        recommendations,
        lastUpdated,
      ];
}

class CollegeComparison extends Equatable {
  final String collegeId;
  final String collegeCode;
  final String collegeName;
  final int userCount;
  final int bookCount;
  final double utilizationRate;

  const CollegeComparison({
    required this.collegeId,
    required this.collegeCode,
    required this.collegeName,
    required this.userCount,
    required this.bookCount,
    required this.utilizationRate,
  });

  @override
  List<Object?> get props => [
        collegeId,
        collegeCode,
        collegeName,
        userCount,
        bookCount,
        utilizationRate,
      ];
}

class TopUser extends Equatable {
  final String userId;
  final String name;
  final String collegeId;
  final int borrowCount;
  final double activityScore;

  const TopUser({
    required this.userId,
    required this.name,
    required this.collegeId,
    required this.borrowCount,
    required this.activityScore,
  });

  @override
  List<Object?> get props => [
        userId,
        name,
        collegeId,
        borrowCount,
        activityScore,
      ];
}

class PopularBook extends Equatable {
  final String bookId;
  final String title;
  final String author;
  final int borrowCount;
  final double popularityScore;

  const PopularBook({
    required this.bookId,
    required this.title,
    required this.author,
    required this.borrowCount,
    required this.popularityScore,
  });

  @override
  List<Object?> get props => [
        bookId,
        title,
        author,
        borrowCount,
        popularityScore,
      ];
}

class BookCategory extends Equatable {
  final String name;
  final int count;
  final double percentage;

  const BookCategory({
    required this.name,
    required this.count,
    required this.percentage,
  });

  @override
  List<Object?> get props => [name, count, percentage];
}

class SystemHealth extends Equatable {
  final String component;
  final String status; // 'healthy', 'warning', 'error'
  final String description;
  final DateTime lastChecked;

  const SystemHealth({
    required this.component,
    required this.status,
    required this.description,
    required this.lastChecked,
  });

  @override
  List<Object?> get props => [component, status, description, lastChecked];
}

class Recommendation extends Equatable {
  final String title;
  final String description;
  final String priority; // 'high', 'medium', 'low'
  final String category;
  final DateTime createdAt;

  const Recommendation({
    required this.title,
    required this.description,
    required this.priority,
    required this.category,
    required this.createdAt,
  });

  @override
  List<Object?> get props =>
      [title, description, priority, category, createdAt];
}

// Usage Pattern Data
class UsagePatternData extends Equatable {
  final List<HourlyUsage> hourlyUsage;
  final List<DailyUsage> dailyUsage;
  final List<WeeklyUsage> weeklyUsage;
  final List<MonthlyUsage> monthlyUsage;
  final DateTime lastUpdated;

  const UsagePatternData({
    required this.hourlyUsage,
    required this.dailyUsage,
    required this.weeklyUsage,
    required this.monthlyUsage,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        hourlyUsage,
        dailyUsage,
        weeklyUsage,
        monthlyUsage,
        lastUpdated,
      ];
}

class HourlyUsage extends Equatable {
  final int hour;
  final int userCount;
  final int bookBorrows;
  final int bookReturns;
  final double utilizationRate;

  const HourlyUsage({
    required this.hour,
    required this.userCount,
    required this.bookBorrows,
    required this.bookReturns,
    required this.utilizationRate,
  });

  @override
  List<Object?> get props =>
      [hour, userCount, bookBorrows, bookReturns, utilizationRate];
}

class DailyUsage extends Equatable {
  final DateTime date;
  final int userCount;
  final int bookBorrows;
  final int bookReturns;
  final double utilizationRate;

  const DailyUsage({
    required this.date,
    required this.userCount,
    required this.bookBorrows,
    required this.bookReturns,
    required this.utilizationRate,
  });

  @override
  List<Object?> get props =>
      [date, userCount, bookBorrows, bookReturns, utilizationRate];
}

class WeeklyUsage extends Equatable {
  final DateTime weekStart;
  final int userCount;
  final int bookBorrows;
  final int bookReturns;
  final double utilizationRate;

  const WeeklyUsage({
    required this.weekStart,
    required this.userCount,
    required this.bookBorrows,
    required this.bookReturns,
    required this.utilizationRate,
  });

  @override
  List<Object?> get props =>
      [weekStart, userCount, bookBorrows, bookReturns, utilizationRate];
}

class MonthlyUsage extends Equatable {
  final DateTime monthStart;
  final int userCount;
  final int bookBorrows;
  final int bookReturns;
  final double utilizationRate;

  const MonthlyUsage({
    required this.monthStart,
    required this.userCount,
    required this.bookBorrows,
    required this.bookReturns,
    required this.utilizationRate,
  });

  @override
  List<Object?> get props =>
      [monthStart, userCount, bookBorrows, bookReturns, utilizationRate];
}

// Performance Metrics Data
class PerformanceMetricsData extends Equatable {
  final double systemUptime;
  final int responseTime;
  final double errorRate;
  final int throughput;
  final List<PerformanceMetric> metrics;
  final List<SystemAlert> alerts;
  final DateTime lastUpdated;

  const PerformanceMetricsData({
    required this.systemUptime,
    required this.responseTime,
    required this.errorRate,
    required this.throughput,
    required this.metrics,
    required this.alerts,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        systemUptime,
        responseTime,
        errorRate,
        throughput,
        metrics,
        alerts,
        lastUpdated,
      ];
}

class PerformanceMetric extends Equatable {
  final String name;
  final double value;
  final String unit;
  final String status; // 'good', 'warning', 'critical'
  final DateTime timestamp;

  const PerformanceMetric({
    required this.name,
    required this.value,
    required this.unit,
    required this.status,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [name, value, unit, status, timestamp];
}

class SystemAlert extends Equatable {
  final String id;
  final String title;
  final String message;
  final String severity; // 'info', 'warning', 'error', 'critical'
  final String category;
  final DateTime createdAt;
  final bool isResolved;

  const SystemAlert({
    required this.id,
    required this.title,
    required this.message,
    required this.severity,
    required this.category,
    required this.createdAt,
    required this.isResolved,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        message,
        severity,
        category,
        createdAt,
        isResolved,
      ];
}
