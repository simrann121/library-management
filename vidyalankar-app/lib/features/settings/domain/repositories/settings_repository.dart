// Settings Repository Interface for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/settings.dart';

abstract class SettingsRepository {
  Future<Either<Failure, Settings>> getSettings(String userId);
  Future<Either<Failure, void>> updateSettings(String key, dynamic value);
}
