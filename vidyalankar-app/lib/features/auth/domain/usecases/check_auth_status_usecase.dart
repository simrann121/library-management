// Check Auth Status Use Case for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class CheckAuthStatusUsecase {
  final AuthRepository repository;

  CheckAuthStatusUsecase(this.repository);

  Future<Either<Failure, AuthData>> call() async {
    return await repository.checkAuthStatus();
  }
}

class AuthData {
  final User user;
  final College college;
  final Trust trust;
  final String token;
  final List<College> availableColleges;

  const AuthData({
    required this.user,
    required this.college,
    required this.trust,
    required this.token,
    required this.availableColleges,
  });
}
