// Library Use Cases for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/library_repository.dart';

class GetLibraryStatusUsecase {
  final LibraryRepository repository;

  GetLibraryStatusUsecase(this.repository);

  Future<Either<Failure, LibraryStatus>> call(String collegeId) async {
    return await repository.getLibraryStatus(collegeId);
  }
}

class GetLibraryStatsUsecase {
  final LibraryRepository repository;

  GetLibraryStatsUsecase(this.repository);

  Future<Either<Failure, LibraryStats>> call(String collegeId) async {
    return await repository.getLibraryStats(collegeId);
  }
}

class ScanQrCodeUsecase {
  final LibraryRepository repository;

  ScanQrCodeUsecase(this.repository);

  Future<Either<Failure, QrScanResult>> call(
      String qrCode, String collegeId) async {
    return await repository.scanQrCode(qrCode, collegeId);
  }
}

// Models
class LibraryStatus {
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
}

class LibraryStats {
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
}

class QrScanResult {
  final bool success;
  final String message;
  final String? studentId;

  const QrScanResult({
    required this.success,
    required this.message,
    this.studentId,
  });
}

class LibraryActivity {
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
}
