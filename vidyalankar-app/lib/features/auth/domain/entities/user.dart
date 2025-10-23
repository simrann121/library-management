// Authentication Models for Vidyalankar Library Management System

import 'package:equatable/equatable.dart';

// User Model
class User extends Equatable {
  final String id;
  final String collegeId;
  final String userType;
  final String? studentId;
  final String? employeeId;
  final String firstName;
  final String lastName;
  final String? email;
  final String? phone;
  final String? fcmToken;
  final String? profileImageUrl;
  final bool isActive;
  final DateTime? lastLogin;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.collegeId,
    required this.userType,
    this.studentId,
    this.employeeId,
    required this.firstName,
    required this.lastName,
    this.email,
    this.phone,
    this.fcmToken,
    this.profileImageUrl,
    this.isActive = true,
    this.lastLogin,
    required this.createdAt,
    required this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      collegeId: json['college_id'] as String,
      userType: json['user_type'] as String,
      studentId: json['student_id'] as String?,
      employeeId: json['employee_id'] as String?,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      fcmToken: json['fcm_token'] as String?,
      profileImageUrl: json['profile_image_url'] as String?,
      isActive: json['is_active'] as bool? ?? true,
      lastLogin: json['last_login'] != null
          ? DateTime.parse(json['last_login'] as String)
          : null,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'college_id': collegeId,
      'user_type': userType,
      'student_id': studentId,
      'employee_id': employeeId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone': phone,
      'fcm_token': fcmToken,
      'profile_image_url': profileImageUrl,
      'is_active': isActive,
      'last_login': lastLogin?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  User copyWith({
    String? id,
    String? collegeId,
    String? userType,
    String? studentId,
    String? employeeId,
    String? firstName,
    String? lastName,
    String? email,
    String? phone,
    String? fcmToken,
    String? profileImageUrl,
    bool? isActive,
    DateTime? lastLogin,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      collegeId: collegeId ?? this.collegeId,
      userType: userType ?? this.userType,
      studentId: studentId ?? this.studentId,
      employeeId: employeeId ?? this.employeeId,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      fcmToken: fcmToken ?? this.fcmToken,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      isActive: isActive ?? this.isActive,
      lastLogin: lastLogin ?? this.lastLogin,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  String get fullName => '$firstName $lastName';
  String get displayId => studentId ?? employeeId ?? id;

  @override
  List<Object?> get props => [
        id,
        collegeId,
        userType,
        studentId,
        employeeId,
        firstName,
        lastName,
        email,
        phone,
        fcmToken,
        profileImageUrl,
        isActive,
        lastLogin,
        createdAt,
        updatedAt,
      ];
}

// College Model
class College extends Equatable {
  final String id;
  final String trustId;
  final String name;
  final String code;
  final String type;
  final Map<String, dynamic> address;
  final Map<String, dynamic> contactInfo;
  final Map<String, dynamic> config;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const College({
    required this.id,
    required this.trustId,
    required this.name,
    required this.code,
    required this.type,
    required this.address,
    required this.contactInfo,
    required this.config,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory College.fromJson(Map<String, dynamic> json) {
    return College(
      id: json['id'] as String,
      trustId: json['trust_id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      type: json['type'] as String,
      address: json['address'] as Map<String, dynamic>,
      contactInfo: json['contact_info'] as Map<String, dynamic>,
      config: json['config'] as Map<String, dynamic>,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'trust_id': trustId,
      'name': name,
      'code': code,
      'type': type,
      'address': address,
      'contact_info': contactInfo,
      'config': config,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        trustId,
        name,
        code,
        type,
        address,
        contactInfo,
        config,
        isActive,
        createdAt,
        updatedAt,
      ];
}

// Trust Model
class Trust extends Equatable {
  final String id;
  final String name;
  final String code;
  final String? description;
  final Map<String, dynamic> config;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Trust({
    required this.id,
    required this.name,
    required this.code,
    this.description,
    required this.config,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Trust.fromJson(Map<String, dynamic> json) {
    return Trust(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      description: json['description'] as String?,
      config: json['config'] as Map<String, dynamic>,
      isActive: json['is_active'] as bool? ?? true,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'description': description,
      'config': config,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        description,
        config,
        isActive,
        createdAt,
        updatedAt,
      ];
}

// Authentication Request Models
class LoginRequest extends Equatable {
  final String username;
  final String password;
  final String? collegeCode;

  const LoginRequest({
    required this.username,
    required this.password,
    this.collegeCode,
  });

  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'password': password,
      'college_code': collegeCode,
    };
  }

  @override
  List<Object?> get props => [username, password, collegeCode];
}

class LoginResponse extends Equatable {
  final String token;
  final User user;
  final College college;
  final Trust trust;
  final List<College> availableColleges;
  final DateTime expiresAt;

  const LoginResponse({
    required this.token,
    required this.user,
    required this.college,
    required this.trust,
    required this.availableColleges,
    required this.expiresAt,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      college: College.fromJson(json['college'] as Map<String, dynamic>),
      trust: Trust.fromJson(json['trust'] as Map<String, dynamic>),
      availableColleges: (json['available_colleges'] as List)
          .map((collegeJson) =>
              College.fromJson(collegeJson as Map<String, dynamic>))
          .toList(),
      expiresAt: DateTime.parse(json['expires_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user': user.toJson(),
      'college': college.toJson(),
      'trust': trust.toJson(),
      'available_colleges':
          availableColleges.map((college) => college.toJson()).toList(),
      'expires_at': expiresAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props =>
      [token, user, college, trust, availableColleges, expiresAt];
}

// College Selection Model
class CollegeSelection extends Equatable {
  final College college;
  final bool isSelected;

  const CollegeSelection({required this.college, this.isSelected = false});

  CollegeSelection copyWith({College? college, bool? isSelected}) {
    return CollegeSelection(
      college: college ?? this.college,
      isSelected: isSelected ?? this.isSelected,
    );
  }

  @override
  List<Object?> get props => [college, isSelected];
}
