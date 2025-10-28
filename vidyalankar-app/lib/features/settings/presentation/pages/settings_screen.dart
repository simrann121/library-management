// Settings Screen for Vidyalankar Library Management System

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../../../../shared/widgets/error_widget.dart' as app_error;
import '../bloc/settings_bloc.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    // Load settings when screen initializes
    context.read<SettingsBloc>().add(LoadSettings());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsBloc, SettingsState>(
      listener: (context, state) {
        if (state is SettingsError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppTheme.errorColor,
            ),
          );
        } else if (state is SettingsUpdated) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Settings updated successfully!'),
              backgroundColor: AppTheme.successColor,
            ),
          );
        }
      },
      builder: (context, state) {
        if (state is SettingsLoading) {
          return const LoadingWidget(message: 'Loading settings...');
        }

        if (state is SettingsError) {
          return app_error.ErrorWidget(
            message: state.message,
            onRetry: () {
              context.read<SettingsBloc>().add(LoadSettings());
            },
          );
        }

        if (state is SettingsLoaded) {
          return _buildSettingsScreen(state);
        }

        return const LoadingWidget();
      },
    );
  }

  Widget _buildSettingsScreen(SettingsLoaded state) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      child: Column(
        children: [
          // App Settings
          _buildSettingsSection(
            title: 'App Settings',
            children: [
              _buildSwitchTile(
                title: 'Dark Mode',
                subtitle: 'Enable dark theme',
                value: state.isDarkMode,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSetting(key: 'dark_mode', value: value),
                      );
                },
              ),
              _buildSwitchTile(
                title: 'Biometric Authentication',
                subtitle: 'Use fingerprint or face ID for login',
                value: state.isBiometricEnabled,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSetting(key: 'biometric_auth', value: value),
                      );
                },
              ),
              _buildSwitchTile(
                title: 'Push Notifications',
                subtitle:
                    'Receive notifications about books and library updates',
                value: state.isNotificationsEnabled,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSetting(key: 'notifications', value: value),
                      );
                },
              ),
              _buildSwitchTile(
                title: 'Auto Sync',
                subtitle: 'Automatically sync data when online',
                value: state.isAutoSyncEnabled,
                onChanged: (value) {
                  context.read<SettingsBloc>().add(
                        UpdateSetting(key: 'auto_sync', value: value),
                      );
                },
              ),
            ],
          ),

          const SizedBox(height: AppConstants.largePadding),

          // Library Settings
          _buildSettingsSection(
            title: 'Library Settings',
            children: [
              _buildListTile(
                title: 'Default Borrow Period',
                subtitle: '${state.defaultBorrowDays} days',
                icon: Icons.schedule,
                onTap: () {
                  _showBorrowPeriodDialog(state.defaultBorrowDays);
                },
              ),
              _buildListTile(
                title: 'Renewal Reminder',
                subtitle: '${state.renewalReminderDays} days before due',
                icon: Icons.notifications,
                onTap: () {
                  _showRenewalReminderDialog(state.renewalReminderDays);
                },
              ),
              _buildListTile(
                title: 'Preferred Library',
                subtitle: state.preferredLibrary,
                icon: Icons.library_books,
                onTap: () {
                  _showLibrarySelectionDialog();
                },
              ),
            ],
          ),

          const SizedBox(height: AppConstants.largePadding),

          // Privacy Settings
          _buildSettingsSection(
            title: 'Privacy & Security',
            children: [
              _buildListTile(
                title: 'Change Password',
                subtitle: 'Update your account password',
                icon: Icons.lock,
                onTap: () {
                  _showChangePasswordDialog();
                },
              ),
              _buildListTile(
                title: 'Privacy Policy',
                subtitle: 'View our privacy policy',
                icon: Icons.privacy_tip,
                onTap: () {
                  _showPrivacyPolicy();
                },
              ),
              _buildListTile(
                title: 'Terms of Service',
                subtitle: 'View terms and conditions',
                icon: Icons.description,
                onTap: () {
                  _showTermsOfService();
                },
              ),
            ],
          ),

          const SizedBox(height: AppConstants.largePadding),

          // About Section
          _buildSettingsSection(
            title: 'About',
            children: [
              _buildListTile(
                title: 'App Version',
                subtitle: AppConstants.appVersion,
                icon: Icons.info,
                onTap: null,
              ),
              _buildListTile(
                title: 'Contact Support',
                subtitle: 'Get help with the app',
                icon: Icons.support,
                onTap: () {
                  _showContactSupport();
                },
              ),
              _buildListTile(
                title: 'Rate App',
                subtitle: 'Rate us on the app store',
                icon: Icons.star,
                onTap: () {
                  _rateApp();
                },
              ),
            ],
          ),

          const SizedBox(height: AppConstants.largePadding),

          // Danger Zone
          _buildSettingsSection(
            title: 'Account',
            children: [
              _buildListTile(
                title: 'Clear Cache',
                subtitle: 'Free up storage space',
                icon: Icons.cleaning_services,
                onTap: () {
                  _showClearCacheDialog();
                },
              ),
              _buildListTile(
                title: 'Export Data',
                subtitle: 'Download your library data',
                icon: Icons.download,
                onTap: () {
                  _exportData();
                },
              ),
              _buildListTile(
                title: 'Delete Account',
                subtitle: 'Permanently delete your account',
                icon: Icons.delete_forever,
                onTap: () {
                  _showDeleteAccountDialog();
                },
                textColor: AppTheme.errorColor,
              ),
            ],
          ),

          const SizedBox(height: AppConstants.largePadding),

          // Logout Button
          CustomButton(
            text: 'Logout',
            onPressed: () {
              _showLogoutDialog();
            },
            variant: ButtonVariant.outlined,
            backgroundColor: AppTheme.errorColor,
            textColor: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.defaultPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppConstants.defaultPadding),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchTile({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SwitchListTile(
      title: Text(title),
      subtitle: Text(subtitle),
      value: value,
      onChanged: onChanged,
      activeColor: AppTheme.primaryColor,
    );
  }

  Widget _buildListTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required VoidCallback? onTap,
    Color? textColor,
  }) {
    return ListTile(
      leading: Icon(
        icon,
        color: textColor ?? AppTheme.primaryColor,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: textColor ?? Theme.of(context).textTheme.titleMedium?.color,
        ),
      ),
      subtitle: Text(subtitle),
      onTap: onTap,
      trailing: onTap != null ? const Icon(Icons.chevron_right) : null,
    );
  }

  void _showBorrowPeriodDialog(int currentDays) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Default Borrow Period'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select the default number of days for book borrowing:'),
            const SizedBox(height: AppConstants.defaultPadding),
            DropdownButtonFormField<int>(
              value: currentDays,
              items: [7, 14, 21, 30].map((days) {
                return DropdownMenuItem(
                  value: days,
                  child: Text('$days days'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        UpdateSetting(key: 'default_borrow_days', value: value),
                      );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showRenewalReminderDialog(int currentDays) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Renewal Reminder'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select when to receive renewal reminders:'),
            const SizedBox(height: AppConstants.defaultPadding),
            DropdownButtonFormField<int>(
              value: currentDays,
              items: [1, 2, 3, 5, 7].map((days) {
                return DropdownMenuItem(
                  value: days,
                  child: Text('$days days before due'),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        UpdateSetting(
                            key: 'renewal_reminder_days', value: value),
                      );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showLibrarySelectionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Preferred Library'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select your preferred library:'),
            const SizedBox(height: AppConstants.defaultPadding),
            DropdownButtonFormField<String>(
              value: 'Main Library',
              items:
                  ['Main Library', 'Computer Lab', 'Study Hall'].map((library) {
                return DropdownMenuItem(
                  value: library,
                  child: Text(library),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<SettingsBloc>().add(
                        UpdateSetting(key: 'preferred_library', value: value),
                      );
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    // This would show a password change dialog
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Password change feature coming soon!'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _showPrivacyPolicy() {
    // This would show the privacy policy
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Privacy policy feature coming soon!'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _showTermsOfService() {
    // This would show the terms of service
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Terms of service feature coming soon!'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _showContactSupport() {
    // This would open contact support
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Contact support feature coming soon!'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _rateApp() {
    // This would open the app store rating
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Rate app feature coming soon!'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _showClearCacheDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Cache'),
        content: const Text(
            'This will clear all cached data and free up storage space. Continue?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.read<SettingsBloc>().add(ClearCache());
            },
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _exportData() {
    // This would export user data
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Export data feature coming soon!'),
        backgroundColor: AppTheme.infoColor,
      ),
    );
  }

  void _showDeleteAccountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Account'),
        content: const Text(
            'This action cannot be undone. All your data will be permanently deleted. Are you sure?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle account deletion
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Handle logout
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
