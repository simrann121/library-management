// Synchronization Service for Vidyalankar Library Management System

import 'dart:convert';
import 'package:dio/dio.dart';
import '../../core/services/offline_storage_service.dart';

class SyncService {
  static final Dio _dio = Dio();
  static bool _isSyncing = false;
  static DateTime? _lastSyncTime;

  // Initialize sync service
  static void initialize({required String baseUrl}) {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);

    // Add interceptors for authentication and error handling
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add authentication token if available
        final token = OfflineStorageService.prefs.getString('auth_token');
        if (token != null) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        handler.next(options);
      },
      onError: (error, handler) {
        // Handle network errors
        if (error.type == DioExceptionType.connectionTimeout ||
            error.type == DioExceptionType.receiveTimeout) {
          // Network timeout - will retry later
          handler.next(error);
        } else {
          handler.next(error);
        }
      },
    ));
  }

  // Check if sync is in progress
  static bool get isSyncing => _isSyncing;

  // Get last sync time
  static DateTime? get lastSyncTime => _lastSyncTime;

  // Full synchronization
  static Future<SyncResult> performFullSync() async {
    if (_isSyncing) {
      return SyncResult(
        success: false,
        message: 'Sync already in progress',
        syncedRecords: 0,
      );
    }

    _isSyncing = true;
    int totalSyncedRecords = 0;
    List<String> errors = [];

    try {
      // Sync users
      final usersResult = await _syncUsers();
      totalSyncedRecords += usersResult.syncedRecords;
      if (!usersResult.success) {
        errors.add('Users: ${usersResult.message}');
      }

      // Sync books
      final booksResult = await _syncBooks();
      totalSyncedRecords += booksResult.syncedRecords;
      if (!booksResult.success) {
        errors.add('Books: ${booksResult.message}');
      }

      // Sync borrowed books
      final borrowedBooksResult = await _syncBorrowedBooks();
      totalSyncedRecords += borrowedBooksResult.syncedRecords;
      if (!borrowedBooksResult.success) {
        errors.add('Borrowed Books: ${borrowedBooksResult.message}');
      }

      // Sync library logs
      final logsResult = await _syncLibraryLogs();
      totalSyncedRecords += logsResult.syncedRecords;
      if (!logsResult.success) {
        errors.add('Library Logs: ${logsResult.message}');
      }

      // Process offline queue
      final queueResult = await _processOfflineQueue();
      totalSyncedRecords += queueResult.syncedRecords;
      if (!queueResult.success) {
        errors.add('Offline Queue: ${queueResult.message}');
      }

      _lastSyncTime = DateTime.now();

      return SyncResult(
        success: errors.isEmpty,
        message:
            errors.isEmpty ? 'Sync completed successfully' : errors.join(', '),
        syncedRecords: totalSyncedRecords,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Sync failed: ${e.toString()}',
        syncedRecords: totalSyncedRecords,
      );
    } finally {
      _isSyncing = false;
    }
  }

  // Sync users
  static Future<SyncResult> _syncUsers() async {
    try {
      final lastSync = await OfflineStorageService.getSyncStatus('users');
      final lastSyncTime = lastSync?['lastSyncTime'];

      final response = await _dio.get('/api/users', queryParameters: {
        if (lastSyncTime != null) 'since': lastSyncTime,
      });

      if (response.statusCode == 200) {
        final users = response.data['data'] as List;
        int syncedCount = 0;

        for (final user in users) {
          await OfflineStorageService.saveUser(user);
          syncedCount++;
        }

        await OfflineStorageService.updateSyncStatus(
          'users',
          DateTime.now().toIso8601String(),
          syncToken: response.data['syncToken'],
        );

        return SyncResult(
          success: true,
          message: 'Users synced successfully',
          syncedRecords: syncedCount,
        );
      }

      return SyncResult(
        success: false,
        message: 'Failed to sync users: ${response.statusCode}',
        syncedRecords: 0,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Error syncing users: ${e.toString()}',
        syncedRecords: 0,
      );
    }
  }

  // Sync books
  static Future<SyncResult> _syncBooks() async {
    try {
      final lastSync = await OfflineStorageService.getSyncStatus('books');
      final lastSyncTime = lastSync?['lastSyncTime'];

      final response = await _dio.get('/api/books', queryParameters: {
        if (lastSyncTime != null) 'since': lastSyncTime,
      });

      if (response.statusCode == 200) {
        final books = response.data['data'] as List;
        int syncedCount = 0;

        for (final book in books) {
          await OfflineStorageService.saveBook(book);
          syncedCount++;
        }

        await OfflineStorageService.updateSyncStatus(
          'books',
          DateTime.now().toIso8601String(),
          syncToken: response.data['syncToken'],
        );

        return SyncResult(
          success: true,
          message: 'Books synced successfully',
          syncedRecords: syncedCount,
        );
      }

      return SyncResult(
        success: false,
        message: 'Failed to sync books: ${response.statusCode}',
        syncedRecords: 0,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Error syncing books: ${e.toString()}',
        syncedRecords: 0,
      );
    }
  }

  // Sync borrowed books
  static Future<SyncResult> _syncBorrowedBooks() async {
    try {
      final lastSync =
          await OfflineStorageService.getSyncStatus('borrowed_books');
      final lastSyncTime = lastSync?['lastSyncTime'];

      final response = await _dio.get('/api/borrowed-books', queryParameters: {
        if (lastSyncTime != null) 'since': lastSyncTime,
      });

      if (response.statusCode == 200) {
        final borrowedBooks = response.data['data'] as List;
        int syncedCount = 0;

        for (final borrowedBook in borrowedBooks) {
          await OfflineStorageService.saveBorrowedBook(borrowedBook);
          syncedCount++;
        }

        await OfflineStorageService.updateSyncStatus(
          'borrowed_books',
          DateTime.now().toIso8601String(),
          syncToken: response.data['syncToken'],
        );

        return SyncResult(
          success: true,
          message: 'Borrowed books synced successfully',
          syncedRecords: syncedCount,
        );
      }

      return SyncResult(
        success: false,
        message: 'Failed to sync borrowed books: ${response.statusCode}',
        syncedRecords: 0,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Error syncing borrowed books: ${e.toString()}',
        syncedRecords: 0,
      );
    }
  }

  // Sync library logs
  static Future<SyncResult> _syncLibraryLogs() async {
    try {
      final lastSync =
          await OfflineStorageService.getSyncStatus('library_logs');
      final lastSyncTime = lastSync?['lastSyncTime'];

      final response = await _dio.get('/api/library-logs', queryParameters: {
        if (lastSyncTime != null) 'since': lastSyncTime,
      });

      if (response.statusCode == 200) {
        final logs = response.data['data'] as List;
        int syncedCount = 0;

        for (final log in logs) {
          await OfflineStorageService.saveLibraryLog(log);
          syncedCount++;
        }

        await OfflineStorageService.updateSyncStatus(
          'library_logs',
          DateTime.now().toIso8601String(),
          syncToken: response.data['syncToken'],
        );

        return SyncResult(
          success: true,
          message: 'Library logs synced successfully',
          syncedRecords: syncedCount,
        );
      }

      return SyncResult(
        success: false,
        message: 'Failed to sync library logs: ${response.statusCode}',
        syncedRecords: 0,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Error syncing library logs: ${e.toString()}',
        syncedRecords: 0,
      );
    }
  }

  // Process offline queue
  static Future<SyncResult> _processOfflineQueue() async {
    try {
      final queue = await OfflineStorageService.getOfflineQueue();
      int syncedCount = 0;
      List<String> errors = [];

      for (final item in queue) {
        try {
          final success = await _processOfflineQueueItem(item);
          if (success) {
            await OfflineStorageService.removeFromOfflineQueue(item['id']);
            syncedCount++;
          } else {
            await OfflineStorageService.incrementRetryCount(item['id']);
            errors.add('Failed to sync item ${item['id']}');
          }
        } catch (e) {
          await OfflineStorageService.incrementRetryCount(item['id']);
          errors.add('Error syncing item ${item['id']}: ${e.toString()}');
        }
      }

      return SyncResult(
        success: errors.isEmpty,
        message: errors.isEmpty
            ? 'Offline queue processed successfully'
            : errors.join(', '),
        syncedRecords: syncedCount,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Error processing offline queue: ${e.toString()}',
        syncedRecords: 0,
      );
    }
  }

  // Process individual offline queue item
  static Future<bool> _processOfflineQueueItem(
      Map<String, dynamic> item) async {
    try {
      final action = item['action'] as String;
      final tableName = item['tableName'] as String;
      final recordId = item['recordId'] as String;
      final data = jsonDecode(item['data'] as String) as Map<String, dynamic>;

      Response response;

      switch (action) {
        case 'create':
          response = await _dio.post('/api/$tableName', data: data);
          break;
        case 'update':
          response = await _dio.put('/api/$tableName/$recordId', data: data);
          break;
        case 'delete':
          response = await _dio.delete('/api/$tableName/$recordId');
          break;
        default:
          return false;
      }

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  // Upload local changes
  static Future<SyncResult> uploadLocalChanges() async {
    try {
      final queue = await OfflineStorageService.getOfflineQueue();
      int uploadedCount = 0;
      List<String> errors = [];

      for (final item in queue) {
        try {
          final success = await _processOfflineQueueItem(item);
          if (success) {
            await OfflineStorageService.removeFromOfflineQueue(item['id']);
            uploadedCount++;
          } else {
            errors.add('Failed to upload item ${item['id']}');
          }
        } catch (e) {
          errors.add('Error uploading item ${item['id']}: ${e.toString()}');
        }
      }

      return SyncResult(
        success: errors.isEmpty,
        message: errors.isEmpty
            ? 'Local changes uploaded successfully'
            : errors.join(', '),
        syncedRecords: uploadedCount,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Error uploading local changes: ${e.toString()}',
        syncedRecords: 0,
      );
    }
  }

  // Download latest data
  static Future<SyncResult> downloadLatestData() async {
    try {
      int totalDownloaded = 0;

      // Download users
      final usersResult = await _syncUsers();
      totalDownloaded += usersResult.syncedRecords;

      // Download books
      final booksResult = await _syncBooks();
      totalDownloaded += booksResult.syncedRecords;

      // Download borrowed books
      final borrowedBooksResult = await _syncBorrowedBooks();
      totalDownloaded += borrowedBooksResult.syncedRecords;

      // Download library logs
      final logsResult = await _syncLibraryLogs();
      totalDownloaded += logsResult.syncedRecords;

      return SyncResult(
        success: true,
        message: 'Latest data downloaded successfully',
        syncedRecords: totalDownloaded,
      );
    } catch (e) {
      return SyncResult(
        success: false,
        message: 'Error downloading latest data: ${e.toString()}',
        syncedRecords: 0,
      );
    }
  }

  // Check sync status
  static Future<Map<String, dynamic>> getSyncStatus() async {
    final usersSync = await OfflineStorageService.getSyncStatus('users');
    final booksSync = await OfflineStorageService.getSyncStatus('books');
    final borrowedBooksSync =
        await OfflineStorageService.getSyncStatus('borrowed_books');
    final logsSync = await OfflineStorageService.getSyncStatus('library_logs');
    final queue = await OfflineStorageService.getOfflineQueue();

    return {
      'lastSyncTime': _lastSyncTime?.toIso8601String(),
      'isSyncing': _isSyncing,
      'pendingUploads': queue.length,
      'tables': {
        'users': usersSync?['lastSyncTime'],
        'books': booksSync?['lastSyncTime'],
        'borrowed_books': borrowedBooksSync?['lastSyncTime'],
        'library_logs': logsSync?['lastSyncTime'],
      },
    };
  }
}

// Sync result class
class SyncResult {
  final bool success;
  final String message;
  final int syncedRecords;

  SyncResult({
    required this.success,
    required this.message,
    required this.syncedRecords,
  });
}
