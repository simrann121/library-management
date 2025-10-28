import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../repositories/college_selection_repository.dart';

class SelectCollegeUsecase {
  final CollegeSelectionRepository repository;

  SelectCollegeUsecase(this.repository);

  Future<Either<Failure, void>> call(String collegeId) async {
    return await repository.selectCollege(collegeId);
  }
}
