// Settings Use Cases for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
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

// Models
class Settings {
  final bool isDarkMode;
  final bool isBiometricEnabled;
  final bool isNotificationsEnabled;
  final bool isAutoSyncEnabled;
  final int defaultBorrowDays;
  final int renewalReminderDays;
  final String preferredLibrary;
  final String language;
  final double fontSize;
  final bool isHapticFeedbackEnabled;
  final bool isSoundEnabled;
  final String themeColor;

  const Settings({
    required this.isDarkMode,
    required this.isBiometricEnabled,
    required this.isNotificationsEnabled,
    required this.isAutoSyncEnabled,
    required this.defaultBorrowDays,
    required this.renewalReminderDays,
    required this.preferredLibrary,
    required this.language,
    required this.fontSize,
    required this.isHapticFeedbackEnabled,
    required this.isSoundEnabled,
    required this.themeColor,
  });
}
