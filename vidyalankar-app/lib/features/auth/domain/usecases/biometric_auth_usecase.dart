// Biometric Auth Use Case for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_data.dart';
import '../repositories/auth_repository.dart';

class BiometricAuthUsecase {
  final AuthRepository repository;

  BiometricAuthUsecase(this.repository);

  Future<Either<Failure, AuthData>> call() async {
    return await repository.biometricAuth();
  }
}
