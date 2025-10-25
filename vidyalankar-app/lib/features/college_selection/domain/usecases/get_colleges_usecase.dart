import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/college_selection.dart';
import '../repositories/college_selection_repository.dart';

class GetCollegesUsecase {
  final CollegeSelectionRepository repository;

  GetCollegesUsecase(this.repository);

  Future<Either<Failure, List<CollegeSelection>>> call() async {
    return await repository.getColleges();
  }
}
