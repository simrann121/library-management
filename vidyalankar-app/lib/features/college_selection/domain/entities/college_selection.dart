// College Selection Entities for Vidyalankar Library Management System

import 'package:equatable/equatable.dart';

class CollegeSelection extends Equatable {
  final String id;
  final String name;
  final String code;
  final String description;
  final String logoUrl;
  final String primaryColor;
  final String secondaryColor;
  final List<String> departments;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CollegeSelection({
    required this.id,
    required this.name,
    required this.code,
    required this.description,
    required this.logoUrl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.departments,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  CollegeSelection copyWith({
    String? id,
    String? name,
    String? code,
    String? description,
    String? logoUrl,
    String? primaryColor,
    String? secondaryColor,
    List<String>? departments,
    bool? isActive,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CollegeSelection(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      departments: departments ?? this.departments,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        code,
        description,
        logoUrl,
        primaryColor,
        secondaryColor,
        departments,
        isActive,
        createdAt,
        updatedAt,
      ];
}
