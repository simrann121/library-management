// Profile Bloc for Vidyalankar Library Management System

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/usecases/get_profile_usecase.dart';

// Events
abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {}

class UpdateProfile extends ProfileEvent {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const UpdateProfile({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });

  @override
  List<Object?> get props => [firstName, lastName, email, phone];
}

class ChangePassword extends ProfileEvent {
  final String oldPassword;
  final String newPassword;

  const ChangePassword({
    required this.oldPassword,
    required this.newPassword,
  });

  @override
  List<Object?> get props => [oldPassword, newPassword];
}

class UploadProfileImage extends ProfileEvent {
  final String imagePath;

  const UploadProfileImage({required this.imagePath});

  @override
  List<Object?> get props => [imagePath];
}

// States
abstract class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String userType;
  final String collegeName;
  final String? profileImageUrl;
  final int booksBorrowed;
  final int totalVisits;
  final int favorites;
  final int thisMonthVisits;
  final DateTime lastLogin;
  final DateTime memberSince;

  const ProfileLoaded({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.userType,
    required this.collegeName,
    this.profileImageUrl,
    required this.booksBorrowed,
    required this.totalVisits,
    required this.favorites,
    required this.thisMonthVisits,
    required this.lastLogin,
    required this.memberSince,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props => [
        id,
        firstName,
        lastName,
        email,
        phone,
        userType,
        collegeName,
        profileImageUrl,
        booksBorrowed,
        totalVisits,
        favorites,
        thisMonthVisits,
        lastLogin,
        memberSince,
      ];
}

class ProfileError extends ProfileState {
  final String message;

  const ProfileError({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileUpdated extends ProfileState {
  final String message;

  const ProfileUpdated({required this.message});

  @override
  List<Object?> get props => [message];
}

class PasswordChanged extends ProfileState {
  final String message;

  const PasswordChanged({required this.message});

  @override
  List<Object?> get props => [message];
}

class ProfileImageUploaded extends ProfileState {
  final String imageUrl;

  const ProfileImageUploaded({required this.imageUrl});

  @override
  List<Object?> get props => [imageUrl];
}

// Bloc
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase getProfileUsecase;

  ProfileBloc({
    required this.getProfileUsecase,
  }) : super(ProfileInitial()) {
    on<LoadProfile>(_onLoadProfile);
    on<UpdateProfile>(_onUpdateProfile);
    on<ChangePassword>(_onChangePassword);
    on<UploadProfileImage>(_onUploadProfileImage);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      // Mock data - replace with actual API calls
      final profile = const ProfileLoaded(
        id: 'user_123',
        firstName: 'John',
        lastName: 'Doe',
        email: 'john.doe@vidyalankar.edu',
        phone: '+91 98765 43210',
        userType: 'student',
        collegeName: 'Vidyalankar School of Information Technology',
        profileImageUrl: null,
        booksBorrowed: 3,
        totalVisits: 45,
        favorites: 12,
        thisMonthVisits: 8,
        lastLogin: DateTime(2024, 1, 15, 10, 30),
        memberSince: DateTime(2023, 8, 1),
      );

      emit(profile);
    } catch (e) {
      emit(ProfileError(message: 'Failed to load profile: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfile event,
    Emitter<ProfileState> emit,
  ) async {
    if (state is ProfileLoaded) {
      emit(ProfileLoading());

      try {
        // Simulate API call
        await Future.delayed(const Duration(seconds: 1));

        // Update the profile with new data
        final currentState = state as ProfileLoaded;
        final updatedProfile = ProfileLoaded(
          id: currentState.id,
          firstName: event.firstName,
          lastName: event.lastName,
          email: event.email,
          phone: event.phone,
          userType: currentState.userType,
          collegeName: currentState.collegeName,
          profileImageUrl: currentState.profileImageUrl,
          booksBorrowed: currentState.booksBorrowed,
          totalVisits: currentState.totalVisits,
          favorites: currentState.favorites,
          thisMonthVisits: currentState.thisMonthVisits,
          lastLogin: currentState.lastLogin,
          memberSince: currentState.memberSince,
        );

        emit(updatedProfile);
        emit(const ProfileUpdated(message: 'Profile updated successfully!'));
      } catch (e) {
        emit(
            ProfileError(message: 'Failed to update profile: ${e.toString()}'));
      }
    }
  }

  Future<void> _onChangePassword(
    ChangePassword event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));

      emit(const PasswordChanged(message: 'Password changed successfully!'));
    } catch (e) {
      emit(ProfileError(message: 'Failed to change password: ${e.toString()}'));
    }
  }

  Future<void> _onUploadProfileImage(
    UploadProfileImage event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Mock image URL
      const imageUrl = 'https://example.com/profile_image.jpg';

      emit(const ProfileImageUploaded(imageUrl: imageUrl));

      // Update the profile with new image URL
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        final updatedProfile = ProfileLoaded(
          id: currentState.id,
          firstName: currentState.firstName,
          lastName: currentState.lastName,
          email: currentState.email,
          phone: currentState.phone,
          userType: currentState.userType,
          collegeName: currentState.collegeName,
          profileImageUrl: imageUrl,
          booksBorrowed: currentState.booksBorrowed,
          totalVisits: currentState.totalVisits,
          favorites: currentState.favorites,
          thisMonthVisits: currentState.thisMonthVisits,
          lastLogin: currentState.lastLogin,
          memberSince: currentState.memberSince,
        );

        emit(updatedProfile);
      }
    } catch (e) {
      emit(ProfileError(
          message: 'Failed to upload profile image: ${e.toString()}'));
    }
  }
}
