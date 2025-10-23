import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin.dart';

abstract class AdminRepository {
  Future<Either<Failure, TrustOverviewData>> getTrustOverview();
  Future<Either<Failure, CollegeManagementData>> getCollegeManagement();
  Future<Either<Failure, UserManagementData>> getUserManagement();
  Future<Either<Failure, LibraryAnalyticsData>> getLibraryAnalytics();
  Future<Either<Failure, SystemConfigurationData>> getSystemConfiguration();
}
