import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

// Trust Overview Data
class TrustOverviewData extends Equatable {
  final int totalStudents;
  final int totalStaff;
  final int totalBooks;
  final int activeLibraries;
  final List<CollegePerformance> collegePerformance;
  final List<RecentActivity> recentActivities;
  final DateTime lastUpdated;

  const TrustOverviewData({
    required this.totalStudents,
    required this.totalStaff,
    required this.totalBooks,
    required this.activeLibraries,
    required this.collegePerformance,
    required this.recentActivities,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [
        totalStudents,
        totalStaff,
        totalBooks,
        activeLibraries,
        collegePerformance,
        recentActivities,
        lastUpdated,
      ];
}

class CollegePerformance extends Equatable {
  final String collegeId;
  final String collegeName;
  final int studentCount;
  final int staffCount;
  final int bookCount;
  final double libraryUtilization;
  final double performanceScore;

  const CollegePerformance({
    required this.collegeId,
    required this.collegeName,
    required this.studentCount,
    required this.staffCount,
    required this.bookCount,
    required this.libraryUtilization,
    required this.performanceScore,
  });

  @override
  List<Object?> get props => [
        collegeId,
        collegeName,
        studentCount,
        staffCount,
        bookCount,
        libraryUtilization,
        performanceScore,
      ];
}

class RecentActivity extends Equatable {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final String timestamp;
  final String type; // 'student', 'staff', 'book', 'system'

  const RecentActivity({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.timestamp,
    required this.type,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        icon,
        timestamp,
        type,
      ];
}

// College Management Data
class CollegeManagementData extends Equatable {
  final List<CollegeInfo> colleges;
  final List<CollegeConfiguration> configurations;
  final DateTime lastUpdated;

  const CollegeManagementData({
    required this.colleges,
    required this.configurations,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [colleges, configurations, lastUpdated];
}

class CollegeInfo extends Equatable {
  final String id;
  final String name;
  final String code;
  final String description;
  final String logoUrl;
  final String primaryColor;
  final String secondaryColor;
  final List<String> departments;
  final bool isActive;
  final CollegeStats stats;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CollegeInfo({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.logoUrl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.departments,
    required this.isActive,
    required this.stats,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        description,
        logoUrl,
        primaryColor,
        secondaryColor,
        departments,
        isActive,
        stats,
        createdAt,
        updatedAt,
      ];
}

class CollegeStats extends Equatable {
  final int totalStudents;
  final int activeStudents;
  final int totalStaff;
  final int activeStaff;
  final int totalBooks;
  final int availableBooks;
  final int totalLibraries;
  final int activeLibraries;

  const CollegeStats({
    required this.totalStudents,
    required this.activeStudents,
    required this.totalStaff,
    required this.activeStaff,
    required this.totalBooks,
    required this.availableBooks,
    required this.totalLibraries,
    required this.activeLibraries,
  });

  @override
  List<Object?> get props => [
        totalStudents,
        activeStudents,
        totalStaff,
        activeStaff,
        totalBooks,
        availableBooks,
        totalLibraries,
        activeLibraries,
      ];
}

class CollegeConfiguration extends Equatable {
  final String collegeId;
  final Map<String, dynamic> settings;
  final Map<String, dynamic> policies;
  final Map<String, dynamic> limits;
  final DateTime lastUpdated;

  const CollegeConfiguration({
    required this.collegeId,
    required this.settings,
    required this.policies,
    required this.limits,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props =>
      [collegeId, settings, policies, limits, lastUpdated];
}

// User Management Data
class UserManagementData extends Equatable {
  final List<UserInfo> users;
  final List<UserRole> roles;
  final List<UserPermission> permissions;
  final DateTime lastUpdated;

  const UserManagementData({
    required this.users,
    required this.roles,
    required this.permissions,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props => [users, roles, permissions, lastUpdated];
}

class UserInfo extends Equatable {
  final String id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;
  final String role;
  final String collegeId;
  final String? department;
  final bool isActive;
  final DateTime lastLogin;
  final DateTime createdAt;
  final DateTime updatedAt;

  const UserInfo({
    required this.id,
    required this.username,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.collegeId,
    this.department,
    required this.isActive,
    required this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        username,
        email,
        firstName,
        lastName,
        role,
        collegeId,
        department,
        isActive,
        lastLogin,
        createdAt,
        updatedAt,
      ];
}

class UserRole extends Equatable {
  final String id;
  final String name;
  final String description;
  final List<String> permissions;
  final String level; // 'trust', 'college', 'library'
  final bool isActive;

  const UserRole({
    required this.id,
    required this.name,
    required this.description,
    required this.permissions,
    required this.level,
    required this.isActive,
  });

  @override
  List<Object?> get props =>
      [id, name, description, permissions, level, isActive];
}

class UserPermission extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final bool isActive;

  const UserPermission({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.isActive,
  });

  @override
  List<Object?> get props => [id, name, description, category, isActive];
}

// Library Analytics Data
class LibraryAnalyticsData extends Equatable {
  final List<LibraryAnalytics> libraries;
  final List<BookAnalytics> books;
  final List<UserAnalytics> users;
  final List<UsagePattern> usagePatterns;
  final DateTime lastUpdated;

  const LibraryAnalyticsData({
    required this.libraries,
    required this.books,
    required this.users,
    required this.usagePatterns,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props =>
      [libraries, books, users, usagePatterns, lastUpdated];
}

class LibraryAnalytics extends Equatable {
  final String libraryId;
  final String collegeId;
  final String libraryName;
  final int totalBooks;
  final int availableBooks;
  final int borrowedBooks;
  final int totalUsers;
  final int activeUsers;
  final double utilizationRate;
  final List<HourlyUsage> hourlyUsage;
  final List<DailyUsage> dailyUsage;

  const LibraryAnalytics({
    required this.libraryId,
    required this.collegeId,
    required this.libraryName,
    required this.totalBooks,
    required this.availableBooks,
    required this.borrowedBooks,
    required this.totalUsers,
    required this.activeUsers,
    required this.utilizationRate,
    required this.hourlyUsage,
    required this.dailyUsage,
  });

  @override
  List<Object?> get props => [
        libraryId,
        collegeId,
        libraryName,
        totalBooks,
        availableBooks,
        borrowedBooks,
        totalUsers,
        activeUsers,
        utilizationRate,
        hourlyUsage,
        dailyUsage,
      ];
}

class BookAnalytics extends Equatable {
  final String bookId;
  final String title;
  final String author;
  final String category;
  final int totalCopies;
  final int availableCopies;
  final int borrowedCopies;
  final int totalBorrows;
  final double popularityScore;
  final List<String> topBorrowers;

  const BookAnalytics({
    required this.bookId,
    required this.title,
    required this.author,
    required this.category,
    required this.totalCopies,
    required this.availableCopies,
    required this.borrowedCopies,
    required this.totalBorrows,
    required this.popularityScore,
    required this.topBorrowers,
  });

  @override
  List<Object?> get props => [
        bookId,
        title,
        author,
        category,
        totalCopies,
        availableCopies,
        borrowedCopies,
        totalBorrows,
        popularityScore,
        topBorrowers,
      ];
}

class UserAnalytics extends Equatable {
  final String userId;
  final String username;
  final String collegeId;
  final String role;
  final int totalBorrows;
  final int activeBorrows;
  final int totalReturns;
  final double averageBorrowTime;
  final List<String> favoriteCategories;
  final List<String> favoriteAuthors;

  const UserAnalytics({
    required this.userId,
    required this.username,
    required this.collegeId,
    required this.role,
    required this.totalBorrows,
    required this.activeBorrows,
    required this.totalReturns,
    required this.averageBorrowTime,
    required this.favoriteCategories,
    required this.favoriteAuthors,
  });

  @override
  List<Object?> get props => [
        userId,
        username,
        collegeId,
        role,
        totalBorrows,
        activeBorrows,
        totalReturns,
        averageBorrowTime,
        favoriteCategories,
        favoriteAuthors,
      ];
}

class UsagePattern extends Equatable {
  final String patternId;
  final String name;
  final String description;
  final Map<String, dynamic> data;
  final String type; // 'hourly', 'daily', 'weekly', 'monthly'
  final DateTime timestamp;

  const UsagePattern({
    required this.patternId,
    required this.name,
    required this.description,
    required this.data,
    required this.type,
    required this.timestamp,
  });

  @override
  List<Object?> get props =>
      [patternId, name, description, data, type, timestamp];
}

class HourlyUsage extends Equatable {
  final int hour;
  final int userCount;
  final int bookBorrows;
  final int bookReturns;

  const HourlyUsage({
    required this.hour,
    required this.userCount,
    required this.bookBorrows,
    required this.bookReturns,
  });

  @override
  List<Object?> get props => [hour, userCount, bookBorrows, bookReturns];
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

// System Configuration Data
class SystemConfigurationData extends Equatable {
  final Map<String, dynamic> trustSettings;
  final Map<String, dynamic> systemSettings;
  final List<SystemPolicy> policies;
  final List<SystemLimit> limits;
  final List<SystemBackup> backups;
  final DateTime lastUpdated;

  const SystemConfigurationData({
    required this.trustSettings,
    required this.systemSettings,
    required this.policies,
    required this.limits,
    required this.backups,
    required this.lastUpdated,
  });

  @override
  List<Object?> get props =>
      [trustSettings, systemSettings, policies, limits, backups, lastUpdated];
}

class SystemPolicy extends Equatable {
  final String id;
  final String name;
  final String description;
  final String category;
  final Map<String, dynamic> rules;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SystemPolicy({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.rules,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props =>
      [id, name, description, category, rules, isActive, createdAt, updatedAt];
}

class SystemLimit extends Equatable {
  final String id;
  final String name;
  final String description;
  final String type;
  final int value;
  final String unit;
  final bool isActive;

  const SystemLimit({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.value,
    required this.unit,
    required this.isActive,
  });

  @override
  List<Object?> get props =>
      [id, name, description, type, value, unit, isActive];
}

class SystemBackup extends Equatable {
  final String id;
  final String name;
  final String description;
  final String type;
  final DateTime createdAt;
  final String status;
  final String? errorMessage;

  const SystemBackup({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.createdAt,
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object?> get props =>
      [id, name, description, type, createdAt, status, errorMessage];
}
