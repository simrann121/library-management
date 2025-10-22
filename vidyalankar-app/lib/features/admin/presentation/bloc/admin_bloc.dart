// Admin Bloc for Vidyalankar Library Management System

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/admin.dart';
import '../../domain/usecases/get_trust_overview_usecase.dart';

// Events
abstract class AdminEvent extends Equatable {
  const AdminEvent();

  @override
  List<Object?> get props => [];
}

class LoadTrustOverview extends AdminEvent {
  const LoadTrustOverview();
}

class LoadCollegeManagement extends AdminEvent {
  const LoadCollegeManagement();
}

class LoadUserManagement extends AdminEvent {
  const LoadUserManagement();
}

class LoadLibraryAnalytics extends AdminEvent {
  const LoadLibraryAnalytics();
}

class LoadSystemConfiguration extends AdminEvent {
  const LoadSystemConfiguration();
}

class RefreshAdminData extends AdminEvent {
  const RefreshAdminData();
}

// States
abstract class AdminState extends Equatable {
  const AdminState();

  @override
  List<Object?> get props => [];
}

class AdminInitial extends AdminState {
  const AdminInitial();
}

class AdminLoading extends AdminState {
  const AdminLoading();
}

class AdminError extends AdminState {
  final String message;

  const AdminError(this.message);

  @override
  List<Object?> get props => [message];
}

class TrustOverviewLoaded extends AdminState {
  final TrustOverviewData data;

  const TrustOverviewLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class CollegeManagementLoaded extends AdminState {
  final CollegeManagementData data;

  const CollegeManagementLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class UserManagementLoaded extends AdminState {
  final UserManagementData data;

  const UserManagementLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class LibraryAnalyticsLoaded extends AdminState {
  final LibraryAnalyticsData data;

  const LibraryAnalyticsLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

class SystemConfigurationLoaded extends AdminState {
  final SystemConfigurationData data;

  const SystemConfigurationLoaded(this.data);

  @override
  List<Object?> get props => [data];
}

// BLoC
class AdminBloc extends Bloc<AdminEvent, AdminState> {
  final GetTrustOverviewUsecase getTrustOverviewUsecase;

  AdminBloc({
    required this.getTrustOverviewUsecase,
  }) : super(const AdminInitial()) {
    on<LoadTrustOverview>(_onLoadTrustOverview);
    on<LoadCollegeManagement>(_onLoadCollegeManagement);
    on<LoadUserManagement>(_onLoadUserManagement);
    on<LoadLibraryAnalytics>(_onLoadLibraryAnalytics);
    on<LoadSystemConfiguration>(_onLoadSystemConfiguration);
    on<RefreshAdminData>(_onRefreshAdminData);
  }

  Future<void> _onLoadTrustOverview(
    LoadTrustOverview event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());

    final result = await getTrustOverviewUsecase();

    result.fold(
      (failure) => emit(AdminError(_mapFailureToMessage(failure))),
      (data) => emit(TrustOverviewLoaded(data)),
    );
  }

  Future<void> _onLoadCollegeManagement(
    LoadCollegeManagement event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());

    final result = await getCollegeManagementUsecase();

    result.fold(
      (failure) => emit(AdminError(_mapFailureToMessage(failure))),
      (data) => emit(CollegeManagementLoaded(data)),
    );
  }

  Future<void> _onLoadUserManagement(
    LoadUserManagement event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());

    final result = await getUserManagementUsecase();

    result.fold(
      (failure) => emit(AdminError(_mapFailureToMessage(failure))),
      (data) => emit(UserManagementLoaded(data)),
    );
  }

  Future<void> _onLoadLibraryAnalytics(
    LoadLibraryAnalytics event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());

    final result = await getLibraryAnalyticsUsecase();

    result.fold(
      (failure) => emit(AdminError(_mapFailureToMessage(failure))),
      (data) => emit(LibraryAnalyticsLoaded(data)),
    );
  }

  Future<void> _onLoadSystemConfiguration(
    LoadSystemConfiguration event,
    Emitter<AdminState> emit,
  ) async {
    emit(const AdminLoading());

    final result = await getSystemConfigurationUsecase();

    result.fold(
      (failure) => emit(AdminError(_mapFailureToMessage(failure))),
      (data) => emit(SystemConfigurationLoaded(data)),
    );
  }

  Future<void> _onRefreshAdminData(
    RefreshAdminData event,
    Emitter<AdminState> emit,
  ) async {
    // Refresh all admin data
    add(const LoadTrustOverview());
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Server error occurred. Please try again.';
      case NetworkFailure:
        return 'Network error. Please check your connection.';
      case CacheFailure:
        return 'Cache error occurred.';
      default:
        return 'An unexpected error occurred.';
    }
  }
}
