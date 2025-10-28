// Profile Entities for Vidyalankar Library Management System

import 'package:equatable/equatable.dart';

class Profile extends Equatable {
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

class ProfileUpdateRequest extends Equatable {
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

  @override
  List<Object?> get props => [firstName, lastName, email, phone];
}
