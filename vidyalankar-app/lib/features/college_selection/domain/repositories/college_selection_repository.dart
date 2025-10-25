// College Selection Repository Interface for Vidyalankar Library Management System

import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/college_selection.dart';

abstract class CollegeSelectionRepository {
  Future<Either<Failure, List<CollegeSelection>>> getColleges();
  Future<Either<Failure, void>> selectCollege(String collegeId);
}
