// Connectivity Service for Vidyalankar Library Management System

import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectivityService {
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;
  ConnectivityService._internal();

  final Connectivity _connectivity = Connectivity();
  StreamSubscription<ConnectivityResult>? _connectivitySubscription;

  bool _isOnline = true;
  final StreamController<bool> _connectivityController =
      StreamController<bool>.broadcast();

  // Get current connectivity status
  bool get isOnline => _isOnline;

  // Stream of connectivity changes
  Stream<bool> get connectivityStream => _connectivityController.stream;

  // Initialize connectivity monitoring
  Future<void> initialize() async {
    // Get initial connectivity status
    final result = await _connectivity.checkConnectivity();
    _isOnline = _isConnected([result]);
    _connectivityController.add(_isOnline);

    // Listen for connectivity changes
    _connectivitySubscription = _connectivity.onConnectivityChanged.listen(
      (result) => _onConnectivityChanged([result]),
    );
  }

  // Handle connectivity changes
  void _onConnectivityChanged(List<ConnectivityResult> result) {
    final wasOnline = _isOnline;
    _isOnline = _isConnected(result);

    if (wasOnline != _isOnline) {
      _connectivityController.add(_isOnline);
    }
  }

  // Check if connected to internet
  bool _isConnected(List<ConnectivityResult> result) {
    return result.any((connectivity) =>
        connectivity == ConnectivityResult.mobile ||
        connectivity == ConnectivityResult.wifi ||
        connectivity == ConnectivityResult.ethernet);
  }

  // Check connectivity status
  Future<bool> checkConnectivity() async {
    final result = await _connectivity.checkConnectivity();
    _isOnline = _isConnected([result]);
    return _isOnline;
  }

  // Get connection type
  Future<String> getConnectionType() async {
    final result = await _connectivity.checkConnectivity();

    if (result == ConnectivityResult.wifi) {
      return 'WiFi';
    } else if (result == ConnectivityResult.mobile) {
      return 'Mobile';
    } else if (result == ConnectivityResult.ethernet) {
      return 'Ethernet';
    } else {
      return 'None';
    }
  }

  // Dispose resources
  void dispose() {
    _connectivitySubscription?.cancel();
    _connectivityController.close();
  }
}
