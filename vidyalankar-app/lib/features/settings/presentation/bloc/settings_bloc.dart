// Settings Bloc for Vidyalankar Library Management System

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_settings_usecase.dart';

// Events
abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class LoadSettings extends SettingsEvent {}

class UpdateSetting extends SettingsEvent {
  final String key;
  final dynamic value;

  const UpdateSetting({
    required this.key,
    required this.value,
  });

  @override
  List<Object?> get props => [key, value];
}

class ClearCache extends SettingsEvent {}

class ResetSettings extends SettingsEvent {}

class ExportSettings extends SettingsEvent {}

// States
abstract class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
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

  const SettingsLoaded({
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

class SettingsError extends SettingsState {
  final String message;

  const SettingsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class SettingsUpdated extends SettingsState {
  final String message;

  const SettingsUpdated({required this.message});

  @override
  List<Object?> get props => [message];
}

class CacheCleared extends SettingsState {
  final String message;

  const CacheCleared({required this.message});

  @override
  List<Object?> get props => [message];
}

class SettingsReset extends SettingsState {
  final String message;

  const SettingsReset({required this.message});

  @override
  List<Object?> get props => [message];
}

class SettingsExported extends SettingsState {
  final String filePath;

  const SettingsExported({required this.filePath});

  @override
  List<Object?> get props => [filePath];
}

// Bloc
class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingsUsecase getSettingsUsecase;

  SettingsBloc({
    required this.getSettingsUsecase,
  }) : super(SettingsInitial()) {
    on<LoadSettings>(_onLoadSettings);
    on<UpdateSetting>(_onUpdateSetting);
    on<ClearCache>(_onClearCache);
    on<ResetSettings>(_onResetSettings);
    on<ExportSettings>(_onExportSettings);
  }

  Future<void> _onLoadSettings(
    LoadSettings event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with actual API calls
      const settings = SettingsLoaded(
        isDarkMode: false,
        isBiometricEnabled: true,
        isNotificationsEnabled: true,
        isAutoSyncEnabled: true,
        defaultBorrowDays: 14,
        renewalReminderDays: 3,
        preferredLibrary: 'Main Library',
        language: 'English',
        fontSize: 16.0,
        isHapticFeedbackEnabled: true,
        isSoundEnabled: true,
        themeColor: 'blue',
      );

      emit(settings);
    } catch (e) {
      emit(SettingsError(message: 'Failed to load settings: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateSetting(
    UpdateSetting event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentState = state as SettingsLoaded;

      try {
        // Simulate API call
        await Future.delayed(const Duration(milliseconds: 500));

        // Update the specific setting
        final updatedSettings =
            _updateSettingValue(currentState, event.key, event.value);
        emit(updatedSettings);
        emit(const SettingsUpdated(message: 'Setting updated successfully!'));
      } catch (e) {
        emit(SettingsError(
            message: 'Failed to update setting: ${e.toString()}'));
      }
    }
  }

  Future<void> _onClearCache(
    ClearCache event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      // Simulate cache clearing
      await Future.delayed(const Duration(seconds: 2));

      emit(const CacheCleared(message: 'Cache cleared successfully!'));
    } catch (e) {
      emit(SettingsError(message: 'Failed to clear cache: ${e.toString()}'));
    }
  }

  Future<void> _onResetSettings(
    ResetSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      // Simulate settings reset
      await Future.delayed(const Duration(seconds: 1));

      emit(const SettingsReset(message: 'Settings reset to default values!'));

      // Reload settings with default values
      add(LoadSettings());
    } catch (e) {
      emit(SettingsError(message: 'Failed to reset settings: ${e.toString()}'));
    }
  }

  Future<void> _onExportSettings(
    ExportSettings event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      // Simulate settings export
      await Future.delayed(const Duration(seconds: 2));

      const filePath = '/storage/emulated/0/Download/settings_backup.json';
      emit(const SettingsExported(filePath: filePath));
    } catch (e) {
      emit(
          SettingsError(message: 'Failed to export settings: ${e.toString()}'));
    }
  }

  SettingsLoaded _updateSettingValue(
      SettingsLoaded currentState, String key, dynamic value) {
    switch (key) {
      case 'dark_mode':
        return currentState.copyWith(isDarkMode: value as bool);
      case 'biometric_auth':
        return currentState.copyWith(isBiometricEnabled: value as bool);
      case 'notifications':
        return currentState.copyWith(isNotificationsEnabled: value as bool);
      case 'auto_sync':
        return currentState.copyWith(isAutoSyncEnabled: value as bool);
      case 'default_borrow_days':
        return currentState.copyWith(defaultBorrowDays: value as int);
      case 'renewal_reminder_days':
        return currentState.copyWith(renewalReminderDays: value as int);
      case 'preferred_library':
        return currentState.copyWith(preferredLibrary: value as String);
      case 'language':
        return currentState.copyWith(language: value as String);
      case 'font_size':
        return currentState.copyWith(fontSize: value as double);
      case 'haptic_feedback':
        return currentState.copyWith(isHapticFeedbackEnabled: value as bool);
      case 'sound':
        return currentState.copyWith(isSoundEnabled: value as bool);
      case 'theme_color':
        return currentState.copyWith(themeColor: value as String);
      default:
        return currentState;
    }
  }
}

// Extension for SettingsLoaded
extension SettingsLoadedExtension on SettingsLoaded {
  SettingsLoaded copyWith({
    bool? isDarkMode,
    bool? isBiometricEnabled,
    bool? isNotificationsEnabled,
    bool? isAutoSyncEnabled,
    int? defaultBorrowDays,
    int? renewalReminderDays,
    String? preferredLibrary,
    String? language,
    double? fontSize,
    bool? isHapticFeedbackEnabled,
    bool? isSoundEnabled,
    String? themeColor,
  }) {
    return SettingsLoaded(
      isDarkMode: isDarkMode ?? this.isDarkMode,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isNotificationsEnabled:
          isNotificationsEnabled ?? this.isNotificationsEnabled,
      isAutoSyncEnabled: isAutoSyncEnabled ?? this.isAutoSyncEnabled,
      defaultBorrowDays: defaultBorrowDays ?? this.defaultBorrowDays,
      renewalReminderDays: renewalReminderDays ?? this.renewalReminderDays,
      preferredLibrary: preferredLibrary ?? this.preferredLibrary,
      language: language ?? this.language,
      fontSize: fontSize ?? this.fontSize,
      isHapticFeedbackEnabled:
          isHapticFeedbackEnabled ?? this.isHapticFeedbackEnabled,
      isSoundEnabled: isSoundEnabled ?? this.isSoundEnabled,
      themeColor: themeColor ?? this.themeColor,
    );
  }
}
