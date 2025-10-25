// College Selection Entities for Vidyalankar Library Management System

import 'package:equatable/equatable.dart';
import '../../auth/domain/entities/user.dart';

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
