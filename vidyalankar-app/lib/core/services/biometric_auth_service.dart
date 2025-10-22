// Biometric Authentication Service for Vidyalankar Library Management System

import 'package:local_auth/local_auth.dart';
import 'package:local_auth/error_codes.dart' as auth_error;
import 'package:flutter/services.dart';
import '../../core/error/exceptions.dart';

class BiometricAuthService {
  static final BiometricAuthService _instance =
      BiometricAuthService._internal();
  factory BiometricAuthService() => _instance;
  BiometricAuthService._internal();

  final LocalAuthentication _localAuth = LocalAuthentication();

  // Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();

      return isAvailable && isDeviceSupported;
    } catch (e) {
      return false;
    }
  }

  // Get available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      return [];
    }
  }

  // Authenticate with biometrics
  Future<bool> authenticate({
    String reason = 'Please authenticate to access the library system',
    bool stickyAuth = true,
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        throw BiometricException('Biometric authentication not available');
      }

      final result = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: stickyAuth,
          biometricOnly: true,
        ),
      );

      return result;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        throw BiometricException('Biometric authentication not available');
      } else if (e.code == auth_error.notEnrolled) {
        throw BiometricException('No biometrics enrolled');
      } else if (e.code == auth_error.lockedOut) {
        throw BiometricException('Biometric authentication locked out');
      } else if (e.code == auth_error.permanentlyLockedOut) {
        throw BiometricException(
            'Biometric authentication permanently locked out');
      } else {
        throw BiometricException(
            'Biometric authentication failed: ${e.message}');
      }
    } catch (e) {
      throw BiometricException(
          'Biometric authentication error: ${e.toString()}');
    }
  }

  // Authenticate with fallback to device credentials
  Future<bool> authenticateWithFallback({
    String reason = 'Please authenticate to access the library system',
  }) async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        throw BiometricException('Biometric authentication not available');
      }

      final result = await _localAuth.authenticate(
        localizedReason: reason,
        options: AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: false,
        ),
      );

      return result;
    } on PlatformException catch (e) {
      if (e.code == auth_error.notAvailable) {
        throw BiometricException('Biometric authentication not available');
      } else if (e.code == auth_error.notEnrolled) {
        throw BiometricException('No biometrics enrolled');
      } else if (e.code == auth_error.lockedOut) {
        throw BiometricException('Biometric authentication locked out');
      } else if (e.code == auth_error.permanentlyLockedOut) {
        throw BiometricException(
            'Biometric authentication permanently locked out');
      } else {
        throw BiometricException(
            'Biometric authentication failed: ${e.message}');
      }
    } catch (e) {
      throw BiometricException(
          'Biometric authentication error: ${e.toString()}');
    }
  }

  // Stop authentication
  Future<bool> stopAuthentication() async {
    try {
      return await _localAuth.stopAuthentication();
    } catch (e) {
      return false;
    }
  }

  // Get biometric type name
  String getBiometricTypeName(BiometricType type) {
    switch (type) {
      case BiometricType.fingerprint:
        return 'Fingerprint';
      case BiometricType.face:
        return 'Face ID';
      case BiometricType.iris:
        return 'Iris';
      case BiometricType.strong:
        return 'Strong Biometric';
      case BiometricType.weak:
        return 'Weak Biometric';
    }
  }

  // Get all available biometric type names
  Future<List<String>> getAvailableBiometricNames() async {
    final biometrics = await getAvailableBiometrics();
    return biometrics.map((type) => getBiometricTypeName(type)).toList();
  }

  // Check if specific biometric type is available
  Future<bool> isBiometricTypeAvailable(BiometricType type) async {
    final availableBiometrics = await getAvailableBiometrics();
    return availableBiometrics.contains(type);
  }

  // Get user-friendly biometric status
  Future<String> getBiometricStatus() async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) {
        return 'Biometric authentication not available on this device';
      }

      final biometrics = await getAvailableBiometrics();
      if (biometrics.isEmpty) {
        return 'No biometrics enrolled on this device';
      }

      final names =
          biometrics.map((type) => getBiometricTypeName(type)).toList();
      return 'Available: ${names.join(', ')}';
    } catch (e) {
      return 'Unable to determine biometric status';
    }
  }
}
