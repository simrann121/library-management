import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/analytics.dart';

abstract class AnalyticsRepository {
  Future<Either<Failure, AnalyticsData>> getAnalyticsData({
    required String timeRange,
    required String collegeId,
  });

  Future<Either<Failure, UsagePatternData>> getUsagePatterns({
    required String timeRange,
    required String collegeId,
  });

  Future<Either<Failure, PerformanceMetricsData>> getPerformanceMetrics();
}
