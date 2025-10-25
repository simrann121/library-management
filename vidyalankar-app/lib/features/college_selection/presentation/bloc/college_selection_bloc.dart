// College Selection Bloc for Vidyalankar Library Management System

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../auth/domain/entities/user.dart';

// Events
abstract class CollegeSelectionEvent extends Equatable {
  const CollegeSelectionEvent();

  @override
  List<Object?> get props => [];
}

class LoadColleges extends CollegeSelectionEvent {}

class SelectCollege extends CollegeSelectionEvent {
  final String collegeId;

  const SelectCollege({required this.collegeId});

  @override
  List<Object?> get props => [collegeId];
}

// States
abstract class CollegeSelectionState extends Equatable {
  const CollegeSelectionState();

  @override
  List<Object?> get props => [];
}

class CollegeSelectionInitial extends CollegeSelectionState {}

class CollegeSelectionLoading extends CollegeSelectionState {}

class CollegeSelectionLoaded extends CollegeSelectionState {
  final List<College> colleges;

  const CollegeSelectionLoaded({required this.colleges});

  @override
  List<Object?> get props => [colleges];
}

class CollegeSelectionError extends CollegeSelectionState {
  final String message;

  const CollegeSelectionError({required this.message});

  @override
  List<Object?> get props => [message];
}

class CollegeSelected extends CollegeSelectionState {
  final College college;

  const CollegeSelected({required this.college});

  @override
  List<Object?> get props => [college];
}

// Bloc
class CollegeSelectionBloc
    extends Bloc<CollegeSelectionEvent, CollegeSelectionState> {
  CollegeSelectionBloc() : super(CollegeSelectionInitial()) {
    on<LoadColleges>(_onLoadColleges);
    on<SelectCollege>(_onSelectCollege);
  }

  Future<void> _onLoadColleges(
    LoadColleges event,
    Emitter<CollegeSelectionState> emit,
  ) async {
    emit(CollegeSelectionLoading());

    try {
      // Mock data - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));

      final colleges = const [
        College(
          id: 'college_1',
          trustId: 'trust_1',
          name: 'Vidyalankar School of Information Technology',
          code: 'VSIT',
          type: 'Engineering',
          address: {'city': 'Mumbai', 'state': 'Maharashtra'},
          contactInfo: {'email': 'info@vsit.edu'},
          config: {},
          createdAt: DateTime(2020, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        ),
        College(
          id: 'college_2',
          trustId: 'trust_1',
          name: 'Vidyalankar Institute of Technology',
          code: 'VIT',
          type: 'Engineering',
          address: {'city': 'Mumbai', 'state': 'Maharashtra'},
          contactInfo: {'email': 'info@vit.edu'},
          config: {},
          createdAt: DateTime(2020, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        ),
        College(
          id: 'college_3',
          trustId: 'trust_1',
          name: 'Vidyalankar Polytechnic',
          code: 'VP',
          type: 'Polytechnic',
          address: {'city': 'Mumbai', 'state': 'Maharashtra'},
          contactInfo: {'email': 'info@vp.edu'},
          config: {},
          createdAt: DateTime(2020, 1, 1),
          updatedAt: DateTime(2024, 1, 1),
        ),
      ];

      emit(CollegeSelectionLoaded(colleges: colleges));
    } catch (e) {
      emit(CollegeSelectionError(
          message: 'Failed to load colleges: ${e.toString()}'));
    }
  }

  Future<void> _onSelectCollege(
    SelectCollege event,
    Emitter<CollegeSelectionState> emit,
  ) async {
    if (state is CollegeSelectionLoaded) {
      final currentState = state as CollegeSelectionLoaded;

      try {
        final selectedCollege = currentState.colleges.firstWhere(
          (college) => college.id == event.collegeId,
        );

        emit(CollegeSelected(college: selectedCollege));
      } catch (e) {
        emit(CollegeSelectionError(message: 'College not found'));
      }
    }
  }
}
