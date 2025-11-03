// Sync Status Screen for Vidyalankar Library Management System

import 'package:flutter/material.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/services/sync_service.dart';
import '../../../../core/services/connectivity_service.dart';
import '../../../../core/services/offline_storage_service.dart';
import '../../../../shared/widgets/mobile_widgets.dart';
import '../../../../shared/widgets/offline_widgets.dart';

class SyncStatusScreen extends StatefulWidget {
  const SyncStatusScreen({super.key});

  @override
  State<SyncStatusScreen> createState() => _SyncStatusScreenState();
}

class _SyncStatusScreenState extends State<SyncStatusScreen> {
  bool _isOnline = true;
  bool _isSyncing = false;
  Map<String, dynamic> _syncStatus = {};
  List<Map<String, dynamic>> _offlineQueue = [];

  @override
  void initState() {
    super.initState();
    _loadSyncStatus();
    _loadOfflineQueue();

    // Listen to connectivity changes
    ConnectivityService().connectivityStream.listen((isOnline) {
      if (mounted) {
        setState(() {
          _isOnline = isOnline;
        });
      }
    });
  }

  Future<void> _loadSyncStatus() async {
    try {
      final status = await SyncService.getSyncStatus();
      if (mounted) {
        setState(() {
          _syncStatus = status;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _loadOfflineQueue() async {
    try {
      final queue = await OfflineStorageService.getOfflineQueue();
      if (mounted) {
        setState(() {
          _offlineQueue = queue;
        });
      }
    } catch (e) {
      // Handle error
    }
  }

  Future<void> _performSync() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      final result = await SyncService.performFullSync();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor:
                result.success ? AppTheme.successColor : AppTheme.errorColor,
          ),
        );

        await _loadSyncStatus();
        await _loadOfflineQueue();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  Future<void> _uploadLocalChanges() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      final result = await SyncService.uploadLocalChanges();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor:
                result.success ? AppTheme.successColor : AppTheme.errorColor,
          ),
        );

        await _loadOfflineQueue();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Upload failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  Future<void> _downloadLatestData() async {
    if (_isSyncing) return;

    setState(() {
      _isSyncing = true;
    });

    try {
      final result = await SyncService.downloadLatestData();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.message),
            backgroundColor:
                result.success ? AppTheme.successColor : AppTheme.errorColor,
          ),
        );

        await _loadSyncStatus();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Download failed: ${e.toString()}'),
            backgroundColor: AppTheme.errorColor,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Status'),
        backgroundColor: AppTheme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          SyncStatusIndicator(
            onTap: _loadSyncStatus,
            showDetails: true,
          ),
          const SizedBox(width: AppConstants.defaultPadding),
        ],
      ),
      body: OfflineIndicator(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.largePadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Connection Status
              MobileCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection Status',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    Row(
                      children: [
                        Icon(
                          _isOnline ? Icons.cloud_done : Icons.cloud_off,
                          color: _isOnline
                              ? AppTheme.successColor
                              : AppTheme.errorColor,
                        ),
                        const SizedBox(width: AppConstants.defaultPadding),
                        Text(
                          _isOnline ? 'Online' : 'Offline',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: _isOnline
                                        ? AppTheme.successColor
                                        : AppTheme.errorColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                      ],
                    ),
                    if (!_isOnline) ...[
                      const SizedBox(height: AppConstants.defaultPadding),
                      Text(
                        'You\'re working offline. Changes will be synced when you\'re back online.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.lightTextSecondary,
                            ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.largePadding),

              // Sync Actions
              MobileCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sync Actions',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    if (_isOnline) ...[
                      MobileButton(
                        text: 'Full Sync',
                        onPressed: _isSyncing ? null : _performSync,
                        icon: Icons.sync,
                        isLoading: _isSyncing,
                        isFullWidth: true,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      MobileButton(
                        text: 'Upload Local Changes',
                        onPressed: _isSyncing ? null : _uploadLocalChanges,
                        icon: Icons.cloud_upload,
                        variant: ButtonVariant.outlined,
                        isLoading: _isSyncing,
                        isFullWidth: true,
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      MobileButton(
                        text: 'Download Latest Data',
                        onPressed: _isSyncing ? null : _downloadLatestData,
                        icon: Icons.cloud_download,
                        variant: ButtonVariant.outlined,
                        isLoading: _isSyncing,
                        isFullWidth: true,
                      ),
                    ] else ...[
                      MobileEmptyState(
                        icon: Icons.wifi_off,
                        title: 'Offline Mode',
                        message: 'Sync actions are not available when offline.',
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.largePadding),

              // Last Sync Time
              if (_syncStatus.isNotEmpty) ...[
                MobileCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Last Sync',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      if (_syncStatus['lastSyncTime'] != null) ...[
                        Text(
                          'Last sync: ${_formatDateTime(_syncStatus['lastSyncTime'])}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ] else ...[
                        Text(
                          'No sync performed yet',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppTheme.lightTextSecondary,
                                  ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.largePadding),
              ],

              // Offline Queue
              MobileCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Offline Queue',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const Spacer(),
                        OfflineQueueIndicator(
                          queueCount: _offlineQueue.length,
                          onTap: _loadOfflineQueue,
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.defaultPadding),
                    if (_offlineQueue.isEmpty) ...[
                      Text(
                        'No pending changes',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.lightTextSecondary,
                            ),
                      ),
                    ] else ...[
                      ..._offlineQueue.map(
                        (item) => MobileListTile(
                          leading: Icon(
                            _getActionIcon(item['action']),
                            color: AppTheme.warningColor,
                          ),
                          title: Text(
                            '${item['action'].toString().toUpperCase()} ${item['tableName']}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          subtitle: Text(
                            'Record ID: ${item['recordId']}',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTextSecondary,
                                    ),
                          ),
                          trailing: Text(
                            _formatDateTime(item['timestamp']),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppTheme.lightTextSecondary,
                                    ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: AppConstants.largePadding),

              // Table Sync Status
              if (_syncStatus['tables'] != null) ...[
                MobileCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Table Sync Status',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppConstants.defaultPadding),
                      ...(_syncStatus['tables'] as Map<String, dynamic>)
                          .entries
                          .map(
                            (entry) => MobileListTile(
                              title: Text(
                                entry.key.replaceAll('_', ' ').toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                              subtitle: Text(
                                entry.value != null
                                    ? 'Last sync: ${_formatDateTime(entry.value)}'
                                    : 'Never synced',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall
                                    ?.copyWith(
                                      color: AppTheme.lightTextSecondary,
                                    ),
                              ),
                              trailing: Icon(
                                entry.value != null
                                    ? Icons.check_circle
                                    : Icons.sync_problem,
                                color: entry.value != null
                                    ? AppTheme.successColor
                                    : AppTheme.warningColor,
                              ),
                            ),
                          ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  IconData _getActionIcon(String action) {
    switch (action.toLowerCase()) {
      case 'create':
        return Icons.add_circle;
      case 'update':
        return Icons.edit;
      case 'delete':
        return Icons.delete;
      default:
        return Icons.sync;
    }
  }

  String _formatDateTime(String? dateTimeString) {
    if (dateTimeString == null) return 'Never';

    try {
      final dateTime = DateTime.parse(dateTimeString);
      final now = DateTime.now();
      final difference = now.difference(dateTime);

      if (difference.inMinutes < 1) {
        return 'Just now';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minutes ago';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} hours ago';
      } else {
        return '${difference.inDays} days ago';
      }
    } catch (e) {
      return 'Invalid date';
    }
  }
}
