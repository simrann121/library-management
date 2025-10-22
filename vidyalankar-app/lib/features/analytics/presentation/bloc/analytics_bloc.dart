// Analytics Bloc for Vidyalankar Library Management System

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/analytics.dart';
import '../../domain/usecases/get_analytics_data_usecase.dart';

// Events
abstract class AnalyticsEvent extends Equatable {
  const AnalyticsEvent();

  @override
  List<Object?> get props => [];
}

class LoadAnalyticsData extends AnalyticsEvent {
  final String timeRange;
  final String collegeId;

  const LoadAnalyticsData({
    required this.timeRange,
    required this.collegeId,
  });

  @override
  List<Object?> get props => [timeRange, collegeId];
}

class LoadUsagePatterns extends AnalyticsEvent {
  final String timeRange;
  final String collegeId;

  const LoadUsagePatterns({
    required this.timeRange,
    required this.collegeId,
  });

  @override
  List<Object?> get props => [timeRange, collegeId];
}

class LoadPerformanceMetrics extends AnalyticsEvent {
  const LoadPerformanceMetrics();

  @override
  List<Object?> get props => [];
}

class RefreshAnalytics extends AnalyticsEvent {
  final String timeRange;
  final String collegeId;

  const RefreshAnalytics({
    required this.timeRange,
    required this.collegeId,
  });

  @override
  List<Object?> get props => [timeRange, collegeId];
}

// States
abstract class AnalyticsState extends Equatable {
  const AnalyticsState();

  @override
  List<Object?> get props => [];
}

class AnalyticsInitial extends AnalyticsState {}

class AnalyticsLoading extends AnalyticsState {}

class AnalyticsLoaded extends AnalyticsState {
  final AnalyticsData data;

  const AnalyticsLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class UsagePatternsLoaded extends AnalyticsState {
  final UsagePatternData data;

  const UsagePatternsLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class PerformanceMetricsLoaded extends AnalyticsState {
  final PerformanceMetricsData data;

  const PerformanceMetricsLoaded({required this.data});

  @override
  List<Object?> get props => [data];
}

class AnalyticsError extends AnalyticsState {
  final String message;

  const AnalyticsError({required this.message});

  @override
  List<Object?> get props => [message];
}

class AnalyticsBloc extends Bloc<AnalyticsEvent, AnalyticsState> {
  final GetAnalyticsDataUsecase getAnalyticsDataUsecase;

  AnalyticsBloc({
    required this.getAnalyticsDataUsecase,
  }) : super(AnalyticsInitial()) {
    on<LoadAnalyticsData>(_onLoadAnalyticsData);
    on<LoadUsagePatterns>(_onLoadUsagePatterns);
    on<LoadPerformanceMetrics>(_onLoadPerformanceMetrics);
    on<RefreshAnalytics>(_onRefreshAnalytics);
  }

  Future<void> _onLoadAnalyticsData(
    LoadAnalyticsData event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await getAnalyticsDataUsecase(
      GetAnalyticsDataParams(
        timeRange: event.timeRange,
        collegeId: event.collegeId,
      ),
    );

    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (data) => emit(AnalyticsLoaded(data: data)),
    );
  }

  Future<void> _onLoadUsagePatterns(
    LoadUsagePatterns event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await getUsagePatternsUsecase(
      GetUsagePatternsParams(
        timeRange: event.timeRange,
        collegeId: event.collegeId,
      ),
    );

    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (data) => emit(UsagePatternsLoaded(data: data)),
    );
  }

  Future<void> _onLoadPerformanceMetrics(
    LoadPerformanceMetrics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await getPerformanceMetricsUsecase();

    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (data) => emit(PerformanceMetricsLoaded(data: data)),
    );
  }

  Future<void> _onRefreshAnalytics(
    RefreshAnalytics event,
    Emitter<AnalyticsState> emit,
  ) async {
    emit(AnalyticsLoading());

    final result = await getAnalyticsDataUsecase(
      GetAnalyticsDataParams(
        timeRange: event.timeRange,
        collegeId: event.collegeId,
      ),
    );

    result.fold(
      (failure) => emit(AnalyticsError(message: failure.message)),
      (data) => emit(AnalyticsLoaded(data: data)),
    );
  }
}
