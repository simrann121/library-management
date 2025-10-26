// Profile Use Cases for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/profile_repository.dart';

class GetProfileUsecase {
  final ProfileRepository repository;

  GetProfileUsecase(this.repository);

  Future<Either<Failure, Profile>> call(String userId) async {
    return await repository.getProfile(userId);
  }
}

class UpdateProfileUsecase {
  final ProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<Either<Failure, void>> call(ProfileUpdateRequest request) async {
    return await repository.updateProfile(request);
  }
}

// Models
class Profile {
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

  const Profile({
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
}

class ProfileUpdateRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  const ProfileUpdateRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
  });
}
