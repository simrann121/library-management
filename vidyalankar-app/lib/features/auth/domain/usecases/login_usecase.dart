// Login Use Case for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginUsecase {
  final AuthRepository repository;

  LoginUsecase(this.repository);

  Future<Either<Failure, LoginResponse>> call(LoginRequest request) async {
    return await repository.login(request);
  }
}
