// Library Entities for Vidyalankar Library Management System

import 'package:equatable/equatable.dart';

class LibraryStatus extends Equatable {
  final bool isOpen;
  final int currentOccupancy;
  final int maxCapacity;
  final String statusMessage;

  const LibraryStatus({
    required this.isOpen,
    required this.currentOccupancy,
    required this.maxCapacity,
    required this.statusMessage,
  });

  @override
  List<Object?> get props =>
      [isOpen, currentOccupancy, maxCapacity, statusMessage];
}

class LibraryStats extends Equatable {
  final int totalBooks;
  final int activeUsers;
  final int todayVisits;
  final List<LibraryActivity> recentActivity;

  const LibraryStats({
    required this.totalBooks,
    required this.activeUsers,
    required this.todayVisits,
    required this.recentActivity,
  });

  @override
  List<Object?> get props =>
      [totalBooks, activeUsers, todayVisits, recentActivity];
}

class QrScanResult extends Equatable {
  final bool success;
  final String message;
  final String? studentId;

  const QrScanResult({
    required this.success,
    required this.message,
    this.studentId,
  });

  @override
  List<Object?> get props => [success, message, studentId];
}

class LibraryActivity extends Equatable {
  final String title;
  final String subtitle;
  final String time;
  final String icon;

  const LibraryActivity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
  });

  @override
  List<Object?> get props => [title, subtitle, time, icon];
}
