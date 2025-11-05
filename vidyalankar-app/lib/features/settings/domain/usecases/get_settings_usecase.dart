// Settings Use Cases for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/settings.dart';
import '../repositories/settings_repository.dart';

class GetSettingsUsecase {
  final SettingsRepository repository;

  GetSettingsUsecase(this.repository);

  Future<Either<Failure, Settings>> call(String userId) async {
    return await repository.getSettings(userId);
  }
}

class UpdateSettingsUsecase {
  final SettingsRepository repository;

  UpdateSettingsUsecase(this.repository);

  Future<Either<Failure, void>> call(String key, dynamic value) async {
    return await repository.updateSettings(key, value);
  }
}
