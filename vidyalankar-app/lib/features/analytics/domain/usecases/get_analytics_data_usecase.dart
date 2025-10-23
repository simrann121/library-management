import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/analytics.dart';
import '../repositories/analytics_repository.dart';

// Parameters classes
class GetAnalyticsDataParams {
  final String timeRange;
  final String collegeId;

  const GetAnalyticsDataParams({
    required this.timeRange,
    required this.collegeId,
  });
}

class GetUsagePatternsParams {
  final String timeRange;
  final String collegeId;

  const GetUsagePatternsParams({
    required this.timeRange,
    required this.collegeId,
  });
}

// Use Cases
class GetAnalyticsDataUsecase {
  final AnalyticsRepository repository;

  GetAnalyticsDataUsecase(this.repository);

  Future<Either<Failure, AnalyticsData>> call(
      GetAnalyticsDataParams params) async {
    return await repository.getAnalyticsData(
      timeRange: params.timeRange,
      collegeId: params.collegeId,
    );
  }
}

class GetUsagePatternsUsecase {
  final AnalyticsRepository repository;

  GetUsagePatternsUsecase(this.repository);

  Future<Either<Failure, UsagePatternData>> call(
      GetUsagePatternsParams params) async {
    return await repository.getUsagePatterns(
      timeRange: params.timeRange,
      collegeId: params.collegeId,
    );
  }
}

class GetPerformanceMetricsUsecase {
  final AnalyticsRepository repository;

  GetPerformanceMetricsUsecase(this.repository);

  Future<Either<Failure, PerformanceMetricsData>> call() async {
    return await repository.getPerformanceMetrics();
  }
}
