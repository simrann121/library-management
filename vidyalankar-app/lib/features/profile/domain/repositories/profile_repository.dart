// Profile Repository Interface for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile.dart';

abstract class ProfileRepository {
  Future<Either<Failure, Profile>> getProfile(String userId);
  Future<Either<Failure, void>> updateProfile(ProfileUpdateRequest request);
}
