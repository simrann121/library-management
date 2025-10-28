// Library Repository Interface for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/library.dart';

abstract class LibraryRepository {
  Future<Either<Failure, LibraryStatus>> getLibraryStatus(String collegeId);
  Future<Either<Failure, LibraryStats>> getLibraryStats(String collegeId);
  Future<Either<Failure, QrScanResult>> scanQrCode(
      String qrCode, String collegeId);
}
