// Login Screen for Vidyalankar Library Management System

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/widgets/custom_button.dart';
import '../../../../shared/widgets/custom_text_field.dart';
import '../../../../shared/widgets/loading_widget.dart';
import '../bloc/auth_bloc.dart';
import 'college_selection_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;
  bool _rememberMe = false;
  bool _biometricAvailable = false;
  List<BiometricType> _availableBiometrics = [];

  @override
  void initState() {
    super.initState();
    _checkBiometricAvailability();
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _checkBiometricAvailability() async {
    final localAuth = LocalAuthentication();
    try {
      final isAvailable = await localAuth.canCheckBiometrics;
      if (isAvailable) {
        final availableBiometrics = await localAuth.getAvailableBiometrics();
        setState(() {
          _biometricAvailable = true;
          _availableBiometrics = availableBiometrics;
        });
      }
    } catch (e) {
      // Biometric not available
    }
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      context.read<AuthBloc>().add(
            LoginRequested(
              username: _usernameController.text.trim(),
              password: _passwordController.text,
            ),
          );
    }
  }

  void _handleBiometricLogin() {
    context.read<AuthBloc>().add(BiometricLoginRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Navigate to main app
            Navigator.of(context).pushReplacementNamed('/home');
          } else if (state is CollegeSelectionRequired) {
            // Navigate to college selection
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => CollegeSelectionScreen(
                  availableColleges: state.availableColleges,
                  user: state.user,
                ),
              ),
            );
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
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Spacer(),

                  // Logo and Title
                  Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor,
                          borderRadius: BorderRadius.circular(60),
                        ),
                        child: const Icon(
                          Icons.library_books,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: AppConstants.largePadding),
                      Text(
                        AppConstants.appName,
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.primaryColor,
                                ),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        AppConstants.appDescription,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.lightTextSecondary,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.largePadding * 2),

                  // Login Form
                  Column(
                    children: [
                      CustomTextField(
                        controller: _usernameController,
                        labelText: 'Username / Student ID',
                        hintText: 'Enter your username or student ID',
                        prefixIcon: Icons.person_outline,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your username';
                          }
                          if (value.length < AppConstants.minStudentIdLength) {
                            return 'Username must be at least ${AppConstants.minStudentIdLength} characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      CustomTextField(
                        controller: _passwordController,
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: Icons.lock_outline,
                        obscureText: _obscurePassword,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          if (value.length < AppConstants.minPasswordLength) {
                            return 'Password must be at least ${AppConstants.minPasswordLength} characters';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),

                      // Remember Me and Forgot Password
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                onChanged: (value) {
                                  setState(() {
                                    _rememberMe = value ?? false;
                                  });
                                },
                              ),
                              Text(
                                'Remember me',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () {
                              // Navigate to forgot password screen
                            },
                            child: Text(
                              'Forgot Password?',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(color: AppTheme.primaryColor),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: AppConstants.largePadding),

                  // Login Button
                  BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is AuthLoading) {
                        return const LoadingWidget();
                      }

                      return CustomButton(
                        text: 'Login',
                        onPressed: _handleLogin,
                        icon: Icons.login,
                      );
                    },
                  ),

                  // Biometric Login
                  if (_biometricAvailable) ...[
                    const SizedBox(height: AppConstants.defaultPadding),
                    BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is AuthLoading) {
                          return const SizedBox.shrink();
                        }

                        return CustomButton(
                          text: _getBiometricText(),
                          onPressed: _handleBiometricLogin,
                          icon: _getBiometricIcon(),
                          variant: ButtonVariant.outlined,
                        );
                      },
                    ),
                  ],

                  const Spacer(),

                  // Footer
                  Column(
                    children: [
                      Text(
                        'Under ${AppConstants.trustName}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightTextSecondary,
                            ),
                      ),
                      const SizedBox(height: AppConstants.smallPadding),
                      Text(
                        'Version ${AppConstants.appVersion}',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppTheme.lightTextSecondary,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getBiometricText() {
    if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return 'Login with Fingerprint';
    } else if (_availableBiometrics.contains(BiometricType.face)) {
      return 'Login with Face ID';
    } else if (_availableBiometrics.contains(BiometricType.iris)) {
      return 'Login with Iris';
    }
    return 'Biometric Login';
  }

  IconData _getBiometricIcon() {
    if (_availableBiometrics.contains(BiometricType.fingerprint)) {
      return Icons.fingerprint;
    } else if (_availableBiometrics.contains(BiometricType.face)) {
      return Icons.face;
    } else if (_availableBiometrics.contains(BiometricType.iris)) {
      return Icons.visibility;
    }
    return Icons.security;
  }
}
