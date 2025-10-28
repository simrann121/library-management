// Settings Entities for Vidyalankar Library Management System

import 'package:equatable/equatable.dart';

class Settings extends Equatable {
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

  @override
  List<Object?> get props => [
        isDarkMode,
        isBiometricEnabled,
        isNotificationsEnabled,
        isAutoSyncEnabled,
        defaultBorrowDays,
        renewalReminderDays,
        preferredLibrary,
        language,
        fontSize,
        isHapticFeedbackEnabled,
        isSoundEnabled,
        themeColor,
      ];
}
