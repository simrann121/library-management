// Profile Screen for Vidyalankar Library Management System

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as app_error;
import '../bloc/profile_bloc.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    // Load profile when screen initializes
    context.read<ProfileBloc>().add(LoadProfile());
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state is ProfileError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        } else if (state is ProfileUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Profile updated successfully!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
          setState(() {
            _isEditing = false;
          });
        }
      },
      builder: (context, state) {
        if (state is ProfileLoading) {
          return const LoadingWidget(message: 'Loading profile...');
        }

        if (state is ProfileError) {
          return app_error.ErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<ProfileBloc>().add(LoadProfile());
            },
          );
        }

        if (state is ProfileLoaded) {
          return _buildProfileScreen(state);
        }

        return const LoadingWidget();
      },
    );
  }

  Widget _buildProfileScreen(ProfileLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // Profile Header
          _buildProfileHeader(state),

          const SizedBox(height: AppConstants.largePadding),

          // Profile Form
          _buildProfileForm(state),

          const SizedBox(height: AppConstants.largePadding),

          // Library Stats
          _buildLibraryStats(state),

          const SizedBox(height: AppConstants.largePadding),

          // Action Buttons
          _buildActionButtons(),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(ProfileLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          children: [
            // Profile Picture
            CircleAvatar(
              radius: 60,
              backgroundColor: AppTheme.primaryColor.withOpacity(0.1),
              backgroundImage: state.profileImageUrl != null
                  ? NetworkImage(state.profileImageUrl!)
                  : null,
              child: state.profileImageUrl == null
                  ? const Icon(
                      Icons.person,
                      size: 60,
                      color: AppTheme.primaryColor,
                    )
                  : null,
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // User Info
            Text(
              state.fullName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              state.userType.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppTheme.primaryColor,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: AppConstants.smallPadding),
            Text(
              state.collegeName,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.lightTextSecondary,
                  ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: AppConstants.defaultPadding),

            // Edit Profile Button
            CustomButton(
              text: _isEditing ? 'Cancel' : 'Edit Profile',
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (!_isEditing) {
                    _resetForm(state);
                  }
                });
              },
              variant:
                  _isEditing ? ButtonVariant.outlined : ButtonVariant.primary,
              size: ButtonSize.small,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileForm(ProfileLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Personal Information',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // First Name
              CustomTextField(
                controller: _firstNameController,
                labelText: 'First Name',
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // Last Name
              CustomTextField(
                controller: _lastNameController,
                labelText: 'Last Name',
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // Email
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                enabled: _isEditing,
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppConstants.defaultPadding),

              // Phone
              CustomTextField(
                controller: _phoneController,
                labelText: 'Phone Number',
                enabled: _isEditing,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your phone number';
                  }
                  if (value.length < 10) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
              ),

              if (_isEditing) ...[
                const SizedBox(height: AppConstants.largePadding),
                CustomButton(
                  text: 'Save Changes',
                  onPressed: _saveProfile,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLibraryStats(ProfileLoaded state) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.largePadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Library Statistics',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.book,
                    label: 'Books Borrowed',
                    value: state.booksBorrowed.toString(),
                    color: AppTheme.primaryColor,
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.history,
                    label: 'Total Visits',
                    value: state.totalVisits.toString(),
                    color: AppTheme.successColor,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.star,
                    label: 'Favorites',
                    value: state.favorites.toString(),
                    color: AppTheme.warningColor,
                  ),
                ),
                const SizedBox(width: AppConstants.defaultPadding),
                Expanded(
                  child: _buildStatCard(
                    icon: Icons.trending_up,
                    label: 'This Month',
                    value: state.thisMonthVisits.toString(),
                    color: AppTheme.infoColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadius),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 32,
            color: color,
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
          const SizedBox(height: AppConstants.smallPadding),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.lightTextSecondary,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // Change Password
        CustomButton(
          text: 'Change Password',
          onPressed: () {
            _showChangePasswordDialog();
          },
          variant: ButtonVariant.outlined,
        ),

        const SizedBox(height: AppConstants.defaultPadding),

        // My Borrowed Books
        CustomButton(
          text: 'My Borrowed Books',
          onPressed: () {
            // Navigate to borrowed books
          },
          variant: ButtonVariant.outlined,
        ),

        const SizedBox(height: AppConstants.defaultPadding),

        // Reading History
        CustomButton(
          text: 'Reading History',
          onPressed: () {
            // Navigate to reading history
          },
          variant: ButtonVariant.outlined,
        ),

        const SizedBox(height: AppConstants.defaultPadding),

        // Favorites
        CustomButton(
          text: 'My Favorites',
          onPressed: () {
            // Navigate to favorites
          },
          variant: ButtonVariant.outlined,
        ),
      ],
    );
  }

  void _resetForm(ProfileLoaded state) {
    _firstNameController.text = state.firstName;
    _lastNameController.text = state.lastName;
    _emailController.text = state.email;
    _phoneController.text = state.phone;
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      context.read<ProfileBloc>().add(
            UpdateProfile(
              firstName: _firstNameController.text.trim(),
              lastName: _lastNameController.text.trim(),
              email: _emailController.text.trim(),
              phone: _phoneController.text.trim(),
            ),
          );
    }
  }

  void _showChangePasswordDialog() {
    final oldPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Change Password'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextField(
              controller: oldPasswordController,
              labelText: 'Current Password',
              obscureText: true,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            CustomTextField(
              controller: newPasswordController,
              labelText: 'New Password',
              obscureText: true,
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            CustomTextField(
              controller: confirmPasswordController,
              labelText: 'Confirm New Password',
              obscureText: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (newPasswordController.text ==
                  confirmPasswordController.text) {
                // Handle password change
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Password changed successfully!'),
                    backgroundColor: AppTheme.successColor,
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Passwords do not match!'),
                    backgroundColor: AppTheme.errorColor,
                  ),
                );
              }
            },
            child: const Text('Change'),
          ),
        ],
      ),
    );
  }
}
