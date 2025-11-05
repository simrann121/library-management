// Library Use Cases for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/library.dart';
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
