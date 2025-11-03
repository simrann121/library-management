// Check Auth Status Use Case for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_data.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUsecase {
  final AuthRepository repository;

  CheckAuthStatusUsecase(this.repository);

  Future<Either<Failure, AuthData>> call() async {
    return await repository.checkAuthStatus();
  }
}
