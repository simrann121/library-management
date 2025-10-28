// Library Bloc for Vidyalankar Library Management System

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_library_status_usecase.dart';

// Events
abstract class LibraryEvent extends Equatable {
  const LibraryEvent();

  @override
  List<Object?> get props => [];
}

class LoadLibraryData extends LibraryEvent {}

class RefreshLibraryData extends LibraryEvent {}

class ScanQrCode extends LibraryEvent {
  final String qrCode;

  const ScanQrCode({required this.qrCode});

  @override
  List<Object?> get props => [qrCode];
}

class UpdateLibraryStatus extends LibraryEvent {
  final bool isOpen;

  const UpdateLibraryStatus({required this.isOpen});

  @override
  List<Object?> get props => [isOpen];
}

// States
abstract class LibraryState extends Equatable {
  const LibraryState();

  @override
  List<Object?> get props => [];
}

class LibraryInitial extends LibraryState {}

class LibraryLoading extends LibraryState {}

class LibraryLoaded extends LibraryState {
  final String collegeName;
  final bool isOpen;
  final int currentOccupancy;
  final int maxCapacity;
  final int totalBooks;
  final int activeUsers;
  final int todayVisits;
  final List<LibraryActivity> recentActivity;

  const LibraryLoaded({
    required this.collegeName,
    required this.isOpen,
    required this.currentOccupancy,
    required this.maxCapacity,
    required this.totalBooks,
    required this.activeUsers,
    required this.todayVisits,
    required this.recentActivity,
  });

  @override
  List<Object?> get props => [
        collegeName,
        isOpen,
        currentOccupancy,
        maxCapacity,
        totalBooks,
        activeUsers,
        todayVisits,
        recentActivity,
      ];
}

class LibraryError extends LibraryState {
  final String message;

  const LibraryError({required this.message});

  @override
  List<Object?> get props => [message];
}

class QrCodeScanned extends LibraryState {
  final String message;
  final bool success;

  const QrCodeScanned({
    required this.message,
    required this.success,
  });

  @override
  List<Object?> get props => [message, success];
}

// Models
class LibraryActivity extends Equatable {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;

  const LibraryActivity({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
  });

  @override
  List<Object?> get props => [title, subtitle, time, icon];
}

// Bloc
class LibraryBloc extends Bloc<LibraryEvent, LibraryState> {
  final GetLibraryStatusUsecase getLibraryStatusUsecase;

  LibraryBloc({
    required this.getLibraryStatusUsecase,
  }) : super(LibraryInitial()) {
    on<LoadLibraryData>(_onLoadLibraryData);
    on<RefreshLibraryData>(_onRefreshLibraryData);
    on<ScanQrCode>(_onScanQrCode);
    on<UpdateLibraryStatus>(_onUpdateLibraryStatus);
  }

  Future<void> _onLoadLibraryData(
    LoadLibraryData event,
    Emitter<LibraryState> emit,
  ) async {
    emit(LibraryLoading());

    try {
      // Simulate API calls
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with actual API calls
      final libraryData = LibraryLoaded(
        collegeName: 'Vidyalankar School of Information Technology',
        isOpen: true,
        currentOccupancy: 45,
        maxCapacity: 100,
        totalBooks: 12500,
        activeUsers: 320,
        todayVisits: 89,
        recentActivity: [
          const LibraryActivity(
            title: 'Book Borrowed',
            subtitle: 'Introduction to Algorithms',
            time: '2 hours ago',
            icon: Icons.book,
          ),
          const LibraryActivity(
            title: 'Study Room Booked',
            subtitle: 'Room 101 - 2:00 PM',
            time: '4 hours ago',
            icon: Icons.room_service,
          ),
          const LibraryActivity(
            title: 'Book Returned',
            subtitle: 'Data Structures and Algorithms',
            time: '1 day ago',
            icon: 'book_return',
          ),
        ],
      );

      emit(libraryData);
    } catch (e) {
      emit(LibraryError(
          message: 'Failed to load library data: ${e.toString()}'));
    }
  }

  Future<void> _onRefreshLibraryData(
    RefreshLibraryData event,
    Emitter<LibraryState> emit,
  ) async {
    // Keep current state while refreshing
    final currentState = state;
    if (currentState is LibraryLoaded) {
      emit(LibraryLoading());

      try {
        // Simulate refresh
        await Future.delayed(const Duration(seconds: 1));

        // Update with fresh data
        final refreshedData = currentState.copyWith(
          currentOccupancy: currentState.currentOccupancy + 2,
          todayVisits: currentState.todayVisits + 1,
        );

        emit(refreshedData);
      } catch (e) {
        emit(LibraryError(
            message: 'Failed to refresh library data: ${e.toString()}'));
      }
    }
  }

  Future<void> _onScanQrCode(
    ScanQrCode event,
    Emitter<LibraryState> emit,
  ) async {
    try {
      // Simulate QR code scanning
      await Future.delayed(const Duration(seconds: 1));

      // Mock QR code validation
      if (event.qrCode.isNotEmpty) {
        emit(const QrCodeScanned(
          message: 'QR code scanned successfully!',
          success: true,
        ));

        // Return to loaded state after a delay
        await Future.delayed(const Duration(seconds: 2));
        add(LoadLibraryData());
      } else {
        emit(const QrCodeScanned(
          message: 'Invalid QR code. Please try again.',
          success: false,
        ));
      }
    } catch (e) {
      emit(LibraryError(message: 'Failed to scan QR code: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateLibraryStatus(
    UpdateLibraryStatus event,
    Emitter<LibraryState> emit,
  ) async {
    if (state is LibraryLoaded) {
      final currentState = state as LibraryLoaded;
      final updatedState = currentState.copyWith(isOpen: event.isOpen);
      emit(updatedState);
    }
  }
}

// Extension for LibraryLoaded
extension LibraryLoadedExtension on LibraryLoaded {
  LibraryLoaded copyWith({
    String? collegeName,
    bool? isOpen,
    int? currentOccupancy,
    int? maxCapacity,
    int? totalBooks,
    int? activeUsers,
    int? todayVisits,
    List<LibraryActivity>? recentActivity,
  }) {
    return LibraryLoaded(
      collegeName: collegeName ?? this.collegeName,
      isOpen: isOpen ?? this.isOpen,
      currentOccupancy: currentOccupancy ?? this.currentOccupancy,
      maxCapacity: maxCapacity ?? this.maxCapacity,
      totalBooks: totalBooks ?? this.totalBooks,
      activeUsers: activeUsers ?? this.activeUsers,
      todayVisits: todayVisits ?? this.todayVisits,
      recentActivity: recentActivity ?? this.recentActivity,
    );
  }
}
