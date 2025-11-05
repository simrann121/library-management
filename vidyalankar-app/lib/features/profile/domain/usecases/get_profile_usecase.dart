// Profile Use Cases for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/profile.dart';
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
