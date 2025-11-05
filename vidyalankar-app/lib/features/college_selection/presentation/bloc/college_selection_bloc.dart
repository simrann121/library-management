// College Selection Bloc for Vidyalankar Library Management System

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/college_selection.dart';

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
  final List<CollegeSelection> colleges;

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
  final CollegeSelection college;

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

      final now = DateTime.now();
      final colleges = [
        CollegeSelection(
          id: 'college_1',
          name: 'Vidyalankar School of Information Technology',
          code: 'VSIT',
          description: 'Leading IT education institution',
          logoUrl: 'assets/logos/vsit_logo.png',
          primaryColor: '0xFF2563EB',
          secondaryColor: '0xFF64748B',
          departments: const [
            'Computer Science',
            'Information Technology',
            'Data Science'
          ],
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
        CollegeSelection(
          id: 'college_2',
          name: 'Vidyalankar Institute of Technology',
          code: 'VIT',
          description: 'Premier engineering college',
          logoUrl: 'assets/logos/vit_logo.png',
          primaryColor: '0xFF059669',
          secondaryColor: '0xFF10B981',
          departments: const ['Mechanical', 'Electronics', 'Civil', 'Computer'],
          isActive: true,
          createdAt: now,
          updatedAt: now,
        ),
        CollegeSelection(
          id: 'college_3',
          name: 'Vidyalankar Polytechnic',
          code: 'VP',
          description: 'Technical education excellence',
          logoUrl: 'assets/logos/vp_logo.png',
          primaryColor: '0xFFDC2626',
          secondaryColor: '0xFFEF4444',
          departments: const ['Mechanical', 'Electronics', 'Computer'],
          isActive: true,
          createdAt: now,
          updatedAt: now,
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
