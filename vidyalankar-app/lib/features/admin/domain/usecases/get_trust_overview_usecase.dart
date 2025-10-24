import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/admin.dart';
import '../repositories/admin_repository.dart';

class GetTrustOverviewUsecase {
  final AdminRepository repository;

  GetTrustOverviewUsecase(this.repository);

  Future<Either<Failure, TrustOverviewData>> call() async {
    return await repository.getTrustOverview();
  }
}

class GetCollegeManagementUsecase {
  final AdminRepository repository;

  GetCollegeManagementUsecase(this.repository);

  Future<Either<Failure, CollegeManagementData>> call() async {
    return await repository.getCollegeManagement();
  }
}

class GetUserManagementUsecase {
  final AdminRepository repository;

  GetUserManagementUsecase(this.repository);

  Future<Either<Failure, UserManagementData>> call() async {
    return await repository.getUserManagement();
  }
}

class GetLibraryAnalyticsUsecase {
  final AdminRepository repository;

  GetLibraryAnalyticsUsecase(this.repository);

  Future<Either<Failure, LibraryAnalyticsData>> call() async {
    return await repository.getLibraryAnalytics();
  }
}

class GetSystemConfigurationUsecase {
  final AdminRepository repository;

  GetSystemConfigurationUsecase(this.repository);

  Future<Either<Failure, SystemConfigurationData>> call() async {
    return await repository.getSystemConfiguration();
  }
}
