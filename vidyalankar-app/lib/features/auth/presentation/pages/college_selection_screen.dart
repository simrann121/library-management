// College Selection Screen for Vidyalankar Library Management System

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../domain/entities/user.dart';
import '../bloc/auth_bloc.dart';

class CollegeSelectionScreen extends StatefulWidget {
  final List<College> availableColleges;
  final User user;

  const CollegeSelectionScreen({
    super.key,
    required this.availableColleges,
    required this.user,
  });

  @override
  State<CollegeSelectionScreen> createState() => _CollegeSelectionScreenState();
}

class _CollegeSelectionScreenState extends State<CollegeSelectionScreen> {
  College? _selectedCollege;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select College'), centerTitle: true),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to main app
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppTheme.errorColor,
              ),
            );
          }
        },
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.largePadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Column(
                  children: [
                    Text(
                      'Welcome, ${widget.user.fullName}!',
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.smallPadding),
                    Text(
                      'Please select your college to continue',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.lightTextSecondary,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),

                const SizedBox(height: AppConstants.largePadding * 2),

                // College List
                Expanded(
                  child: ListView.builder(
                    itemCount: widget.availableColleges.length,
                    itemBuilder: (context, index) {
                      final college = widget.availableColleges[index];
                      final isSelected = _selectedCollege?.id == college.id;

                      return Padding(
                        padding: const EdgeInsets.only(
                          bottom: AppConstants.defaultPadding,
                        ),
                        child: Card(
                          elevation: isSelected ? 4 : 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            side: BorderSide(
                              color: isSelected
                                  ? AppTheme.primaryColor
                                  : AppTheme.lightBorderColor,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _selectedCollege = college;
                              });
                            },
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadius,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(
                                AppConstants.defaultPadding,
                              ),
                              child: Row(
                                children: [
                                  // College Icon
                                  Container(
                                    width: 60,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      color: _getCollegeColor(
                                        college.code,
                                      ).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                    child: Icon(
                                      _getCollegeIcon(college.code),
                                      size: 30,
                                      color: _getCollegeColor(college.code),
                                    ),
                                  ),

                                  const SizedBox(
                                    width: AppConstants.defaultPadding,
                                  ),

                                  // College Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          college.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleLarge
                                              ?.copyWith(
                                                fontWeight: FontWeight.w600,
                                              ),
                                        ),
                                        const SizedBox(
                                          height: AppConstants.smallPadding,
                                        ),
                                        Text(
                                          college.type,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium
                                              ?.copyWith(
                                                color:
                                                    AppTheme.lightTextSecondary,
                                              ),
                                        ),
                                        const SizedBox(
                                          height: AppConstants.smallPadding,
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on_outlined,
                                              size: 16,
                                              color:
                                                  AppTheme.lightTextSecondary,
                                            ),
                                            const SizedBox(width: 4),
                                            Expanded(
                                              child: Text(
                                                '${college.address['city']}, ${college.address['state']}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodySmall
                                                    ?.copyWith(
                                                      color: AppTheme
                                                          .lightTextSecondary,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Selection Indicator
                                  if (isSelected)
                                    Container(
                                      width: 24,
                                      height: 24,
                                      decoration: BoxDecoration(
                                        color: AppTheme.primaryColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.check,
                                        size: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: AppConstants.largePadding),

                // Continue Button
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    if (state is AuthLoading) {
                      return const LoadingWidget();
                    }

                    return CustomButton(
                      text: 'Continue',
                      onPressed:
                          _selectedCollege != null ? _handleContinue : null,
                      icon: Icons.arrow_forward,
                    );
                  },
                ),

                const SizedBox(height: AppConstants.defaultPadding),

                // Footer
                Text(
                  'Under ${AppConstants.trustName}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.lightTextSecondary,
                      ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleContinue() {
    if (_selectedCollege != null) {
      context.read<AuthBloc>().add(
            CollegeSelected(collegeId: _selectedCollege!.id),
          );
    }
  }

  Color _getCollegeColor(String collegeCode) {
    switch (collegeCode) {
      case AppConstants.vsitCode:
        return Color(AppConstants.collegeColors[AppConstants.vsitCode]!);
      case AppConstants.vitCode:
        return Color(AppConstants.collegeColors[AppConstants.vitCode]!);
      case AppConstants.vpCode:
        return Color(AppConstants.collegeColors[AppConstants.vpCode]!);
      default:
        return AppTheme.primaryColor;
    }
  }

  IconData _getCollegeIcon(String collegeCode) {
    switch (collegeCode) {
      case AppConstants.vsitCode:
        return Icons.computer;
      case AppConstants.vitCode:
        return Icons.engineering;
      case AppConstants.vpCode:
        return Icons.school;
      default:
        return Icons.school;
    }
  }
}
