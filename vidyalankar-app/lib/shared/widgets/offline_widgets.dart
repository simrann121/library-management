// Offline Indicator Widget for Vidyalankar Library Management System

import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';
import '../../core/theme/app_theme.dart';
import '../../core/services/connectivity_service.dart';

class OfflineIndicator extends StatefulWidget {
  final Widget child;
  final bool showIndicator;
  final Duration animationDuration;

  const OfflineIndicator({
    super.key,
    required this.child,
    this.showIndicator = true,
    this.animationDuration = const Duration(milliseconds: 300),
  });

  @override
  State<OfflineIndicator> createState() => _OfflineIndicatorState();
}

class _OfflineIndicatorState extends State<OfflineIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  bool _isOnline = true;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _slideAnimation = Tween<double>(
      begin: -1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    // Listen to connectivity changes
    ConnectivityService().connectivityStream.listen((isOnline) {
      if (mounted) {
        setState(() {
          _isOnline = isOnline;
        });

        if (!isOnline && widget.showIndicator) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.showIndicator && !_isOnline)
          AnimatedBuilder(
            animation: _slideAnimation,
            builder: (context, child) {
              return Positioned(
                top: MediaQuery.of(context).padding.top +
                    _slideAnimation.value * 50,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding,
                    vertical: AppConstants.smallPadding,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.errorColor,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wifi_off,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: AppConstants.smallPadding),
                      Text(
                        'You\'re offline. Some features may be limited.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
      ],
    );
  }
}

// Sync status indicator
class SyncStatusIndicator extends StatefulWidget {
  final VoidCallback? onTap;
  final bool showDetails;

  const SyncStatusIndicator({
    super.key,
    this.onTap,
    this.showDetails = false,
  });

  @override
  State<SyncStatusIndicator> createState() => _SyncStatusIndicatorState();
}

class _SyncStatusIndicatorState extends State<SyncStatusIndicator> {
  bool _isOnline = true;
  bool _isSyncing = false;

  @override
  void initState() {
    super.initState();
    ConnectivityService().connectivityStream.listen((isOnline) {
      if (mounted) {
        setState(() {
          _isOnline = isOnline;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.smallPadding,
          vertical: AppConstants.smallPadding / 2,
        ),
        decoration: BoxDecoration(
          color: _getStatusColor().withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppConstants.smallBorderRadius),
          border: Border.all(
            color: _getStatusColor().withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _getStatusIcon(),
              size: 16,
              color: _getStatusColor(),
            ),
            if (widget.showDetails) ...[
              const SizedBox(width: AppConstants.smallPadding / 2),
              Text(
                _getStatusText(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: _getStatusColor(),
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getStatusColor() {
    if (_isSyncing) {
      return AppTheme.warningColor;
    } else if (_isOnline) {
      return AppTheme.successColor;
    } else {
      return AppTheme.errorColor;
    }
  }

  IconData _getStatusIcon() {
    if (_isSyncing) {
      return Icons.sync;
    } else if (_isOnline) {
      return Icons.cloud_done;
    } else {
      return Icons.cloud_off;
    }
  }

  String _getStatusText() {
    if (_isSyncing) {
      return 'Syncing...';
    } else if (_isOnline) {
      return 'Online';
    } else {
      return 'Offline';
    }
  }
}

// Offline queue indicator
class OfflineQueueIndicator extends StatefulWidget {
  final int queueCount;
  final VoidCallback? onTap;

  const OfflineQueueIndicator({
    super.key,
    required this.queueCount,
    this.onTap,
  });

  @override
  State<OfflineQueueIndicator> createState() => _OfflineQueueIndicatorState();
}

class _OfflineQueueIndicatorState extends State<OfflineQueueIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));

    if (widget.queueCount > 0) {
      _animationController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(OfflineQueueIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.queueCount > 0 && oldWidget.queueCount == 0) {
      _animationController.repeat(reverse: true);
    } else if (widget.queueCount == 0) {
      _animationController.stop();
      _animationController.reset();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.queueCount == 0) return const SizedBox.shrink();

    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _scaleAnimation,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Container(
              padding: const EdgeInsets.all(AppConstants.smallPadding),
              decoration: BoxDecoration(
                color: AppTheme.warningColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.warningColor.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.queue,
                    color: Colors.white,
                    size: 16,
                  ),
                  const SizedBox(width: AppConstants.smallPadding / 2),
                  Text(
                    widget.queueCount.toString(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

// Network status banner
class NetworkStatusBanner extends StatelessWidget {
  final bool isOnline;
  final VoidCallback? onRetry;

  const NetworkStatusBanner({
    super.key,
    required this.isOnline,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    if (isOnline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.defaultPadding),
      decoration: BoxDecoration(
        color: AppTheme.errorColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(
            Icons.wifi_off,
            color: Colors.white,
            size: 20,
          ),
          const SizedBox(width: AppConstants.defaultPadding),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No Internet Connection',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  'You\'re working offline. Changes will sync when you\'re back online.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.white.withOpacity(0.9),
                      ),
                ),
              ],
            ),
          ),
          if (onRetry != null)
            IconButton(
              onPressed: onRetry,
              icon: const Icon(
                Icons.refresh,
                color: Colors.white,
              ),
            ),
        ],
      ),
    );
  }
}
