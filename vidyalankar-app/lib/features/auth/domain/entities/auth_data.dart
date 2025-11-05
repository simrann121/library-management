// Auth Data Entity for Vidyalankar Library Management System

import 'package:equatable/equatable.dart';
import 'user.dart';

class AuthData extends Equatable {
  final String token;
  final User user;
  final College college;
  final Trust trust;
  final DateTime expiresAt;
  final List<College> availableColleges;

  const AuthData({
    required this.token,
    required this.user,
    required this.college,
    required this.trust,
    required this.expiresAt,
    this.availableColleges = const [],
  });

  @override
  List<Object?> get props =>
      [token, user, college, trust, expiresAt, availableColleges];
}
