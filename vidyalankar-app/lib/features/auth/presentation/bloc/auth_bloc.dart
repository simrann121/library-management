// Authentication Bloc for Vidyalankar Library Management System

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:local_auth/local_auth.dart';

import '../../domain/entities/user.dart';
import '../../domain/usecases/login_usecase.dart';
import '../../domain/usecases/logout_usecase.dart';
import '../../domain/usecases/check_auth_status_usecase.dart';
import '../../domain/usecases/biometric_auth_usecase.dart';

// Events
abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class AuthCheckRequested extends AuthEvent {}

class LoginRequested extends AuthEvent {
  final String username;
  final String password;
  final String? collegeCode;

  const LoginRequested({
    required this.username,
    required this.password,
    this.collegeCode,
  });

  @override
  List<Object?> get props => [username, password, collegeCode];
}

class LogoutRequested extends AuthEvent {}

class BiometricLoginRequested extends AuthEvent {}

class TokenRefreshRequested extends AuthEvent {}

class CollegeSelected extends AuthEvent {
  final String collegeId;

  const CollegeSelected({required this.collegeId});

  @override
  List<Object?> get props => [collegeId];
}

// States
abstract class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthAuthenticated extends AuthState {
  final User user;
  final College college;
  final Trust trust;
  final String token;

  const AuthAuthenticated({
    required this.user,
    required this.college,
    required this.trust,
    required this.token,
  });

  @override
  List<Object?> get props => [user, college, trust, token];
}

class AuthUnauthenticated extends AuthState {}

class AuthError extends AuthState {
  final String message;

  const AuthError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CollegeSelectionRequired extends AuthState {
  final List<College> availableColleges;
  final User user;

  const CollegeSelectionRequired({
    required this.availableColleges,
    required this.user,
  });

  @override
  List<Object?> get props => [availableColleges, user];
}

class BiometricAuthAvailable extends AuthState {
  final List<BiometricType> availableBiometrics;

  const BiometricAuthAvailable({required this.availableBiometrics});

  @override
  List<Object?> get props => [availableBiometrics];
}

class BiometricAuthUnavailable extends AuthState {}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final LoginUsecase loginUsecase;
  final LogoutUsecase logoutUsecase;
  final CheckAuthStatusUsecase checkAuthStatusUsecase;
  final BiometricAuthUsecase biometricAuthUsecase;

  AuthBloc({
    required this.loginUsecase,
    required this.logoutUsecase,
    required this.checkAuthStatusUsecase,
    required this.biometricAuthUsecase,
  }) : super(AuthInitial()) {
    on<AuthCheckRequested>(_onAuthCheckRequested);
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<BiometricLoginRequested>(_onBiometricLoginRequested);
    on<TokenRefreshRequested>(_onTokenRefreshRequested);
    on<CollegeSelected>(_onCollegeSelected);
  }

  Future<void> _onAuthCheckRequested(
    AuthCheckRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await checkAuthStatusUsecase();

      result.fold((failure) => emit(AuthUnauthenticated()), (authData) {
        if (authData.user.collegeId.isEmpty) {
          // User needs to select college
          emit(
            CollegeSelectionRequired(
              availableColleges: authData.availableColleges,
              user: authData.user,
            ),
          );
        } else {
          emit(
            AuthAuthenticated(
              user: authData.user,
              college: authData.college,
              trust: authData.trust,
              token: authData.token,
            ),
          );
        }
      });
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await loginUsecase(
        LoginRequest(
          username: event.username,
          password: event.password,
          collegeCode: event.collegeCode,
        ),
      );

      result.fold((failure) => emit(AuthError(message: failure.message)), (
        loginResponse,
      ) {
        if (loginResponse.user.collegeId.isEmpty) {
          // User needs to select college
          emit(
            CollegeSelectionRequired(
              availableColleges: loginResponse.availableColleges,
              user: loginResponse.user,
            ),
          );
        } else {
          emit(
            AuthAuthenticated(
              user: loginResponse.user,
              college: loginResponse.college,
              trust: loginResponse.trust,
              token: loginResponse.token,
            ),
          );
        }
      });
    } catch (e) {
      emit(AuthError(message: 'Login failed. Please try again.'));
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      await logoutUsecase();
      emit(AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(message: 'Logout failed. Please try again.'));
    }
  }

  Future<void> _onBiometricLoginRequested(
    BiometricLoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    try {
      final result = await biometricAuthUsecase();

      result.fold((failure) => emit(AuthError(message: failure.message)), (
        authData,
      ) {
        if (authData.user.collegeId.isEmpty) {
          emit(
            CollegeSelectionRequired(
              availableColleges: authData.availableColleges,
              user: authData.user,
            ),
          );
        } else {
          emit(
            AuthAuthenticated(
              user: authData.user,
              college: authData.college,
              trust: authData.trust,
              token: authData.token,
            ),
          );
        }
      });
    } catch (e) {
      emit(AuthError(message: 'Biometric authentication failed.'));
    }
  }

  Future<void> _onTokenRefreshRequested(
    TokenRefreshRequested event,
    Emitter<AuthState> emit,
  ) async {
    try {
      final result = await checkAuthStatusUsecase();

      result.fold((failure) => emit(AuthUnauthenticated()), (authData) {
        if (authData.user.collegeId.isEmpty) {
          emit(
            CollegeSelectionRequired(
              availableColleges: authData.availableColleges,
              user: authData.user,
            ),
          );
        } else {
          emit(
            AuthAuthenticated(
              user: authData.user,
              college: authData.college,
              trust: authData.trust,
              token: authData.token,
            ),
          );
        }
      });
    } catch (e) {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onCollegeSelected(
    CollegeSelected event,
    Emitter<AuthState> emit,
  ) async {
    if (state is CollegeSelectionRequired) {
      final currentState = state as CollegeSelectionRequired;

      try {
        // Update user's college selection
        final updatedUser = currentState.user.copyWith(
          collegeId: event.collegeId,
        );

        // Find selected college
        final selectedCollege = currentState.availableColleges.firstWhere(
          (college) => college.id == event.collegeId,
        );

        // Create trust object (assuming single trust for now)
        final trust = Trust(
          id: selectedCollege.trustId,
          name: 'Vidyalankar Dhyanpeeth Trust',
          code: 'VDT',
          config: {},
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        emit(
          AuthAuthenticated(
            user: updatedUser,
            college: selectedCollege,
            trust: trust,
            token: 'temp_token', // This should come from the API
          ),
        );
      } catch (e) {
        emit(AuthError(message: 'Failed to select college. Please try again.'));
      }
    }
  }
}
